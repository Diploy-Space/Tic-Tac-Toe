import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models.dart';

class AppStorage {
  static const _kCoins = 'coins';
  static const _kSound = 'soundOn';
  static const _kMusic = 'musicOn';
  static const _kVibration = 'vibrationOn';
  static const _kNotifications = 'notificationsOn';
  static const _kLanguage = 'language';
  static const _kIntro = 'introSeen';
  static const _kOwned = 'owned';
  static const _kMark = 'equippedMark';
  static const _kBoard = 'equippedBoard';
  static const _kAvatar = 'equippedAvatar';
  static const _kStats = 'playerStats';
  static const _kBlocked = 'blockedPlayers';
  static const _kChallengeWho = 'challengePrivacyWho';
  static const _kFreeVideosDay = 'freeVideosDay';
  static const _kFreeVideosUsed = 'freeVideosUsed';

  static SharedPreferences? _prefs;
  static bool _bound = false;

  static int get challengePrivacyWho =>
      _prefs?.getInt(_kChallengeWho) ?? 0;

  static Future<void> setChallengePrivacyWho(int v) async {
    await _prefs?.setInt(_kChallengeWho, v.clamp(0, 2));
  }

  static String get _todayKey {
    final n = DateTime.now();
    return '${n.year}-${n.month}-${n.day}';
  }

  static int get freeVideosUsedToday {
    final p = _prefs;
    if (p == null) return 0;
    if (p.getString(_kFreeVideosDay) != _todayKey) return 0;
    return p.getInt(_kFreeVideosUsed) ?? 0;
  }

  static Future<void> incrementFreeVideosUsed() async {
    final p = _prefs;
    if (p == null) return;
    if (p.getString(_kFreeVideosDay) != _todayKey) {
      await p.setString(_kFreeVideosDay, _todayKey);
      await p.setInt(_kFreeVideosUsed, 1);
      return;
    }
    await p.setInt(_kFreeVideosUsed, freeVideosUsedToday + 1);
  }

  static bool isPlayerBlocked(String userId) {
    final id = userId.trim();
    if (id.isEmpty) return false;
    return _prefs?.getStringList(_kBlocked)?.contains(id) ?? false;
  }

  static Future<void> blockPlayer(String userId) async {
    final id = userId.trim();
    if (id.isEmpty || _prefs == null) return;
    final list = _prefs!.getStringList(_kBlocked) ?? <String>[];
    if (!list.contains(id)) {
      list.add(id);
      await _prefs!.setStringList(_kBlocked, list);
    }
  }

  static Future<void> unblockPlayer(String userId) async {
    final id = userId.trim();
    if (id.isEmpty || _prefs == null) return;
    final list = _prefs!.getStringList(_kBlocked) ?? <String>[];
    list.remove(id);
    await _prefs!.setStringList(_kBlocked, list);
  }

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await load();
    _bindAutosave();
    ensureMissionResets();
  }

  static Future<void> load() async {
    final p = _prefs;
    if (p == null) return;
    coins.value = p.getInt(_kCoins) ?? coins.value;
    soundOn.value = p.getBool(_kSound) ?? true;
    musicOn.value = p.getBool(_kMusic) ?? true;
    vibrationOn.value = p.getBool(_kVibration) ?? true;
    notificationsOn.value = p.getBool(_kNotifications) ?? false;
    language.value = p.getString(_kLanguage) ?? 'English';
    introSeen.value = p.getBool(_kIntro) ?? false;
    final ownedList = p.getStringList(_kOwned);
    if (ownedList != null) owned.value = ownedList.toSet();
    equippedMark.value = p.getString(_kMark) ?? 'Classic';
    equippedBoard.value = p.getString(_kBoard) ?? 'Dark';
    equippedAvatar.value = p.getInt(_kAvatar) ?? 0;
    // Drop invalid equip state (e.g. owned list reset / corrupt prefs).
    if (!owned.value.contains(equippedMark.value)) {
      equippedMark.value = 'Classic';
    }
    if (!owned.value.contains(equippedBoard.value)) {
      equippedBoard.value = 'Dark';
    }
    if (equippedAvatar.value < 0 || equippedAvatar.value > 2) {
      equippedAvatar.value = 0;
    }
    final raw = p.getString(_kStats);
    if (raw != null && raw.isNotEmpty) {
      try {
        playerStats.loadJson(jsonDecode(raw) as Map<String, dynamic>);
      } catch (_) {}
    }
  }

  static Future<void> save() async {
    final p = _prefs;
    if (p == null) return;
    await p.setInt(_kCoins, coins.value);
    await p.setBool(_kSound, soundOn.value);
    await p.setBool(_kMusic, musicOn.value);
    await p.setBool(_kVibration, vibrationOn.value);
    await p.setBool(_kNotifications, notificationsOn.value);
    await p.setString(_kLanguage, language.value);
    await p.setBool(_kIntro, introSeen.value);
    await p.setStringList(_kOwned, owned.value.toList());
    await p.setString(_kMark, equippedMark.value);
    await p.setString(_kBoard, equippedBoard.value);
    await p.setInt(_kAvatar, equippedAvatar.value);
    await p.setString(_kStats, jsonEncode(playerStats.toJson()));
  }

  static void _bindAutosave() {
    if (_bound) return;
    _bound = true;
    void bump() => save();
    coins.addListener(bump);
    soundOn.addListener(bump);
    musicOn.addListener(bump);
    vibrationOn.addListener(bump);
    notificationsOn.addListener(bump);
    language.addListener(bump);
    introSeen.addListener(bump);
    owned.addListener(bump);
    equippedMark.addListener(bump);
    equippedBoard.addListener(bump);
    equippedAvatar.addListener(bump);
    statsTick.addListener(bump);
  }

  static Future<void> clearAccount() async {
    coins.value = 500;
    owned.value = {'Classic', 'Shapes', 'Neon', 'Dark', 'Midnight'};
    equippedMark.value = 'Classic';
    equippedBoard.value = 'Dark';
    equippedAvatar.value = 0;
    playerStats.resetProgress();
    await save();
  }
}
