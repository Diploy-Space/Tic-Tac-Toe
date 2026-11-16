import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';

import '../models.dart';

/// Looping background music while a match screen is open.
///
/// Match screens call [start] when they open and [stop] when they close.
/// Respects the Settings → Music toggle ([musicOn]) live, and pauses while
/// the app is in the background.
class MatchMusicService with WidgetsBindingObserver {
  MatchMusicService._();
  static final MatchMusicService instance = MatchMusicService._();

  static const _asset = 'icon/music/ambient_loop.mp3'; // under assets/
  static const _volume = 0.45;

  AudioPlayer? _player;
  int _holders = 0; // open match screens
  bool _foreground = true;
  bool _wired = false;

  bool get _shouldPlay => _holders > 0 && musicOn.value && _foreground;

  void _wire() {
    if (_wired) return;
    _wired = true;
    musicOn.addListener(_sync);
    WidgetsBinding.instance.addObserver(this);
  }

  Future<AudioPlayer> _ensurePlayer() async {
    final existing = _player;
    if (existing != null) return existing;
    final p = AudioPlayer(playerId: 'match_music');
    await p.setReleaseMode(ReleaseMode.loop);
    await p.setVolume(_volume);
    // Mix with other audio; don't steal focus from e.g. a call.
    await p.setAudioContext(AudioContextConfig(
      focus: AudioContextConfigFocus.mixWithOthers,
    ).build());
    _player = p;
    return p;
  }

  /// A match screen opened.
  void start() {
    _wire();
    _holders++;
    _sync();
  }

  /// A match screen closed.
  void stop() {
    if (_holders > 0) _holders--;
    _sync();
  }

  Future<void> _sync() async {
    try {
      if (_shouldPlay) {
        final p = await _ensurePlayer();
        if (!_shouldPlay) return; // state changed while awaiting
        if (p.state == PlayerState.paused) {
          await p.resume();
        } else if (p.state != PlayerState.playing) {
          await p.play(AssetSource(_asset));
        }
      } else {
        final p = _player;
        if (p == null) return;
        if (_holders == 0) {
          await p.stop();
        } else if (p.state == PlayerState.playing) {
          await p.pause();
        }
      }
    } catch (e) {
      debugPrint('MatchMusicService: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    _sync();
  }
}
