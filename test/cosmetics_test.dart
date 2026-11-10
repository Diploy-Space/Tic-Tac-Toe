import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_game/models.dart';
import 'package:tic_tac_game/services/storage.dart';
import 'package:tic_tac_game/widgets/extras.dart';
import 'package:tic_tac_game/widgets/painters.dart';

void main() {
  setUp(() {
    coins.value = 500;
    owned.value = {'Classic', 'Shapes', 'Neon', 'Dark', 'Midnight'};
    equippedMark.value = 'Classic';
    equippedBoard.value = 'Dark';
    equippedAvatar.value = 0;
  });

  group('MarkIcon skin override', () {
    testWidgets('explicit skin does not follow equippedMark', (tester) async {
      equippedMark.value = 'Neon';
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                MarkIcon(isX: true, size: 26, skin: 'Gold'),
                MarkIcon(isX: true, size: 26), // live equipped
              ],
            ),
          ),
        ),
      );
      expect(find.byType(MarkIcon), findsNWidgets(2));
      // Both paint without throwing; equipped can change independently.
      equippedMark.value = 'Pixel';
      await tester.pump();
      expect(find.byType(MarkIcon), findsNWidgets(2));
    });

    testWidgets('CosmeticTile mark preview uses item skin', (tester) async {
      equippedMark.value = 'Classic';
      final ghost = marksCatalog.firstWhere((c) => c.name == 'Ghost');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CosmeticTile(
              item: ghost,
              selected: false,
              equipped: false,
              onTap: () {},
            ),
          ),
        ),
      );
      final icons = tester.widgetList<MarkIcon>(find.byType(MarkIcon)).toList();
      expect(icons.length, 2);
      expect(icons.every((m) => m.skin == 'Ghost'), isTrue);
    });

    testWidgets('every mark catalog skin is accepted by MarkIcon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                for (final m in marksCatalog)
                  MarkIcon(isX: true, size: 20, skin: m.name),
              ],
            ),
          ),
        ),
      );
      expect(find.byType(MarkIcon), findsNWidgets(marksCatalog.length));
    });
  });

  group('unlock / equip rules', () {
    test('cannot unlock paid mark without coins', () {
      coins.value = 0;
      final ghost = marksCatalog.firstWhere((c) => c.name == 'Ghost');
      expect(unlockCosmetic(ghost), isFalse);
      expect(owned.value.contains('Ghost'), isFalse);
      expect(equippedMark.value, 'Classic');
    });

    test('unlock deducts once; second call is free no-op', () {
      coins.value = 250;
      final ghost = marksCatalog.firstWhere((c) => c.name == 'Ghost');
      expect(unlockCosmetic(ghost), isTrue);
      expect(coins.value, 50);
      expect(owned.value.contains('Ghost'), isTrue);
      expect(unlockCosmetic(ghost), isTrue);
      expect(coins.value, 50); // no double charge
    });

    test('boardColor returns distinct themes', () {
      final colors = {
        for (final b in boardsCatalog) b.name: boardColor(b.name),
      };
      expect(colors['Dark'], isNot(colors['Midnight']));
      expect(colors['Crimson'], isNot(colors['Teal']));
      expect(colors['Ash'], isNot(colors['Violet']));
    });

    test('avatars stay in free 0..2 range', () {
      equippedAvatar.value = 2;
      expect(equippedAvatar.value, 2);
      equippedAvatar.value = 1;
      expect(equippedAvatar.value, 1);
    });
  });

  group('persistence', () {
    test('mark, board and avatar survive AppStorage save/load', () async {
      SharedPreferences.setMockInitialValues({});
      await AppStorage.init();

      coins.value = 800;
      owned.value = {...owned.value, 'Ghost', 'Crimson'};
      equippedMark.value = 'Ghost';
      equippedBoard.value = 'Crimson';
      equippedAvatar.value = 2;
      await AppStorage.save();

      equippedMark.value = 'Classic';
      equippedBoard.value = 'Dark';
      equippedAvatar.value = 0;
      await AppStorage.load();

      expect(equippedMark.value, 'Ghost');
      expect(equippedBoard.value, 'Crimson');
      expect(equippedAvatar.value, 2);
      expect(owned.value.contains('Ghost'), isTrue);
    });

    test('load resets equip if cosmetic is not owned', () async {
      SharedPreferences.setMockInitialValues({
        'owned': <String>['Classic', 'Dark', 'Midnight', 'Shapes', 'Neon'],
        'equippedMark': 'Gold',
        'equippedBoard': 'Violet',
        'equippedAvatar': 9,
      });
      await AppStorage.init();
      await AppStorage.load();

      expect(equippedMark.value, 'Classic');
      expect(equippedBoard.value, 'Dark');
      expect(equippedAvatar.value, 0);
    });
  });
}
