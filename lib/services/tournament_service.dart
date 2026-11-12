import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_service.dart';
import 'wallet_service.dart';

class TournamentSummary {
  final String id;
  final String name;
  final int entryFeeMinor;
  final String currencyCode;
  final int maxParticipants;
  final int registeredCount;
  final bool iAmRegistered;
  final String status;
  final int? bracketSize;
  final int prizePoolMinor;
  final DateTime? startsAt;
  final DateTime? registrationClosesAt;

  const TournamentSummary({
    required this.id,
    required this.name,
    required this.entryFeeMinor,
    required this.currencyCode,
    required this.maxParticipants,
    required this.registeredCount,
    required this.iAmRegistered,
    required this.status,
    this.bracketSize,
    required this.prizePoolMinor,
    this.startsAt,
    this.registrationClosesAt,
  });

  factory TournamentSummary.fromJson(Map<String, dynamic> j) =>
      TournamentSummary(
        id: '${j['id']}',
        name: '${j['name']}',
        entryFeeMinor: (j['entry_fee_minor'] as num?)?.toInt() ?? 0,
        currencyCode: '${j['currency_code'] ?? 'COIN'}',
        maxParticipants: (j['max_participants'] as num?)?.toInt() ?? 0,
        registeredCount: (j['registered_count'] as num?)?.toInt() ?? 0,
        iAmRegistered: j['i_am_registered'] == true,
        status: '${j['status']}',
        bracketSize: (j['bracket_size'] as num?)?.toInt(),
        prizePoolMinor: (j['prize_pool_minor'] as num?)?.toInt() ?? 0,
        startsAt: DateTime.tryParse('${j['starts_at'] ?? ''}'),
        registrationClosesAt:
            DateTime.tryParse('${j['registration_closes_at'] ?? ''}'),
      );
}

class TournamentService {
  TournamentService._();

  static final ValueNotifier<List<TournamentSummary>> list =
      ValueNotifier<List<TournamentSummary>>(const []);
  static final ValueNotifier<bool> loading = ValueNotifier<bool>(false);
  static final ValueNotifier<String?> error = ValueNotifier<String?>(null);
  static final ValueNotifier<String?> activeTournamentId =
      ValueNotifier<String?>(null);
  static final ValueNotifier<Map<String, dynamic>?> bracket =
      ValueNotifier<Map<String, dynamic>?>(null);

  static SupabaseClient get _db => Supabase.instance.client;

  static Map<String, dynamic>? _asMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return null;
  }

  static Future<void> refreshList() async {
    loading.value = true;
    error.value = null;
    try {
      final raw = await _db.rpc('list_tournaments');
      final map = _asMap(raw);
      if (map == null || '${map['status']}' != 'ok') {
        error.value = '${map?['message'] ?? 'Could not load tournaments'}';
        list.value = const [];
        return;
      }
      final items = map['items'];
      if (items is! List) {
        list.value = const [];
        return;
      }
      list.value = [
        for (final e in items)
          if (e is Map)
            TournamentSummary.fromJson(Map<String, dynamic>.from(e)),
      ];
    } catch (e, st) {
      debugPrint('TournamentService.refreshList: $e\n$st');
      error.value = AuthService.messageFromError(e);
      list.value = const [];
    } finally {
      loading.value = false;
    }
  }

  static Future<bool> register(String tournamentId) async {
    error.value = null;
    try {
      final raw = await _db.rpc(
        'register_for_tournament',
        params: {'p_tournament_id': tournamentId},
      );
      final map = _asMap(raw);
      if (map == null || '${map['status']}' != 'ok') {
        error.value = '${map?['message'] ?? 'Registration failed'}';
        return false;
      }
      activeTournamentId.value = tournamentId;
      await WalletService.refresh(migrateLocal: false);
      await refreshList();
      return true;
    } catch (e, st) {
      debugPrint('TournamentService.register: $e\n$st');
      error.value = AuthService.messageFromError(e);
      return false;
    }
  }

  static Future<void> loadBracket(String tournamentId) async {
    error.value = null;
    try {
      final raw = await _db.rpc(
        'get_tournament_bracket',
        params: {'p_tournament_id': tournamentId},
      );
      final map = _asMap(raw);
      if (map == null || '${map['status']}' != 'ok') {
        error.value = '${map?['message'] ?? 'Bracket unavailable'}';
        bracket.value = null;
        return;
      }
      activeTournamentId.value = tournamentId;
      bracket.value = map;
    } catch (e, st) {
      debugPrint('TournamentService.loadBracket: $e\n$st');
      error.value = AuthService.messageFromError(e);
      bracket.value = null;
    }
  }

  /// Admin RPC — requires profiles.is_admin.
  static Future<String?> adminCreateTournament({
    required String name,
    required int entryFee,
    required int maxParticipants,
    required DateTime registrationClosesAt,
    required DateTime startsAt,
    int moveTimeoutSec = 20,
    int joinTimeoutSec = 60,
  }) async {
    error.value = null;
    try {
      final raw = await _db.rpc('admin_create_tournament', params: {
        'p_name': name,
        'p_entry_fee': entryFee,
        'p_max_participants': maxParticipants,
        'p_registration_closes_at': registrationClosesAt.toUtc().toIso8601String(),
        'p_starts_at': startsAt.toUtc().toIso8601String(),
        'p_move_timeout_sec': moveTimeoutSec,
        'p_join_timeout_sec': joinTimeoutSec,
      });
      final map = _asMap(raw);
      if (map == null || '${map['status']}' != 'ok') {
        error.value = '${map?['message'] ?? 'Create failed'}';
        return null;
      }
      final id = '${map['tournament_id']}';
      activeTournamentId.value = id;
      await refreshList();
      return id;
    } catch (e, st) {
      debugPrint('TournamentService.adminCreateTournament: $e\n$st');
      error.value = AuthService.messageFromError(e);
      return null;
    }
  }

  static Future<Map<String, dynamic>?> adminGenerateBracket(
      String tournamentId) async {
    error.value = null;
    try {
      final raw = await _db.rpc(
        'admin_generate_bracket',
        params: {'p_tournament_id': tournamentId},
      );
      final map = _asMap(raw);
      if (map == null || '${map['status']}' != 'ok') {
        error.value = '${map?['message'] ?? 'Bracket failed'}';
        return null;
      }
      await loadBracket(tournamentId);
      await refreshList();
      return map;
    } catch (e, st) {
      debugPrint('TournamentService.adminGenerateBracket: $e\n$st');
      error.value = AuthService.messageFromError(e);
      return null;
    }
  }
}
