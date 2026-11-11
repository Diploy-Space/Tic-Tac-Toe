import 'package:flutter/material.dart';
import '../models.dart';
import '../services/auth_service.dart';
import '../services/connectivity_service.dart';
import '../services/private_room_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/painters.dart';
import 'offline_ai_picker_screen.dart';

/// Recheck reachability before an online-only action.
/// When [openOfflineScreen] is true, opens `/offline` instead of a snackbar.
Future<bool> requireInternet(
  BuildContext context, {
  bool openOfflineScreen = false,
}) async {
  final online = await ConnectivityService.instance.ensureOnline();
  if (online) return true;
  if (!context.mounted) return false;
  if (openOfflineScreen) {
    await Navigator.pushNamed(context, '/offline');
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Internet connection required. You can still play vs The Doll offline.',
        ),
      ),
    );
  }
  return false;
}

const _tealFg = Color(0xFF04201F);

class _ChoiceDialog<T> extends StatefulWidget {
  final String title;
  final List<MapEntry<String, T>> options;
  final int initial;
  final String action;
  const _ChoiceDialog(
      {required this.title,
      required this.options,
      required this.initial,
      required this.action});
  @override
  State<_ChoiceDialog<T>> createState() => _ChoiceDialogState<T>();
}

class _ChoiceDialogState<T> extends State<_ChoiceDialog<T>> {
  late int sel = widget.initial;
  @override
  Widget build(BuildContext context) => Column(mainAxisSize: MainAxisSize.min, children: [
        const DialogClose(),
        Heading(widget.title, size: 20),
        const SizedBox(height: 16),
        for (var i = 0; i < widget.options.length; i++)
          Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SizedBox(
                  width: double.infinity,
                  child: GhostButton(widget.options[i].key,
                      filledMagenta: i == sel,
                      onTap: () => setState(() => sel = i)))),
        const SizedBox(height: 6),
        SizedBox(
            width: double.infinity,
            child: PrimaryButton(widget.action,
                color: C.teal,
                fg: _tealFg,
                onTap: () => Navigator.pop(context, widget.options[sel].value))),
      ]);
}

Future<String?> showDifficultyDialog(BuildContext c) => showAppDialog<String>(
    c,
    (_) => const _ChoiceDialog<String>(
        title: 'Select difficulty',
        options: [
          MapEntry('Easy', 'Easy'),
          MapEntry('Medium', 'Medium'),
          MapEntry('Hard', 'Hard'),
        ],
        initial: 1,
        action: 'Next'));

Future<int?> showGameModeDialog(BuildContext c) => showAppDialog<int>(
    c,
    (_) => const _ChoiceDialog<int>(
        title: 'Choose your game mode',
        options: [
          MapEntry('Classic mode (3×3)', 3),
          MapEntry('Advanced mode (4×4)', 4),
          MapEntry('Expert mode (5×5)', 5),
        ],
        initial: 0,
        action: 'Start'));

class _RandomDialog extends StatefulWidget {
  const _RandomDialog();
  @override
  State<_RandomDialog> createState() => _RandomDialogState();
}

class _RandomDialogState extends State<_RandomDialog> {
  static const stakes = [10, 25, 50, 100];
  int sel = 0;
  Widget _stake(int i) => Expanded(
      child: Padding(
          padding: const EdgeInsets.all(5),
          child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => setState(() => sel = i),
              child: Container(
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: i == sel ? C.teal : C.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: i == sel ? C.teal : C.border2)),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.monetization_on_outlined,
                        size: 18, color: i == sel ? _tealFg : C.coin),
                    const SizedBox(width: 6),
                    Text('${stakes[i]}',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: i == sel ? _tealFg : C.text)),
                  ])))));
  @override
  Widget build(BuildContext context) => Column(mainAxisSize: MainAxisSize.min, children: [
        const DialogClose(),
        const Heading('Random match', size: 20),
        const SizedBox(height: 6),
        const Text('Choose your entry stake', style: TextStyle(color: C.muted)),
        const SizedBox(height: 12),
        Row(children: [_stake(0), _stake(1)]),
        Row(children: [_stake(2), _stake(3)]),
        const SizedBox(height: 14),
        SizedBox(
            width: double.infinity,
            child: PrimaryButton('Find opponent',
                onTap: () => Navigator.pop(context, stakes[sel]))),
      ]);
}

Future<int?> showRandomDialog(BuildContext c) =>
    showAppDialog<int>(c, (_) => const _RandomDialog());

