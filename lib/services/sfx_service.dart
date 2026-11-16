import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import '../models.dart';

/// Every sound in `assets/sfx/`, named after its file.
enum Sfx {
  // UI
  tap,
  buttonClick,
  // Gameplay
  placeO,
  placeX,
  countdownTick,
  countdownGo,
  matchFound,
  win,
  lose,
  draw,
  // Rewards
  coinCollect,
  rewardClaim,
  // Social / alerts
  challengeIncoming,
  messagePop,
  notification,
  chatReportSent,
  suspendAlert,
  error,
}

extension on Sfx {
  String get file => switch (this) {
        Sfx.tap => 'tap',
        Sfx.buttonClick => 'button_click',
        Sfx.placeO => 'place_o',
        Sfx.placeX => 'place_x',
        Sfx.countdownTick => 'countdown_tick',
        Sfx.countdownGo => 'countdown_go',
        Sfx.matchFound => 'match_found',
        Sfx.win => 'win',
        Sfx.lose => 'lose',
        Sfx.draw => 'draw',
        Sfx.coinCollect => 'coin_collect',
        Sfx.rewardClaim => 'reward_claim',
        Sfx.challengeIncoming => 'challenge_incoming',
        Sfx.messagePop => 'message_pop',
        Sfx.notification => 'notification',
        Sfx.chatReportSent => 'chat_report_sent',
        Sfx.suspendAlert => 'suspend_alert',
        Sfx.error => 'error',
      };

  /// Rapid-fire sounds get more players so overlaps don't cut off.
  int get voices => switch (this) {
        Sfx.tap || Sfx.buttonClick || Sfx.placeO || Sfx.placeX => 3,
        Sfx.countdownTick || Sfx.messagePop || Sfx.coinCollect => 2,
        _ => 1,
      };

  double get volume => switch (this) {
        Sfx.tap || Sfx.buttonClick => .5,
        Sfx.countdownTick => .7,
        _ => .9,
      };
}

/// Short sound effects. Respects Settings → Sound effects ([soundOn]).
class SfxService {
  SfxService._();

  static final Map<Sfx, AudioPool> _pools = {};
  static Future<void>? _loading;

  /// Preloads every sound. Safe to call more than once.
  static Future<void> init() => _loading ??= _load();

  static Future<void> _load() async {
    try {
      // Mix with music and other apps instead of taking audio focus.
      await AudioPlayer.global.setAudioContext(AudioContextConfig(
        focus: AudioContextConfigFocus.mixWithOthers,
      ).build());
    } catch (e) {
      debugPrint('SfxService audio context: $e');
    }
    await Future.wait(Sfx.values.map((s) async {
      try {
        _pools[s] = await AudioPool.createFromAsset(
          path: 'sfx/${s.file}.mp3',
          maxPlayers: s.voices,
        );
      } catch (e) {
        debugPrint('SfxService load ${s.file}: $e');
      }
    }));
  }

  /// Fire-and-forget playback.
  static void play(Sfx s) {
    if (!soundOn.value) return;
    unawaited(_play(s));
  }

  /// Plays [s] after [delay] (e.g. coins after the win jingle).
  static void playLater(Sfx s, Duration delay) {
    Timer(delay, () => play(s));
  }

  static Future<void> _play(Sfx s) async {
    try {
      await init();
      await _pools[s]?.start(volume: s.volume);
    } catch (e) {
      debugPrint('SfxService play ${s.file}: $e');
    }
  }

  /// Mark placed on the board.
  static void place(String mark) => play(mark == 'X' ? Sfx.placeX : Sfx.placeO);
}

/// Wraps a tap handler so it plays [s] first. Keeps `null` (disabled) as-is.
VoidCallback? sfxTap(VoidCallback? f, [Sfx s = Sfx.buttonClick]) =>
    f == null
        ? null
        : () {
            SfxService.play(s);
            f();
          };
