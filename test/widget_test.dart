import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tic_tac_game/config/supabase_config.dart';
import 'package:tic_tac_game/main.dart';
import 'package:tic_tac_game/models.dart';

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
    introSeen.value = false;
    await tester.pumpWidget(const TicTacApp());
    // AppScaffold / landing use looping animations — avoid pumpAndSettle.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    // Heading renders labels in uppercase.
    expect(find.text('OUTSMART THE DOLL'), findsOneWidget);
  });
}
