import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tic_tac_game/config/supabase_config.dart';
import 'package:tic_tac_game/models.dart';
import 'package:tic_tac_game/services/ad_reward_service.dart';
import 'package:tic_tac_game/services/rewarded_ad_service.dart';

/// Guest wallet (local coins): one completed ad pays exactly once.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.publishableKey,
    );
  });

  Future<AdRewardStatus> pay(AdReceipt r) => AdRewardService.credit(r,
      amount: 20, reason: 'ad_reward', refType: 'rewarded_ad');

  test('a receipt is credited once; repeats are blocked', () async {
    coins.value = 100;
    final r = AdReceipt.forTest('r1');
    expect(await pay(r), AdRewardStatus.credited);
    expect(coins.value, 120);
    expect(await pay(r), AdRewardStatus.alreadyCredited);
    expect(await pay(r), AdRewardStatus.alreadyCredited);
    expect(coins.value, 120);
    expect(AdRewardService.isCredited(r), isTrue);
  });

  test('two taps at the same time pay once', () async {
    coins.value = 0;
    final r = AdReceipt.forTest('r2');
    final results = await Future.wait([pay(r), pay(r), pay(r)]);
    expect(results.where((s) => s == AdRewardStatus.credited).length, 1);
    expect(coins.value, 20);
  });

  test('different completed ads each pay', () async {
    coins.value = 0;
    await pay(AdReceipt.forTest('a'));
    await pay(AdReceipt.forTest('b'));
    expect(coins.value, 40);
  });
}
