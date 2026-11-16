import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/admob_config.dart';
import '../models.dart';
import '../models/moderation_models.dart';
import '../services/auth_service.dart';
import '../services/connectivity_service.dart';
import '../services/moderation_service.dart';
import '../services/private_room_service.dart';
import '../services/rewarded_ad_service.dart';
import '../services/sfx_service.dart';
import '../services/wallet_service.dart';
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

/// Fail-closed gate for online multiplayer / matchmaking.
Future<bool> requireActiveAccount(BuildContext context) async {
  if (!AuthService.isSignedIn) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sign in required')),
    );
    return false;
  }
  var s = ModerationService.status.value;
  s ??= await ModerationService.refresh();
  if (!context.mounted) return false;
  if (s == null || s.accountStatus == AccountStatus.unknown) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ModerationService.error.value ??
              'Could not verify account status. Try again.',
        ),
      ),
    );
    return false;
  }
  if (s.accountStatus == AccountStatus.suspended) {
    Navigator.pushNamedAndRemoveUntil(
        context, '/account-suspended', (r) => false);
    return false;
  }
  if (s.accountStatus == AccountStatus.underReview) {
    Navigator.pushNamedAndRemoveUntil(
        context, '/appeal-under-review', (r) => false);
    return false;
  }
  return s.accountStatus == AccountStatus.active;
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
/// Game-over dialog. When [bonusReward] > 0 a "Claim N Bonus Coins" card
/// offers a rewarded video that credits that many coins. When [shareText]
/// is set, a "Share on WhatsApp" button is shown.
Future<bool?> showResultDialog(BuildContext c,
        {required Widget art,
        required String title,
        required String subtitle,
        String? coinText,
        int baseCoins = 0,
        int bonusReward = 0,
        String? shareText,
        String? refId}) =>
    showAppDialog<bool>(
        c,
        (ctx) => _ResultDialog(
              art: art,
              title: title,
              subtitle: subtitle,
              coinText: coinText,
              baseCoins: baseCoins,
              bonusReward: bonusReward,
              shareText: shareText,
              refId: refId,
            ),
        dismissible: false);

class _ResultDialog extends StatefulWidget {
  final Widget art;
  final String title;
  final String subtitle;
  final String? coinText;
  final int baseCoins;
  final int bonusReward;
  final String? shareText;
  final String? refId;
  const _ResultDialog({
    required this.art,
    required this.title,
    required this.subtitle,
    required this.coinText,
    required this.baseCoins,
    required this.bonusReward,
    required this.shareText,
    required this.refId,
  });
  @override
  State<_ResultDialog> createState() => _ResultDialogState();
}

class _ResultDialogState extends State<_ResultDialog> {
  /// idle | loading | done | failed
  String _ad = 'idle';

  @override
  void initState() {
    super.initState();
    // Coins jingle lands after the win/lose sting.
    if (widget.coinText?.startsWith('+') ?? false) {
      SfxService.playLater(Sfx.coinCollect, const Duration(milliseconds: 650));
    }
  }

