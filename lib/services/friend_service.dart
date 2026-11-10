import 'package:flutter/foundation.dart';
import '../models.dart';
import '../models/friendship.dart';
import 'auth_service.dart';
import 'friend_repository.dart';

class FriendService {
  FriendService._();

  static final ValueNotifier<List<Friendship>> friends =
      ValueNotifier<List<Friendship>>(const []);
  static final ValueNotifier<List<Friendship>> incoming =
      ValueNotifier<List<Friendship>>(const []);
  static final ValueNotifier<int> tick = ValueNotifier<int>(0);

  static void clear() {
    friends.value = const [];
    incoming.value = const [];
    tick.value++;
  }

  static Future<void> refresh() async {
    if (!AuthService.isSignedIn) {
      clear();
      return;
    }
    try {
      final all = await FriendRepository.fetchMine();
      final uid = AuthService.user!.id;
      friends.value = [
        for (final f in all)
          if (f.status == 'accepted') f,
      ];
      incoming.value = [
        for (final f in all)
          if (f.status == 'pending' && f.addresseeId == uid) f,
      ];
      playerStats.friendsCount = friends.value.length;
      statsTick.value++;
      tick.value++;
    } catch (e) {
      debugPrint('FriendService.refresh: $e');
    }
  }

  static Future<List<ProfileSearchHit>> search(String q) =>
      FriendRepository.searchProfiles(q);

  static Future<void> sendRequest(String userId) async {
    await FriendRepository.sendRequest(userId);
    await refresh();
  }

  static Future<void> accept(String friendshipId) async {
    await FriendRepository.accept(friendshipId);
    await refresh();
  }

  static Future<void> decline(String friendshipId) async {
    await FriendRepository.decline(friendshipId);
    await refresh();
  }

  static Future<void> remove(String friendshipId) async {
    await FriendRepository.remove(friendshipId);
    await refresh();
  }
}
