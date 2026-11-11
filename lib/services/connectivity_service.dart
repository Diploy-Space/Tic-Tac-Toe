import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../config/supabase_config.dart';

/// Reactive connectivity: interface changes are not enough — we probe Supabase.
enum AppConnectivity {
  checking,
  online,
  offline,
}

/// App-wide online/offline monitor. Init once from [main]; dispose with the app.
class ConnectivityService with WidgetsBindingObserver {
  ConnectivityService._();
  static final ConnectivityService instance = ConnectivityService._();

  static const debounceDelay = Duration(milliseconds: 1500);
  static const probeTimeout = Duration(seconds: 5);

  final ValueNotifier<AppConnectivity> status =
      ValueNotifier<AppConnectivity>(AppConnectivity.checking);

  bool get isOnline => status.value == AppConnectivity.online;
  bool get isOffline => status.value == AppConnectivity.offline;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _sub;
  Timer? _debounce;
  Future<bool>? _inFlight;
  bool _started = false;
  bool _disposed = false;

  Future<void> init() async {
    if (_started) return;
    _started = true;
    _disposed = false;
    WidgetsBinding.instance.addObserver(this);
    _sub = _connectivity.onConnectivityChanged.listen(_onInterfaceChange);
    await _probe();
  }

  void _onInterfaceChange(List<ConnectivityResult> _) {
    if (_disposed) return;
    status.value = AppConnectivity.checking;
    _debounce?.cancel();
    _debounce = Timer(debounceDelay, () {
      unawaited(_probe());
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_disposed) return;
    if (state == AppLifecycleState.resumed) {
      unawaited(retry());
    }
  }

  /// Manual / OfflineScreen "Try again".
  Future<bool> retry() => _probe();

  /// Force a fresh reachability check before an online-only action.
  Future<bool> ensureOnline() => _probe();

  /// Coalesced reachability probe. Does not treat link-up alone as online.
  Future<bool> _probe() {
    if (_disposed) return Future<bool>.value(false);
    final existing = _inFlight;
    if (existing != null) return existing;

    final future = _runProbe();
    _inFlight = future;
    future.whenComplete(() {
      if (identical(_inFlight, future)) _inFlight = null;
    });
    return future;
  }

  Future<bool> _runProbe() async {
    if (_disposed) return false;
    status.value = AppConnectivity.checking;

    try {
      final links = await _connectivity.checkConnectivity();
      final hasLink = links.any((r) => r != ConnectivityResult.none);
      if (!hasLink) {
        status.value = AppConnectivity.offline;
        return false;
      }

      final uri = Uri.parse(SupabaseConfig.url);
      final response = await http
          .get(uri, headers: const {'Connection': 'close'})
          .timeout(probeTimeout);

      // Any HTTP response means the host was reachable (incl. 4xx/5xx).
      final online = response.statusCode > 0;
      status.value =
          online ? AppConnectivity.online : AppConnectivity.offline;
      return online;
    } catch (e) {
      debugPrint('ConnectivityService: offline ($e)');
      status.value = AppConnectivity.offline;
      return false;
    }
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _debounce?.cancel();
    _debounce = null;
    unawaited(_sub?.cancel());
    _sub = null;
    _inFlight = null;
    WidgetsBinding.instance.removeObserver(this);
    _started = false;
  }
}
