import 'package:flutter/material.dart';
import '../models.dart';
import '../services/app_locale_service.dart';
import '../services/auth_service.dart';
import '../services/wallet_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'shop_reward_flow_screens.dart';

enum _TxFilter { all, earned, spent }

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  _TxFilter _filter = _TxFilter.all;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    if (!AuthService.isSignedIn) return;
    await WalletService.refresh();
    await WalletService.loadTransactions(limit: 80);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: RefreshIndicator(
        color: C.magenta,
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TopBar('WALLET'),
              const SizedBox(height: 18),
              _BalanceCard(
                onBuy: () => Navigator.pushNamed(context, '/shop'),
                onFree: () => startShopRewardFlow(context),
              ),
              const SizedBox(height: 14),
              ValueListenableBuilder<List<WalletTx>>(
                valueListenable: WalletService.transactions,
                builder: (_, txs, __) => _WeekSourceCard(txs: txs),
              ),
              const SizedBox(height: 16),
              _FilterTabs(
                selected: _filter,
                onChanged: (f) => setState(() => _filter = f),
              ),
              const SizedBox(height: 18),
              ValueListenableBuilder<List<WalletTx>>(
                valueListenable: WalletService.transactions,
                builder: (_, txs, __) {
                  final filtered = [
                    for (final t in txs)
                      if (_filter == _TxFilter.all ||
                          (_filter == _TxFilter.earned &&
                              t.direction == 'credit') ||
                          (_filter == _TxFilter.spent &&
                              t.direction == 'debit'))
                        t,
                  ];
                  if (!AuthService.isSignedIn) {
                    return const _EmptyHint(
                      'Sign in to see your wallet history.',
                    );
                  }
                  if (filtered.isEmpty) {
                    return const _EmptyHint('No transactions yet.');
                  }
                  final groups = _groupByDay(filtered);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final g in groups) ...[
                        Text(
                          g.label,
                          style: const TextStyle(
                            color: C.muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.4,
                          ),
                        ),
                        const SizedBox(height: 10),
                        for (final t in g.items) ...[
                          _TxTile(tx: t),
                          const SizedBox(height: 10),
                        ],
                        const SizedBox(height: 4),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _DayGroup {
  final String label;
  final List<WalletTx> items;
  const _DayGroup(this.label, this.items);
}

List<_DayGroup> _groupByDay(List<WalletTx> txs) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final map = <DateTime, List<WalletTx>>{};
  for (final t in txs) {
    final local = t.createdAt.toLocal();
    final day = DateTime(local.year, local.month, local.day);
    map.putIfAbsent(day, () => []).add(t);
  }
  final days = map.keys.toList()..sort((a, b) => b.compareTo(a));
  return [
    for (final d in days)
      _DayGroup(
        d == today
            ? 'TODAY'
            : (d == yesterday
                ? 'YESTERDAY'
                : '${d.day}/${d.month}/${d.year}'),
        map[d]!,
      ),
  ];
}

class _BalanceCard extends StatelessWidget {
  final VoidCallback onBuy;
  final VoidCallback onFree;
  const _BalanceCard({required this.onBuy, required this.onFree});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: WalletService.loading,
      builder: (_, loading, __) => ValueListenableBuilder<int?>(
        valueListenable: WalletService.serverBalance,
        builder: (_, bal, ___) => ValueListenableBuilder<int>(
          valueListenable: coins,
          builder: (_, local, ____) {
            final amount = bal ?? local;
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              decoration: BoxDecoration(
                color: C.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: C.magenta, width: 1.5),
              ),
              child: Column(
                children: [
                  const Text(
                    'TOTAL COINS',
                    style: TextStyle(
                      color: C.muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.6,
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (loading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: C.magenta,
                        ),
                      ),
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _CoinBadge(symbol: AppLocaleService.currencySymbol),
                        const SizedBox(width: 12),
                        Text(
                          '$amount',
                          style: const TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.8,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: FilledButton(
                            onPressed: onBuy,
                            style: FilledButton.styleFrom(
                              backgroundColor: C.magenta,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: const Text(
                              'BUY COINS',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: onFree,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: C.text,
                              side: const BorderSide(
                                color: Color(0xFF4A4A55),
                                width: 1.2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: const Text(
                              'FREE COINS',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ValueListenableBuilder<String?>(
                    valueListenable: WalletService.error,
                    builder: (_, err, __) => err == null
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              err,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: C.danger,
                                fontSize: 12,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CoinBadge extends StatelessWidget {
  final String symbol;
  const _CoinBadge({required this.symbol});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFFFFE082), Color(0xFFFFB300), Color(0xFFFF8F00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xFFFFD54F), width: 2.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFB300).withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        symbol,
        style: const TextStyle(
          color: Color(0xFF4E342E),
          fontWeight: FontWeight.w900,
          fontSize: 18,
          height: 1,
        ),
      ),
    );
  }
}

class _WeekSourceCard extends StatelessWidget {
  final List<WalletTx> txs;
  const _WeekSourceCard({required this.txs});

  @override
  Widget build(BuildContext context) {
    final weekAgo = DateTime.now().toUtc().subtract(const Duration(days: 7));
    var matches = 0;
    var videos = 0;
    var purchases = 0;
    for (final t in txs) {
      if (t.direction != 'credit') continue;
      if (t.createdAt.isBefore(weekAgo)) continue;
      final src = _sourceOf(t);
      if (src == _TxSource.matches) {
        matches += t.amountMinor;
      } else if (src == _TxSource.videos) {
        videos += t.amountMinor;
      } else if (src == _TxSource.purchases) {
        purchases += t.amountMinor;
      } else {
        matches += t.amountMinor;
      }
    }
    final maxV =
        [matches, videos, purchases, 1].reduce((a, b) => a > b ? a : b);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: C.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Earned this week, by source',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13.5,
              color: C.text,
            ),
          ),
          const SizedBox(height: 16),
          _SourceBar(
            label: 'Matches',
            value: matches,
            color: const Color(0xFF47BBA7),
            max: maxV,
          ),
          const SizedBox(height: 12),
          _SourceBar(
            label: 'Videos',
            value: videos,
            color: const Color(0xFFC73974),
            max: maxV,
          ),
          const SizedBox(height: 12),
          _SourceBar(
            label: 'Purchases',
            value: purchases,
            color: const Color(0xFFF7C252),
            max: maxV,
          ),
        ],
      ),
    );
  }
}

class _SourceBar extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final int max;
  const _SourceBar({
    required this.label,
    required this.value,
    required this.color,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    final p = (value / max).clamp(0.0, 1.0);
    return Row(
      children: [
        SizedBox(
          width: 78,
          child: Text(
            label,
            style: const TextStyle(
              color: C.muted,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: SizedBox(
              height: 11,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const ColoredBox(color: Color(0xFF2A2A33)),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: p,
                    child: ColoredBox(color: color),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 36,
          child: Text(
            '$value',
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: C.text,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterTabs extends StatelessWidget {
  final _TxFilter selected;
  final ValueChanged<_TxFilter> onChanged;
  const _FilterTabs({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Widget chip(String label, _TxFilter f) {
      final on = selected == f;
      return Expanded(
        child: Material(
          color: on ? C.magenta : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: () => onChanged(f),
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              height: 42,
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: on ? Colors.white : C.muted,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          chip('All', _TxFilter.all),
          chip('Earned', _TxFilter.earned),
          chip('Spent', _TxFilter.spent),
        ],
      ),
    );
  }
}

enum _TxSource { matches, videos, purchases, other }

_TxSource _sourceOf(WalletTx t) {
  final r = t.reason.toLowerCase();
  final ref = (t.refType ?? '').toLowerCase();
  if (r == 'ad_reward' ||
      r.contains('video') ||
      r.contains('ad') ||
      ref.contains('rewarded_ad') ||
      ref.contains('video')) {
    return _TxSource.videos;
  }
  if (r == 'iap_grant' ||
      r.contains('purchase') ||
      r.contains('buy') ||
      r.contains('iap') ||
      r.contains('pack')) {
    return _TxSource.purchases;
  }
  if (r == 'match_reward' ||
      r == 'tournament_prize' ||
      r == 'daily_reward' ||
      r.contains('match') ||
      r.contains('win') ||
      r.contains('challenge') ||
      r.contains('stake') ||
      r.contains('tournament')) {
    return _TxSource.matches;
  }
  return _TxSource.other;
}

class _TxMeta {
  final String title;
  final String letter;
  final Color accent;
  final String subtitle;
  const _TxMeta(this.title, this.letter, this.accent, this.subtitle);
}

_TxMeta _metaFor(WalletTx t) {
  final r = t.reason.toLowerCase();
  final time = _fmtTime(t.createdAt.toLocal());
  final ref = (t.refType ?? '').trim();

  if (r == 'ad_reward' || r.contains('video') || r.contains('ad')) {
    return _TxMeta(
      'Free video reward',
      'V',
      const Color(0xFF2FB8B4),
      'Watching ads · $time',
    );
  }
  if (r == 'iap_grant' || r.contains('purchase') || r.contains('buy')) {
    return _TxMeta(
      'Coin purchase',
      'P',
      const Color(0xFFF7C252),
      'Purchasing coins · $time',
    );
  }
  if (r == 'match_reward' ||
      ((r.contains('match') || r.contains('win')) &&
          t.direction == 'credit')) {
    return _TxMeta(
      'Match win',
      'M',
      const Color(0xFF2FB8B4),
      'Winning matches · $time',
    );
  }
  if (r == 'daily_reward') {
    return _TxMeta(
      'Daily reward',
      'D',
      const Color(0xFF2FB8B4),
      'Daily bonus · $time',
    );
  }
  if (r == 'referral_bonus') {
    return _TxMeta(
      'Welcome bonus',
      'R',
      const Color(0xFFFFC24D),
      'Referral code · $time',
    );
  }
  if (r == 'tournament_prize') {
    return _TxMeta(
      'Tournament prize',
      'T',
      const Color(0xFFF7C252),
      'Tournament · $time',
    );
  }
  if (r.contains('challenge') && t.direction == 'debit') {
    return _TxMeta(
      'Challenge entry',
      'C',
      C.magenta,
      '${ref.isEmpty ? 'Match' : _titleCase(ref)} · $time',
    );
  }
  if (t.direction == 'debit') {
    return _TxMeta(
      _titleCase(t.reason),
      'C',
      C.magenta,
      '${ref.isEmpty ? 'Spent' : _titleCase(ref)} · $time',
    );
  }
  return _TxMeta(
    _titleCase(t.reason),
    'W',
    const Color(0xFF2FB8B4),
    '${ref.isEmpty ? 'Wallet' : _titleCase(ref)} · $time',
  );
}

String _titleCase(String s) {
  final t = s.replaceAll('_', ' ').trim();
  if (t.isEmpty) return 'Wallet';
  return t[0].toUpperCase() + t.substring(1);
}

String _fmtTime(DateTime d) {
  final h = d.hour > 12 ? d.hour - 12 : (d.hour == 0 ? 12 : d.hour);
  final m = d.minute.toString().padLeft(2, '0');
  final ap = d.hour >= 12 ? 'PM' : 'AM';
  return '$h:$m $ap';
}

class _TxTile extends StatelessWidget {
  final WalletTx tx;
  const _TxTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    final meta = _metaFor(tx);
    final credit = tx.direction == 'credit';
    final amountColor = credit ? const Color(0xFF2FB8B4) : C.magenta;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
      decoration: BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: meta.accent.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              meta.letter,
              style: TextStyle(
                color: meta.accent,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meta.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                    color: C.text,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  meta.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: C.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${credit ? '+' : '-'}${tx.amountMinor}',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  final String text;
  const _EmptyHint(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: C.muted),
      ),
    );
  }
}
