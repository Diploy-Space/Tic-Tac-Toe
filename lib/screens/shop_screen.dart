import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});
  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int tab = 0;
  static const packs = [500, 1200, 3000, 8000];

  void _msg(String t) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  Widget _pack(int i) {
    final best = i == 1;
    return Expanded(
        child: Padding(
            padding: const EdgeInsets.all(6),
            child: AppCard(
                borderColor: best ? C.magenta : C.border,
                child: Column(children: [
                  Tag(best ? 'Best value' : ' ', color: C.magenta),
                  const SizedBox(height: 8),
                  const Icon(Icons.monetization_on_outlined, color: C.coin, size: 36),
                  const SizedBox(height: 6),
                  Text('${packs[i]}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  SmallButton(
                      const ['\$0.99', '\$1.99', '\$4.99', '\$9.99'][i],
                      color: best ? C.btn : C.border2,
                      onTap: () {
                        // Demo purchase until real IAP is connected.
                        coins.value += packs[i];
                        _msg('+${packs[i]} coins added (demo)');
                      }),
                ]))));
  }

  Widget _cosmetics(List<Cosmetic> items, ValueNotifier<String> equipped) =>
      ValueListenableBuilder<String>(
          valueListenable: equipped,
          builder: (_, eq, __) => CosmeticGrid(
              items: items,
              selected: null,
              equipped: eq,
              onTap: (c) {
                if (owned.value.contains(c.name)) {
                  _msg('${c.name} is already yours. Equip it in Customize.');
                } else if (unlockCosmetic(c)) {
                  _msg('${c.name} unlocked');
                } else {
                  _msg('Not enough coins');
                }
              }));

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: SingleChildScrollView(
        child: staggered([
          Row(children: [
            Expanded(child: TopBar('Shop')),
            const CoinChip(),
          ]),
          SegRow(
              options: const ['Coins', 'Boards', 'Marks'],
              selected: tab,
              onChanged: (i) => setState(() => tab = i)),
          if (tab == 0) ...[
            AppCard(
                child: Row(children: [
              const IconCircle(Icons.play_arrow_rounded, color: C.teal),
              const SizedBox(width: 12),
              const Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Watch a short video', style: TextStyle(fontWeight: FontWeight.w700)),
                Text('Free coins, no purchase needed',
                    style: TextStyle(color: C.muted, fontSize: 13)),
              ])),
              // TODO: show a rewarded ad here, then grant the coins.
              SmallButton('+20', color: C.teal, onTap: () {
                coins.value += 20;
                _msg('+20 coins');
              }),
            ])),
            Column(children: [
              Row(children: [_pack(0), _pack(1)]),
              Row(children: [_pack(2), _pack(3)]),
            ]),
          ] else if (tab == 1)
            _cosmetics(boardsCatalog, equippedBoard)
          else
            _cosmetics(marksCatalog, equippedMark),
        ]),
      ),
    );
  }
}
