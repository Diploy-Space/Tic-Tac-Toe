import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../services/app_update_service.dart';
import '../services/sfx_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/painters.dart';
import '../l10n/app_localizations.dart';

/// "Update available" screen. Route `/app-update`, argument: [UpdateCheck].
/// When the update is required (below the minimum supported version) there
/// is no way back — the user must update.
class AppUpdateScreen extends StatefulWidget {
  const AppUpdateScreen({super.key});

  @override
  State<AppUpdateScreen> createState() => _AppUpdateScreenState();
}

enum _Phase { idle, downloading, needsPermission, installing, error }

class _AppUpdateScreenState extends State<AppUpdateScreen>
    with WidgetsBindingObserver {
  late UpdateCheck _check;
  bool _init = false;
  _Phase _phase = _Phase.idle;
  double _progress = 0;
  String? _error;
  File? _apk;
  CancelToken? _cancel;

  AppRelease get _r => _check.release;
  bool get _busy => _phase == _Phase.downloading || _phase == _Phase.installing;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) return;
    _init = true;
    _check = ModalRoute.of(context)!.settings.arguments as UpdateCheck;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cancel?.cancel();
    super.dispose();
  }

  /// Back from "Install unknown apps" settings → continue installing.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _phase == _Phase.needsPermission &&
        _apk != null) {
      _install();
    }
  }

  Future<void> _start() async {
    if (_busy) return;
    setState(() {
      _error = null;
    });
    try {
      if (Platform.isIOS) {
        await AppUpdateService.openAppStore(_r);
        return;
      }
      if (_apk == null || !await _apk!.exists()) {
        _cancel = CancelToken();
        setState(() {
          _phase = _Phase.downloading;
          _progress = 0;
        });
        _apk = await AppUpdateService.downloadApk(
          _r,
          cancelToken: _cancel,
          onProgress: (p) {
            if (mounted) setState(() => _progress = p);
          },
        );
      }
      await _install();
    } catch (e) {
      _fail(e);
    }
  }

  Future<void> _install() async {
    final apk = _apk;
    if (apk == null) return;
    try {
      if (!await AppUpdateService.canInstall()) {
        if (!mounted) return;
        setState(() => _phase = _Phase.needsPermission);
        return;
      }
      if (!mounted) return;
      setState(() => _phase = _Phase.installing);
      await AppUpdateService.installApk(apk);
      // The system installer is now on top; let the user retry if they
      // cancel it.
      if (mounted) setState(() => _phase = _Phase.idle);
    } catch (e) {
      _fail(e);
    }
  }

  void _fail(Object e) {
    if (!mounted) return;
    if (e is UpdateException && e.message == 'Download cancelled.') {
      setState(() {
        _phase = _Phase.idle;
        _progress = 0;
      });
      return;
    }
    SfxService.play(Sfx.error);
    setState(() {
      _phase = _Phase.error;
      _error = e is UpdateException
          ? e.message
          : context.l10n.somethingWentWrongDetail('$e');
    });
  }

  String get _sizeText {
    final b = _r.apkSizeBytes;
    if (b == null || b <= 0) return '';
    return ' · ${(b / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String get _buttonLabel {
    if (Platform.isIOS) return context.l10n.updateOnAppStore;
    return switch (_phase) {
      _Phase.downloading => _progress >= 0
          ? context.l10n.downloadingPercent('${(_progress * 100).round()}')
          : context.l10n.downloading,
      _Phase.installing => context.l10n.openingInstaller,
      _Phase.needsPermission => context.l10n.allowAndInstall,
      _Phase.error => context.l10n.tryAgain,
      _Phase.idle => _apk != null
          ? context.l10n.installUpdate
          : context.l10n.downloadAndInstall,
    };
  }

  Widget _versionRow(String label, String value, {Color? color}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          Text(label, style: const TextStyle(color: C.muted, fontSize: 14)),
          const Spacer(),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: color ?? C.text)),
        ]),
      );

  Widget _card({required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: C.border),
        ),
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    final required = _check.isRequired;
    return PopScope(
      canPop: !required && !_busy,
      child: AppScaffold(
        doll: false,
        child: Column(children: [
          if (!required) TopBar(context.l10n.appUpdate),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 18),
              child: Column(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: const AppLogoMark(size: 84),
                ),
                const SizedBox(height: 16),
                Text(
                    required
                        ? context.l10n.updateRequired
                        : context.l10n.updateAvailable,
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(
                  required
                      ? context.l10n.versionUnsupported
                      : context.l10n.newVersionReady,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: C.muted, fontSize: 14.5),
                ),
                const SizedBox(height: 20),
                _card(
                  child: Column(children: [
                    _versionRow(context.l10n.newVersion,
                        '${_r.versionName} (${_r.versionCode})$_sizeText',
                        color: C.teal),
                    const Divider(color: C.border, height: 8),
                    _versionRow(context.l10n.installed,
                        '${_check.installed.name} (${_check.installed.code})'),
                    if (_r.publishedAt != null) ...[
                      const Divider(color: C.border, height: 8),
                      _versionRow(context.l10n.released, _r.publishedAt!),
                    ],
                  ]),
                ),
                if (_r.releaseNotes.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  _card(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.l10n.whatsNewCaps,
                              style: const TextStyle(
                                  color: C.teal,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 2)),
                          const SizedBox(height: 8),
                          for (final n in _r.releaseNotes)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('•  ',
                                        style: TextStyle(color: C.teal)),
                                    Expanded(
                                        child: Text(n,
                                            style:
                                                const TextStyle(height: 1.4))),
                                  ]),
                            ),
                        ]),
                  ),
                ],
              ]),
            ),
          ),
          if (_phase == _Phase.downloading) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                minHeight: 6,
                value: _progress >= 0 ? _progress : null,
                backgroundColor: C.border,
                color: C.teal,
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (_phase == _Phase.needsPermission)
            _note(Icons.shield_outlined, C.coin, context.l10n.allowUnknownApps),
          if (_error != null) _note(Icons.error_outline, C.danger, _error!),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              _buttonLabel,
              color: C.teal,
              fg: const Color(0xFF04201F),
              onTap: _busy
                  ? null
                  : _phase == _Phase.needsPermission
                      ? AppUpdateService.openInstallSettings
                      : _start,
            ),
          ),
          if (_phase == _Phase.downloading) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: GhostButton(context.l10n.cancelDownload,
                  onTap: () => _cancel?.cancel()),
            ),
          ] else if (!required) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: GhostButton(context.l10n.later,
                  onTap: _busy ? null : () => Navigator.maybePop(context)),
            ),
          ],
        ]),
      ),
    );
  }

  Widget _note(IconData icon, Color color, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
              child: Text(text,
                  style: TextStyle(color: color, fontSize: 13, height: 1.4))),
        ]),
      );
}
