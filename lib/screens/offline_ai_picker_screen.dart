import 'package:flutter/material.dart';
import '../data/offline_ai_opponents.dart';
import '../models.dart';
import '../models/ai_opponent_profile.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/painters.dart';

/// Arguments for offline Random Match AI selection.
class OfflineAiPickerArgs {
  final int boardSize;
  final int stake;
  const OfflineAiPickerArgs({required this.boardSize, required this.stake});
}

/// Pick a local AI rival when Random Match has no internet.
class OfflineAiPickerScreen extends StatefulWidget {
  const OfflineAiPickerScreen({super.key});

  @override
  State<OfflineAiPickerScreen> createState() => _OfflineAiPickerScreenState();
}

class _OfflineAiPickerScreenState extends State<OfflineAiPickerScreen> {
  AiOpponentProfile? _selected;
  bool _starting = false;
  OfflineAiPickerArgs? _args;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final raw = ModalRoute.of(context)?.settings.arguments;
    if (_args == null && raw is OfflineAiPickerArgs) {
      _args = raw;
    } else if (_args == null && raw is Map) {
      _args = OfflineAiPickerArgs(
        boardSize: (raw['boardSize'] as num?)?.toInt() ?? 3,
        stake: (raw['stake'] as num?)?.toInt() ?? 10,
      );
    }
    _args ??= const OfflineAiPickerArgs(boardSize: 3, stake: 10);
  }

  Widget _face(int index, double size) {
    switch (index.clamp(0, 2)) {
      case 1:
        return GuardFace(size: size);
      case 2:
        return DollFace(size: size);
      default:
        return PlayerFace(size: size);
    }
  }

  Color _diffColor(String d) {
    switch (d) {
      case 'Easy':
        return C.teal;
      case 'Hard':
        return C.magenta;
      default:
        return C.coin;
    }
  }

  Future<void> _play() async {
    final profile = _selected;
    final args = _args;
    if (profile == null || args == null || _starting) return;
    setState(() => _starting = true);
    if (!mounted) return;
    await Navigator.pushNamed(
      context,
      '/game',
      arguments: GameArgs(
        size: args.boardSize,
        difficulty: profile.difficulty,
        stake: args.stake,
        opponentName: profile.name,
        vsAi: true,
        quickMatch: true,
      ),
    );
    if (mounted) setState(() => _starting = false);
  }

  @override
  Widget build(BuildContext context) {
    final stake = _args?.stake ?? 0;
    final size = _args?.boardSize ?? 3;
    return AppScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TopBar('Offline AI'),
          const SizedBox(height: 8),
          AppCard(
            borderColor: C.border2,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.wifi_off, color: C.danger, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'No internet · AI rivals only · ${size}x$size · Stake $stake',
                    style: const TextStyle(color: C.muted, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Choose an opponent',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          const SizedBox(height: 4),
          const Text(
            'These are offline AI profiles — not real online players.',
            style: TextStyle(color: C.muted, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: offlineAiOpponents.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final p = offlineAiOpponents[i];
                final selected = _selected?.id == p.id;
                final accent = _diffColor(p.difficulty);
                return Semantics(
                  button: true,
                  selected: selected,
                  label: '${p.name}, ${p.difficulty}',
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: _starting
                        ? null
                        : () => setState(() => _selected = p),
                    child: AppCard(
                      borderColor: selected ? accent : C.border,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: selected ? accent : C.border2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: _face(p.avatarIndex, 48),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        p.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Tag(p.difficulty, color: accent),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  p.description,
                                  style: const TextStyle(
                                      color: C.muted, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          if (selected)
                            Icon(Icons.check_circle, color: accent, size: 22),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            _starting
                ? 'Starting…'
                : (_selected == null
                    ? 'Select an opponent'
                    : 'Play vs ${_selected!.name}'),
            onTap: (_selected == null || _starting) ? null : _play,
          ),
        ],
      ),
    );
  }
}