  Future<void> _watch() async {
    if (_ad == 'loading' || _ad == 'done') return;
    setState(() => _ad = 'loading');
    final r = await RewardedAdService.instance.show();
    if (!mounted) return;
    if (r != RewardedAdResult.earned) {
      SfxService.play(Sfx.error);
      setState(() => _ad = 'failed');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(r == RewardedAdResult.failed
              ? 'No video available right now. Try again later.'
              : 'Watch the full video to claim your bonus coins.')));
      return;
    }
    final ok = await WalletService.credit(
      amount: widget.bonusReward,
      reason: 'ad_reward',
      idempotencyKey:
          'match_bonus_${DateTime.now().toUtc().millisecondsSinceEpoch}',
      refType: 'rewarded_ad',
      refId: widget.refId ?? AdMobConfig.rewardedUnitId,
    );
    if (!mounted) return;
    setState(() => _ad = ok ? 'done' : 'failed');
    SfxService.play(ok ? Sfx.rewardClaim : Sfx.error);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('+${widget.bonusReward} bonus coins added')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text(WalletService.error.value ?? 'Could not add coins')));
    }
  }

  Widget _coinPill(String text) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
      decoration: BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: C.border2)),
      child: Text(text,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)));

  Future<void> _shareWhatsApp() async {
    final text = widget.shareText!;
    final wa = Uri.parse(
        'https://wa.me/?text=${Uri.encodeComponent(text)}');
    var opened = false;
    try {
      opened = await launchUrl(wa, mode: LaunchMode.externalApplication);
    } catch (_) {}
    if (!opened) {
      // WhatsApp unavailable: fall back to the system share sheet.
      await SharePlus.instance.share(ShareParams(text: text));
    }
  }

  Widget _whatsAppButton() => SizedBox(
        height: 50,
        width: double.infinity,
        child: OutlinedButton(
          onPressed: _ad == 'loading' ? null : _shareWhatsApp,
          style: OutlinedButton.styleFrom(
            foregroundColor: _waGreen,
            backgroundColor: _waGreen.withValues(alpha: .08),
            side: BorderSide(color: _waGreen.withValues(alpha: .8)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
          ),
          child: const Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.chat_rounded, size: 20, color: _waGreen),
            SizedBox(width: 10),
            Text('Share on WhatsApp',
                style: TextStyle(
                    color: _waGreen,
                    fontWeight: FontWeight.w700,
                    fontSize: 15)),
          ]),
        ),
      );

  static const _waGreen = Color(0xFF25D366);

  Widget _bonusCard() {
    final done = _ad == 'done';
    final loading = _ad == 'loading';
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: C.teal.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: C.teal.withValues(alpha: .7)),
      ),
      child: Row(children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: C.teal.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: C.coin, width: 2),
            ),
            child: const Text('₹',
                style: TextStyle(
                    color: C.coin, fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    done
                        ? 'Bonus claimed!'
                        : 'Claim ${widget.bonusReward} Bonus Coins',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 2),
                Text.rich(
                  TextSpan(
                    style: const TextStyle(color: C.muted, fontSize: 12.5),
                    children: done
                        ? [
                            TextSpan(
                                text: '+${widget.bonusReward} coins',
                                style: const TextStyle(color: C.teal)),
                            const TextSpan(text: ' added to your wallet'),
                          ]
                        : [
                            const TextSpan(text: 'Watch a short video to get '),
                            TextSpan(
                                text: '+${widget.bonusReward}',
                                style: const TextStyle(color: C.teal)),
                          ],
                  ),
                ),
              ]),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 36,
          child: FilledButton(
            onPressed: done || loading ? null : _watch,
            style: FilledButton.styleFrom(
              backgroundColor: C.teal,
              disabledBackgroundColor: C.teal.withValues(alpha: .35),
              foregroundColor: const Color(0xFF04201F),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: loading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Color(0xFF04201F)))
                : done
                    ? const Icon(Icons.check_rounded, size: 20)
                    : const Text('CLAIM',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            letterSpacing: .5)),
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final showBonus = widget.bonusReward > 0;
    final coinText = _ad == 'done'
        ? '+${widget.baseCoins + widget.bonusReward} coins'
        : widget.coinText;
    return SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Tag('Game over'),
      const SizedBox(height: 12),
      widget.art,
      const SizedBox(height: 10),
      Heading(widget.title, size: 30, align: TextAlign.center),
      if (coinText != null) ...[
        const SizedBox(height: 12),
        _coinPill(coinText),
      ] else ...[
        const SizedBox(height: 8),
        Text(widget.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: C.muted)),
      ],
      const SizedBox(height: 18),
      if (showBonus) ...[
        _bonusCard(),
        const SizedBox(height: 12),
      ],
      if (widget.shareText != null) ...[
        _whatsAppButton(),
        const SizedBox(height: 12),
      ],
      SizedBox(
          width: double.infinity,
          child: PrimaryButton('Play again',
              onTap: _ad == 'loading'
                  ? null
                  : () => Navigator.pop(context, true))),
      const SizedBox(height: 12),
      SizedBox(
          width: double.infinity,
          child: GhostButton('Back to home',
              onTap: _ad == 'loading'
                  ? null
                  : () => Navigator.pop(context, false))),
    ]));
  }
}

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
    SfxService.play(Sfx.error);
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
    if (!await requireActiveAccount(c)) return;
    if (!c.mounted) return;
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
  if (!await requireActiveAccount(c)) return;
  if (!c.mounted) return;
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
      'expiresAt': room.expiresAt?.toIso8601String(),
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
