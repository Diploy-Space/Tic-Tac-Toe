import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';
import '../widgets/painters.dart';
import '../l10n/app_localizations.dart';

class CustomizeScreen extends StatefulWidget {
  const CustomizeScreen({super.key});
  @override
  State<CustomizeScreen> createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends State<CustomizeScreen> {
  int tab = 0; // 0 marks, 1 boards, 2 avatars
  String? selMark;
  String? selBoard;

  void _msg(String t) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  Widget _preview(String board, {required String markSkin}) {
    const marks = [true, null, null, null, false, null, null, null, true];
    return Center(
        child: SizedBox(
            width: 210,
            child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: [
                  for (final m in marks)
                    Container(
                        decoration: BoxDecoration(
                            color: boardColor(board),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: C.border)),
                        child: m == null
                            ? null
                            : Center(
                                child: MarkIcon(
                                    isX: m, size: 28, skin: markSkin))),
                ])));
  }

  Widget _avatars() => ValueListenableBuilder<int>(
      valueListenable: equippedAvatar,
      builder: (_, cur, __) => Row(children: [
            for (var i = 0; i < 3; i++)
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () => equippedAvatar.value = i,
                          child: AppCard(
                              borderColor: cur == i ? C.magenta : C.border,
                              child: Column(children: [
                                [
                                  const PlayerFace(size: 70),
                                  const GuardFace(size: 70),
                                  const DollFace(size: 70)
                                ][i],
                                const SizedBox(height: 6),
                                Text(
                                    [
                                      context.l10n.player,
                                      context.l10n.guard,
                                      context.l10n.doll
                                    ][i],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                Text(
                                    cur == i
                                        ? context.l10n.equipped
                                        : context.l10n.free,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: cur == i ? C.teal : C.muted)),
                              ])))))
          ]));

  Widget _action(List<Cosmetic> items, String? sel, ValueNotifier<String> eq) {
    final item = items.firstWhere((c) => c.name == (sel ?? eq.value));
    final has = owned.value.contains(item.name);
    final isEq = eq.value == item.name;
    final label = isEq
        ? context.l10n.equipped
        : has
            ? context.l10n.equip
            : context.l10n.unlockFor('${item.price}');
    return PrimaryButton(label,
        onTap: isEq
            ? null
            : () {
                if (!unlockCosmetic(item)) {
                  _msg(context.l10n.notEnoughCoins);
                  return;
                }
                eq.value = item.name;
                setState(() {});
              });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: ValueListenableBuilder<Set<String>>(
        valueListenable: owned,
        builder: (_, __, ___) => ValueListenableBuilder<String>(
          valueListenable: equippedBoard,
          builder: (_, eqBoard, ____) => ValueListenableBuilder<String>(
            valueListenable: equippedMark,
            builder: (_, eqMark, _____) => SingleChildScrollView(
              child: staggered([
                TopBar(context.l10n.customize),
                AppCard(
                    borderColor: C.magenta,
                    child: _preview(
                      tab == 1 ? (selBoard ?? eqBoard) : eqBoard,
                      markSkin: tab == 0 ? (selMark ?? eqMark) : eqMark,
                    )),
                SegRow(options: [
                  context.l10n.marks,
                  context.l10n.boards,
                  context.l10n.avatars
                ], selected: tab, onChanged: (i) => setState(() => tab = i)),
                if (tab == 0)
                  CosmeticGrid(
                      items: marksCatalog,
                      selected: selMark ?? eqMark,
                      equipped: eqMark,
                      onTap: (c) => setState(() => selMark = c.name))
                else if (tab == 1)
                  CosmeticGrid(
                      items: boardsCatalog,
                      selected: selBoard ?? eqBoard,
                      equipped: eqBoard,
                      onTap: (c) => setState(() => selBoard = c.name))
                else
                  _avatars(),
                if (tab == 0) _action(marksCatalog, selMark, equippedMark),
                if (tab == 1) _action(boardsCatalog, selBoard, equippedBoard),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
