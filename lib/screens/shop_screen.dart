import 'package:flutter/material.dart';
import '../models.dart';
import '../services/storage.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/pdf_ui.dart';
import 'shop_reward_flow_screens.dart';

/// PDF pages 35–36 shop with free coins + packs.
class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});
  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  void _msg(String t) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  Widget _pack({
    required String coinsLabel,
    required String title,
    required String price,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: C.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.monetization_on, color: C.coin, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(coinsLabel,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 16)),
                Text(title,
                    style: const TextStyle(color: C.muted, fontSize: 13)),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              final n = int.tryParse(coinsLabel.split(' ').first) ?? 0;
              coins.value += n;
              _msg('+$n coins added (demo IAP)');
            },
            borderRadius: BorderRadius.circular(99),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: C.magenta.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(price,
                  style: const TextStyle(
                      color: C.magenta, fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final used = AppStorage.freeVideosUsedToday;
    return AppScaffold(
      child: SingleChildScrollView(
        child: staggered([
          Row(children: [
            const Expanded(child: TopBar('Shop')),
            ValueListenableBuilder<int>(
              valueListenable: coins,
              builder: (_, c, __) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: C.surface,
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: C.border2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.monetization_on, color: C.coin, size: 16),
                    const SizedBox(width: 6),
                    Text('$c',
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ),
          ]),
          PdfModalCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: C.surface2,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.monetization_on,
                          color: C.coin, size: 26),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FREE COINS',
                            style: TextStyle(
                              color: C.magenta,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                              fontSize: 11,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text('Watch a video, get 10 coins',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    for (var i = 0; i < 5; i++)
                      Expanded(
                        child: Container(
                          height: 8,
                          margin: EdgeInsets.only(right: i == 4 ? 0 : 4),
                          decoration: BoxDecoration(
                            color: i < used ? C.magenta : C.surface2,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '$used of 5 free videos used today',
                  style: const TextStyle(color: C.muted, fontSize: 13),
                ),
                const SizedBox(height: 14),
                PdfPinkButton(
                  used >= 5 ? 'DAILY LIMIT REACHED' : 'WATCH VIDEO',
                  onTap: () => startShopRewardFlow(context),
                ),
              ],
            ),
          ),
          const PdfSectionLabel('Coin packs'),
          _pack(
              coinsLabel: '100 coins', title: 'Starter pack', price: '₹29'),
          _pack(coinsLabel: '300 coins', title: 'Popular', price: '₹79'),
          _pack(
              coinsLabel: '700 coins', title: 'Best value', price: '₹149'),
          TextButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/reward-flow'),
            child: const Text('Reward flow overview',
                style: TextStyle(color: C.teal)),
          ),
        ]),
      ),
    );
  }
}
