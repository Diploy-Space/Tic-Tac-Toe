import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models.dart';
import '../services/app_locale_service.dart';
import '../services/storage.dart';
import '../services/wallet_service.dart';
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
    required int coinsToAdd,
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
            onTap: () async {
              final ok = await WalletService.credit(
                amount: coinsToAdd,
                reason: 'iap_grant',
                idempotencyKey:
                    'iap_${coinsToAdd}_${DateTime.now().millisecondsSinceEpoch}',
                refType: 'shop_pack',
                refId: title,
              );
              if (!mounted) return;
              _msg(ok
                  ? '+$coinsToAdd coins added'
                  : (WalletService.error.value ?? 'Purchase failed'));
              setState(() {});
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
    return ValueListenableBuilder<int>(
      valueListenable: AppLocaleService.revision,
      builder: (context, _, __) {
        final packs = AppLocaleService.shopPacksInr;
        return AppScaffold(
          child: SingleChildScrollView(
            child: staggered([
              Row(children: [
                Expanded(child: TopBar(context.tr('shop'))),
                ValueListenableBuilder<int>(
                  valueListenable: coins,
                  builder: (_, c, __) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: C.surface,
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(color: C.border2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.monetization_on,
                            color: C.coin, size: 16),
                        const SizedBox(width: 6),
                        Text('$c',
                            style:
                                const TextStyle(fontWeight: FontWeight.w800)),
                        const SizedBox(width: 8),
                        Text(
                          AppLocaleService.currencySymbol,
                          style: const TextStyle(
                            color: C.muted,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.tr('free_coins'),
                                style: const TextStyle(
                                  color: C.magenta,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(context.tr('watch_video_coins'),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16)),
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
                      context.tr(
                          'free_videos_used', {'used': '$used'}),
                      style:
                          const TextStyle(color: C.muted, fontSize: 13),
                    ),
                    const SizedBox(height: 14),
                    PdfPinkButton(
                      used >= 5
                          ? context.tr('daily_limit')
                          : context.tr('watch_video'),
                      onTap: () => startShopRewardFlow(context),
                    ),
                  ],
                ),
              ),
              PdfSectionLabel(context.tr('coin_packs')),
              for (final p in packs)
                _pack(
                  coinsLabel:
                      context.tr('coins_label', {'n': '${p.coins}'}),
                  title: context.tr(switch (p.title) {
                    'Starter pack' => 'starter_pack',
                    'Popular' => 'popular',
                    'Best value' => 'best_value',
                    _ => 'starter_pack',
                  }),
                  price: AppLocaleService.formatShopPackPriceInr(p.inr),
                  coinsToAdd: p.coins,
                ),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/reward-flow'),
                child: const Text('Reward flow overview',
                    style: TextStyle(color: C.teal)),
              ),
            ]),
          ),
        );
      },
    );
  }
}
