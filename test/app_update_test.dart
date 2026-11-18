import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_game/services/app_update_service.dart';

void main() {
  AppRelease release({
    int code = 5,
    int min = 1,
    bool available = true,
  }) =>
      AppRelease.fromJson({
        'update_available': available,
        'latest_version_name': '1.2.0',
        'latest_version_code': code,
        'min_supported_version_code': min,
        'apk_url': 'https://x.supabase.co/storage/v1/object/public/app-updates/a.apk',
        'apk_sha256': 'A' * 64,
        'release_notes': ['One', ' ', 'Two'],
      });

  group('statusFor', () {
    test('older install sees an update', () {
      expect(AppUpdateService.statusFor(4, release()), UpdateStatus.available);
    });
    test('same or newer install is up to date', () {
      expect(AppUpdateService.statusFor(5, release()), UpdateStatus.upToDate);
      expect(AppUpdateService.statusFor(9, release()), UpdateStatus.upToDate);
    });
    test('below minimum supported is required', () {
      expect(AppUpdateService.statusFor(2, release(min: 3)),
          UpdateStatus.required);
    });
    test('update_available=false hides optional updates', () {
      expect(AppUpdateService.statusFor(4, release(available: false)),
          UpdateStatus.upToDate);
    });
    test('…but never a required one', () {
      expect(AppUpdateService.statusFor(1, release(min: 3, available: false)),
          UpdateStatus.required);
    });
  });

  group('AppRelease.fromJson', () {
    test('parses fields, lower-cases sha, drops blank notes', () {
      final r = release();
      expect(r.versionName, '1.2.0');
      expect(r.versionCode, 5);
      expect(r.apkSha256, 'a' * 64);
      expect(r.releaseNotes, ['One', 'Two']);
    });
    test('accepts string numbers and newline notes', () {
      final r = AppRelease.fromJson({
        'latest_version_code': '7',
        'min_supported_version_code': '2',
        'release_notes': 'Fix A\n\nFix B',
      });
      expect(r.versionCode, 7);
      expect(r.minSupportedVersionCode, 2);
      expect(r.releaseNotes, ['Fix A', 'Fix B']);
      expect(r.updateAvailable, isTrue);
    });
    test('sample supabase/app-updates/update.json is valid', () {
      final j = jsonDecode(
          File('supabase/app-updates/update.json').readAsStringSync());
      final r = AppRelease.fromJson(Map<String, dynamic>.from(j as Map));
      expect(r.versionCode, greaterThan(0));
      expect(r.apkUrl, startsWith('https://'));
    });
  });
}
