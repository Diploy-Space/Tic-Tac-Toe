import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/supabase_config.dart';

/// Release info read from `update.json` in the Supabase Storage bucket
/// [AppUpdateService.bucket]. Upload a new APK + edit this file to ship an
/// update — no app change needed.
class AppRelease {
  final bool updateAvailable;
  final String versionName;
  final int versionCode;
  final int minSupportedVersionCode;
  final String? apkUrl;
  final String? apkSha256;
  final int? apkSizeBytes;
  final List<String> releaseNotes;
  final String? iosAppStoreUrl;
  final String? publishedAt;

  const AppRelease({
    required this.updateAvailable,
    required this.versionName,
    required this.versionCode,
    required this.minSupportedVersionCode,
    required this.releaseNotes,
    this.apkUrl,
    this.apkSha256,
    this.apkSizeBytes,
    this.iosAppStoreUrl,
    this.publishedAt,
  });

  factory AppRelease.fromJson(Map<String, dynamic> j) {
    int toInt(Object? v) => v is num ? v.toInt() : int.tryParse('$v') ?? 0;
    String? str(Object? v) {
      final s = v?.toString().trim();
      return s == null || s.isEmpty ? null : s;
    }

    final notes = j['release_notes'];
    return AppRelease(
      updateAvailable: j['update_available'] != false,
      versionName: str(j['latest_version_name']) ?? '',
      versionCode: toInt(j['latest_version_code']),
      minSupportedVersionCode: toInt(j['min_supported_version_code']),
      apkUrl: str(j['apk_url']),
      apkSha256: str(j['apk_sha256'])?.toLowerCase(),
      apkSizeBytes: j['apk_size_bytes'] == null ? null : toInt(j['apk_size_bytes']),
      releaseNotes: notes is List
          ? [for (final n in notes) if ('$n'.trim().isNotEmpty) '$n'.trim()]
          : [
              for (final l in '${notes ?? ''}'.split('\n'))
                if (l.trim().isNotEmpty) l.trim()
            ],
      iosAppStoreUrl: str(j['ios_app_store_url']),
      publishedAt: str(j['published_at']),
    );
  }
}

/// Installed version as reported by the OS.
class InstalledVersion {
  final String name;
  final int code;
  const InstalledVersion(this.name, this.code);
}

enum UpdateStatus { upToDate, available, required }

/// Result of [AppUpdateService.check].
class UpdateCheck {
  final UpdateStatus status;
  final InstalledVersion installed;
  final AppRelease release;
  const UpdateCheck(this.status, this.installed, this.release);

  bool get hasUpdate => status != UpdateStatus.upToDate;
  bool get isRequired => status == UpdateStatus.required;
}

class UpdateException implements Exception {
  final String message;
  const UpdateException(this.message);
  @override
  String toString() => message;
}

/// Checks Supabase for a newer release and installs it.
///
/// Android: downloads the APK with dio, verifies its SHA-256, then hands it
/// to the system installer. iOS: opens the App Store page.
class AppUpdateService {
  AppUpdateService._();

  /// Public Storage bucket that holds `update.json` and the APKs.
  static const bucket = 'app-updates';
  static const manifestFile = 'update.json';

