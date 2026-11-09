import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/common.dart';

class DailyRewardScreen extends StatefulWidget {
  const DailyRewardScreen({super.key});
  @override
  State<DailyRewardScreen> createState() => _DailyRewardScreenState();
}

class _DailyRewardScreenState extends State<DailyRewardScreen>
    with SingleTickerProviderStateMixin {
  static const amounts = [10, 20, 30, 40, 50, 75, 150];
  late final AnimationController _pulse = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1600))
    ..repeat(reverse: true);

  @override
  void initState() {
    super.initState();
    ensureMissionResets();
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  int get today => playerStats.dailyRewardDay.clamp(0, 6);
  bool get claimed => playerStats.lastDailyClaimDate == todayKey();

  Widget _tile(int i) {
    final done = i < today || (i == today && claimed);
    final now = i == today && !claimed;
    final color = done ? C.teal : now ? C.magenta : C.border;
    return Expanded(
        flex: i == 6 ? 2 : 1,
        child: Padding(
            padding: const EdgeInsets.all(5),
            child: AnimatedBuilder(
                animation: _pulse,
                builder: (_, child) => Opacity(
                    opacity: (!done && !now) ? .55 : 1,
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                            color: C.surface,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: color),
                            boxShadow: now
                                ? [
                                    BoxShadow(
                                        color: C.magenta.withAlpha(60),
                                        spreadRadius: 7 * _pulse.value)
                                  ]
                                : null),
                        child: child)),
                child: Column(children: [
                  Text('Day ${i + 1}',
                      style: const TextStyle(color: C.muted, fontSize: 13)),
                  const SizedBox(height: 8),
                  Icon(done ? Icons.check : Icons.monetization_on_outlined,
                      color: done ? C.teal : C.coin),
                  const SizedBox(height: 8),
                  Text('${amounts[i]}',
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                ]))));
  }

  void _claim() {
    if (claimed) return;
    coins.value += amounts[today];
    playerStats.lastDailyClaimDate = todayKey();
    playerStats.dailyRewardDay = (today + 1) % 7;
    statsTick.value++;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(children: [
        const TopBar('Daily reward'),
        const SizedBox(height: 14),
        AppCard(
            borderColor: C.magenta,
            child: Row(children: [
              const Icon(Icons.local_fire_department_outlined,
                  color: C.magenta, size: 34),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('${claimed ? today : today + 1}-day streak',
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 18)),
                    const Text(
                        'Miss a day and it resets. Come back tomorrow for the next reward.',
                        style: TextStyle(color: C.muted, fontSize: 13)),
                  ])),
            ])),
        const SizedBox(height: 14),
        Row(children: [for (var i = 0; i < 4; i++) _tile(i)]),
        Row(children: [for (var i = 4; i < 7; i++) _tile(i)]),
        const Spacer(),
        SizedBox(
            width: double.infinity,
            child: PrimaryButton(
                claimed
                    ? 'Come back tomorrow'
                    : 'Claim +${amounts[today]} coins',
                onTap: claimed ? null : _claim)),
      ]),
    );
  }
}