Future<void> showHowToDialog(BuildContext c) => showAppDialog<void>(
    c,
    (ctx) => Column(mainAxisSize: MainAxisSize.min, children: [
          const DollFace(size: 84),
          const SizedBox(height: 10),
          const Heading('How to play', size: 22),
          const SizedBox(height: 10),
          const Text(
              'Place three of your marks in a row, horizontal, vertical or diagonal, before your rival does. '
              'On bigger boards you need four in a row.',
              textAlign: TextAlign.center,
              style: TextStyle(color: C.muted, fontSize: 15, height: 1.5)),
          const SizedBox(height: 18),
          SizedBox(
              width: double.infinity,
              child: PrimaryButton('Got it', onTap: () => Navigator.pop(ctx))),
        ]));

/// Generic confirm — returns true if the user confirmed.
Future<bool?> showConfirmDialog(
  BuildContext c, {
  required String title,
  required String body,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
}) =>
    showAppDialog<bool>(
      c,
      (ctx) => Column(mainAxisSize: MainAxisSize.min, children: [
            Heading(title, size: 22),
            const SizedBox(height: 8),
            Text(body,
                textAlign: TextAlign.center,
                style: const TextStyle(color: C.muted)),
            const SizedBox(height: 18),
            Row(children: [
              Expanded(
                  child: GhostButton(cancelLabel,
                      onTap: () => Navigator.pop(ctx, false))),
              const SizedBox(width: 10),
              Expanded(
                  child: PrimaryButton(confirmLabel,
                      onTap: () => Navigator.pop(ctx, true))),
            ]),
          ]),
    );

/// Returns true if the user confirmed.
Future<bool?> showDeleteDialog(BuildContext c) => showAppDialog<bool>(
    c,
    (ctx) => Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: C.danger)),
              child: const Icon(Icons.delete_outline, color: C.danger, size: 26)),
          const SizedBox(height: 12),
          const Heading('Delete account?', size: 22),
          const SizedBox(height: 8),
          const Text('This removes your coins, score and history for good.',
              textAlign: TextAlign.center, style: TextStyle(color: C.muted)),
          const SizedBox(height: 18),
          Row(children: [
            Expanded(child: GhostButton('No', onTap: () => Navigator.pop(ctx, false))),
            const SizedBox(width: 10),
            Expanded(
                child: PrimaryButton('Yes, delete',
                    color: const Color(0xFFB3123E),
                    onTap: () => Navigator.pop(ctx, true))),
          ]),
        ]));

/// Returns true for "Play again", false for "Back to home".
Future<bool?> showResultDialog(BuildContext c,
        {required Widget art,
        required String title,
        required String subtitle,
        String? coinText}) =>
    showAppDialog<bool>(
        c,
        (ctx) => Column(mainAxisSize: MainAxisSize.min, children: [
              const Tag('Game over'),
              const SizedBox(height: 10),
              art,
              const SizedBox(height: 8),
              Heading(title, size: 30),
              if (coinText != null) ...[
                const SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                        color: C.surface,
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(color: C.border2)),
                    child: Text(coinText,
                        style: const TextStyle(fontWeight: FontWeight.w600))),
              ],
              const SizedBox(height: 8),
              Text(subtitle, style: const TextStyle(color: C.muted)),
              const SizedBox(height: 18),
              SizedBox(
                  width: double.infinity,
                  child: PrimaryButton('Play again', onTap: () => Navigator.pop(ctx, true))),
              const SizedBox(height: 10),
              SizedBox(
                  width: double.infinity,
                  child: GhostButton('Back to home', onTap: () => Navigator.pop(ctx, false))),
            ]),
        dismissible: false);

// ---- flows -----------------------------------------------------------

Future<void> startVsDoll(BuildContext c) async {
  final d = await showDifficultyDialog(c);
  if (d == null || !c.mounted) return;
  final s = await showGameModeDialog(c);
  if (s == null || !c.mounted) return;
  Navigator.pushNamed(c, '/game', arguments: GameArgs(size: s, difficulty: d));
}

