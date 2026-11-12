import 'package:flutter/material.dart';
import '../models.dart';
import '../services/auth_service.dart';
import '../services/country_currency_service.dart';
import '../services/wallet_service.dart';
import '../theme.dart';
import '../widgets/common.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    if (!AuthService.isSignedIn) return;
    await WalletService.refresh();
    await WalletService.loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: staggered([
            const TopBar('Wallet'),
            if (!AuthService.isSignedIn)
              const AppCard(
                child: Text(
                  'Sign in to use the server wallet. Local coins still work offline.',
                  style: TextStyle(color: C.muted, height: 1.4),
                ),
              )
            else ...[
              ValueListenableBuilder<bool>(
                valueListenable: WalletService.loading,
                builder: (_, loading, __) => ValueListenableBuilder<int?>(
                  valueListenable: WalletService.serverBalance,
                  builder: (_, bal, ___) => ValueListenableBuilder<String>(
                    valueListenable: WalletService.currencyCode,
                    builder: (_, code, ____) => AppCard(
                      borderColor: C.teal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('BALANCE',
                              style: TextStyle(
                                  color: C.teal,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                  fontSize: 11)),
                          const SizedBox(height: 8),
                          if (loading)
                            const LinearProgressIndicator(color: C.magenta)
                          else
                            Text(
                              CountryCurrencyService.formatBalance(
                                amountMinor: bal ?? coins.value,
                                currencyCode: code,
                              ),
                              style: const TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.w900),
                            ),
                          ValueListenableBuilder<String?>(
                            valueListenable: WalletService.error,
                            builder: (_, err, __) => err == null
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(err,
                                        style: const TextStyle(
                                            color: C.danger, fontSize: 13)),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Text('Transactions',
                  style: TextStyle(fontWeight: FontWeight.w800)),
              ValueListenableBuilder<List<WalletTx>>(
                valueListenable: WalletService.transactions,
                builder: (_, txs, __) {
                  if (txs.isEmpty) {
                    return const AppCard(
                      child: Text('No transactions yet.',
                          style: TextStyle(color: C.muted)),
                    );
                  }
                  return Column(
                    children: [
                      for (final t in txs)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: AppCard(
                            child: Row(
                              children: [
                                Icon(
                                  t.direction == 'credit'
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  color: t.direction == 'credit'
                                      ? C.teal
                                      : C.magenta,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(t.reason,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700)),
                                      Text(
                                        t.createdAt
                                            .toLocal()
                                            .toString()
                                            .split('.')
                                            .first,
                                        style: const TextStyle(
                                            color: C.muted, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${t.direction == 'credit' ? '+' : '-'}${t.amountMinor}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: t.direction == 'credit'
                                        ? C.teal
                                        : C.magenta,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
            ValueListenableBuilder<int>(
              valueListenable: coins,
              builder: (_, c, __) => Text(
                'Device cache: $c coins',
                style: const TextStyle(color: C.muted, fontSize: 12),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
