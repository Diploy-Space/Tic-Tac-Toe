import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_game/services/connectivity_service.dart';

void main() {
  group('ConnectivityService status', () {
    tearDown(() {
      // Reset notifier so other tests are not affected.
      ConnectivityService.instance.status.value = AppConnectivity.checking;
    });

    test('isOnline / isOffline track AppConnectivity', () {
      final svc = ConnectivityService.instance;

      svc.status.value = AppConnectivity.checking;
      expect(svc.isOnline, isFalse);
      expect(svc.isOffline, isFalse);

      svc.status.value = AppConnectivity.online;
      expect(svc.isOnline, isTrue);
      expect(svc.isOffline, isFalse);

      svc.status.value = AppConnectivity.offline;
      expect(svc.isOnline, isFalse);
      expect(svc.isOffline, isTrue);
    });

    test('probe timeout and debounce constants match Phase D spec', () {
      expect(ConnectivityService.probeTimeout, const Duration(seconds: 5));
      expect(
        ConnectivityService.debounceDelay.inMilliseconds,
        inInclusiveRange(1000, 2000),
      );
    });
  });
}