/// Unified Random Match: real queue when online, local AI picker when offline.
/// Never swaps an active online room into AI; never fakes online opponents.
Future<void> startRandom(BuildContext c) async {
  final stake = await showRandomDialog(c);
  if (stake == null || !c.mounted) return;
  if (coins.value < stake) {
    ScaffoldMessenger.of(c).showSnackBar(
        const SnackBar(content: Text('Not enough coins for this stake.')));
    return;
  }
  final s = await showGameModeDialog(c);
  if (s == null || !c.mounted) return;

  final online = await ConnectivityService.instance.ensureOnline();
  if (!c.mounted) return;

  if (online) {
    if (!AuthService.isSignedIn) {
      ScaffoldMessenger.of(c).showSnackBar(
        const SnackBar(
          content: Text('Sign in to play Random Match against real players'),
        ),
      );
      return;
    }
    // Existing C1 flow — do not fall through to AI if this later fails.
    await Navigator.pushNamed(c, '/online-matching', arguments: {
      'boardSize': s,
      'stake': stake,
    });
    return;
  }

  // Offline: local AI profiles only — zero matchmaking RPCs.
  await Navigator.pushNamed(
    c,
    '/offline-ai-picker',
    arguments: OfflineAiPickerArgs(boardSize: s, stake: stake),
  );
}

Future<void> startPassAndPlay(BuildContext c) async {
  final s = await showGameModeDialog(c);
  if (s == null || !c.mounted) return;
  Navigator.pushNamed(c, '/game',
      arguments: GameArgs(size: s, vsAi: false, opponentName: 'Player 2'));
}

/// Online hub: find match (C1), create private room, or join by code (C3).
Future<void> startOnlineMatch(BuildContext c) async {
  // Connectivity first — do not auto-join anything on restore.
  if (!await requireInternet(c, openOfflineScreen: true)) return;
  if (!c.mounted) return;

  if (!AuthService.isSignedIn) {
    ScaffoldMessenger.of(c).showSnackBar(
        const SnackBar(content: Text('Sign in to play online multiplayer')));
    return;
  }
  final mode = await showAppDialog<String>(
    c,
    (_) => const _ChoiceDialog<String>(
      title: 'Online multiplayer',
      options: [
        MapEntry('Find a match', 'find'),
        MapEntry('Create private room', 'create'),
        MapEntry('Join with code', 'join'),
      ],
      initial: 0,
      action: 'Continue',
    ),
  );
  if (mode == null || !c.mounted) return;

  if (mode == 'join') {
    if (!await requireInternet(c, openOfflineScreen: true)) return;
    if (!c.mounted) return;
    Navigator.pushNamed(c, '/join-private-room');
    return;
  }

  final stake = await showRandomDialog(c);
  if (stake == null || !c.mounted) return;
  if (coins.value < stake) {
    ScaffoldMessenger.of(c).showSnackBar(
        const SnackBar(content: Text('Not enough coins for this stake.')));
    return;
  }
  final s = await showGameModeDialog(c);
  if (s == null || !c.mounted) return;

  // Recheck right before network RPCs / navigation.
  if (!await requireInternet(c, openOfflineScreen: true)) return;
  if (!c.mounted) return;

  if (mode == 'find') {
    Navigator.pushNamed(c, '/online-matching', arguments: {
      'boardSize': s,
      'stake': stake,
    });
    return;
  }

  // create private room
  try {
    final room = await PrivateRoomService.create(boardSize: s, stake: stake);
    if (!c.mounted) return;
    Navigator.pushNamed(c, '/private-room-lobby', arguments: {
      'roomId': room.roomId,
      'code': room.code,
      'boardSize': room.boardSize,
      'stake': room.stake,
    });
  } catch (e) {
    if (!c.mounted) return;
    ScaffoldMessenger.of(c).showSnackBar(
        SnackBar(content: Text(AuthService.messageFromError(e))));
  }
}

/// Returns 'resume', 'restart', 'settings' or 'quit'.
Future<String?> showPauseDialog(BuildContext c) => showAppDialog<String>(
    c,
    (ctx) => Column(mainAxisSize: MainAxisSize.min, children: [
          const Tag('Game paused'),
          const SizedBox(height: 8),
          const Heading('Paused', size: 30),
          const SizedBox(height: 18),
          SizedBox(
              width: double.infinity,
              child: PrimaryButton('Resume', onTap: () => Navigator.pop(ctx, 'resume'))),
          const SizedBox(height: 10),
          SizedBox(
              width: double.infinity,
              child: GhostButton('Restart', onTap: () => Navigator.pop(ctx, 'restart'))),
          const SizedBox(height: 10),
          SizedBox(
              width: double.infinity,
              child: GhostButton('Settings', onTap: () => Navigator.pop(ctx, 'settings'))),
          const SizedBox(height: 10),
          SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: C.danger,
                      minimumSize: const Size.fromHeight(54),
                      side: BorderSide(color: C.danger.withAlpha(100)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14))),
                  onPressed: () => Navigator.pop(ctx, 'quit'),
                  child: const Text('Quit match',
                      style: TextStyle(fontWeight: FontWeight.w600)))),
        ]),
    dismissible: false);
