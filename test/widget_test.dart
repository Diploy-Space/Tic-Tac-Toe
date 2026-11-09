import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tic_tac_game/config/supabase_config.dart';
import 'package:tic_tac_game/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.publishableKey,
    );
  });

  testWidgets('TicTacApp shows the onboarding screen', (tester) async {
    await tester.pumpWidget(const TicTacApp());
    await tester.pumpAndSettle();

    expect(find.text('Outsmart the Doll'), findsOneWidget);
  });
}