  static const _channel = MethodChannel('drotix/app_update');
  static final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 30),
  ));

  /// Only Android and iOS builds can update themselves.
  static bool get supported =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  static Uri get manifestUri => Uri.parse(
      '${SupabaseConfig.url}/storage/v1/object/public/$bucket/$manifestFile');

  static Future<InstalledVersion> installedVersion() async {
    final info = await PackageInfo.fromPlatform();
    return InstalledVersion(info.version, int.tryParse(info.buildNumber) ?? 0);
  }

  /// Reads `update.json` (never cached) and compares with this install.
  static Future<UpdateCheck> check() async {
    final installed = await installedVersion();
    final Response<dynamic> res;
    try {
      res = await _dio.getUri<dynamic>(
        manifestUri.replace(queryParameters: {
          't': '${DateTime.now().millisecondsSinceEpoch}',
        }),
        options: Options(
          responseType: ResponseType.json,
          headers: {'Cache-Control': 'no-cache'},
        ),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 404) {
        throw const UpdateException('No update information published yet.');
      }
      throw const UpdateException(
          'Could not reach the update server. Check your connection.');
    }
    var data = res.data;
    if (data is String) data = _decode(data);
    if (data is! Map) {
      throw const UpdateException('Update information is invalid.');
    }
    final release = AppRelease.fromJson(Map<String, dynamic>.from(data));
    return UpdateCheck(statusFor(installed.code, release), installed, release);
  }

  /// Pure comparison, unit-tested.
  static UpdateStatus statusFor(int installedCode, AppRelease r) {
    if (installedCode < r.minSupportedVersionCode) return UpdateStatus.required;
    if (r.updateAvailable && r.versionCode > installedCode) {
      return UpdateStatus.available;
    }
    return UpdateStatus.upToDate;
  }

  static Object? _decode(String s) {
    try {
      return jsonDecode(s);
    } catch (_) {
      return null;
    }
  }

  // ---- Android: download + install -----------------------------------

  /// Downloads the APK to `<cache>/updates/` and verifies it.
  /// [onProgress] gets 0..1 (or -1 when the size is unknown).
  static Future<File> downloadApk(
    AppRelease r, {
    required void Function(double progress) onProgress,
    CancelToken? cancelToken,
  }) async {
    final url = r.apkUrl;
    final uri = url == null ? null : Uri.tryParse(url);
    if (uri == null || uri.scheme != 'https') {
      throw const UpdateException('Download link is missing or not secure.');
    }
    final expected = r.apkSha256;
    if (expected == null || !RegExp(r'^[0-9a-f]{64}$').hasMatch(expected)) {
      throw const UpdateException(
          'Update is missing its security checksum. Please try again later.');
    }

    final dir = Directory('${(await getTemporaryDirectory()).path}/updates');
    if (await dir.exists()) {
      // Old downloads are useless once a new one starts.
      await for (final f in dir.list()) {
        try {
          await f.delete(recursive: true);
        } catch (_) {}
      }
    } else {
      await dir.create(recursive: true);
    }
    final file = File('${dir.path}/drotix-${r.versionCode}.apk');

    try {
      await _dio.downloadUri(
        uri,
        file.path,
        cancelToken: cancelToken,
        deleteOnError: true,
        options: Options(receiveTimeout: const Duration(minutes: 10)),
        onReceiveProgress: (got, total) {
          final size = total > 0 ? total : (r.apkSizeBytes ?? 0);
          onProgress(size > 0 ? (got / size).clamp(0.0, 1.0) : -1);
        },
      );
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        throw const UpdateException('Download cancelled.');
      }
      throw const UpdateException('Download failed. Check your connection.');
    }

    final digest = await sha256.bind(file.openRead()).first;
    if (digest.toString() != expected) {
      await file.delete();
      throw const UpdateException(
          'Downloaded file failed the security check and was deleted.');
    }
    return file;
  }

  /// Whether Android lets DROTIX install APKs ("Install unknown apps").
  static Future<bool> canInstall() async =>
      await _channel.invokeMethod<bool>('canInstall') ?? false;

  static Future<void> openInstallSettings() =>
      _channel.invokeMethod<void>('openInstallSettings');

  /// Opens the Android installer for [apk].
  static Future<void> installApk(File apk) async {
    try {
      await _channel.invokeMethod<bool>('installApk', {'path': apk.path});
    } on PlatformException catch (e) {
      throw UpdateException(e.message ?? 'Could not start the installer.');
    }
  }

  // ---- iOS -----------------------------------------------------------

  static Future<void> openAppStore(AppRelease r) async {
    final url = r.iosAppStoreUrl;
    final uri = url == null ? null : Uri.tryParse(url);
    if (uri == null) {
      throw const UpdateException('App Store link is not available yet.');
    }
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) throw const UpdateException('Could not open the App Store.');
  }
}
