import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';
import 'dialogs.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});
  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  int tab = 0;
  // TODO: replace sample friends with data from your backend.
  final friends = const [
    ['Aarav', '1', '0xFF3DD6F5'],
    ['Meera', '1', '0xFFFF5C95'],
    ['Kabir', '0', '0xFFFFC24D'],
    ['Sana', '0', '0xFFC9CCE0'],
  ];
  final requests = <String>['Rohan', 'Isha'];

  void _msg(String t) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  Widget _friend(List<String> f) {
    final online = f[1] == '1';
    return AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(children: [
          SoftAvatar(f[0], Color(int.parse(f[2]))),
          const SizedBox(width: 12),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(f[0], style: const TextStyle(fontWeight: FontWeight.w700)),
            Text(online ? '● Online' : 'Last seen 2h ago',
                style: TextStyle(color: online ? C.teal : C.muted, fontSize: 13)),
          ])),
          online
              ? SmallButton('Challenge', onTap: () async {
                  _msg('Challenge accepted — starting Pass & Play');
                  if (!mounted) return;
                  await startPassAndPlay(context);
                })
              : SmallButton('Invite',
                  color: C.border2, onTap: () => _msg('Invite sent to ${f[0]}')),
        ]));
  }

  Widget _request(String n) => AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(children: [
        SoftAvatar(n, C.muted),
        const SizedBox(width: 12),
        Expanded(child: Text(n, style: const TextStyle(fontWeight: FontWeight.w700))),
        SmallButton('Accept', color: C.teal, onTap: () {
          playerStats.friendsCount++;
          statsTick.value++;
          setState(() => requests.remove(n));
          _msg('$n added');
        }),
        const SizedBox(width: 8),
        SmallButton('Decline', color: C.border2, onTap: () {
          setState(() => requests.remove(n));
          _msg('Request declined');
        }),
      ]));

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: SingleChildScrollView(
        child: staggered([
          const TopBar('Friends'),
          const AppField(icon: Icons.person_outline, hint: 'Search by username'),
          SegRow(
              options: const ['Friends', 'Requests'],
              selected: tab,
              onChanged: (i) => setState(() => tab = i)),
          AppCard(
              borderColor: C.magenta,
              child: Row(children: [
                const IconCircle(Icons.card_giftcard),
                const SizedBox(width: 12),
                const Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Invite friends', style: TextStyle(fontWeight: FontWeight.w700)),
                  Text('Earn coins for every friend who joins',
                      style: TextStyle(color: C.muted, fontSize: 13)),
                ])),
                // TODO: open the share sheet with share_plus and your invite link.
                SmallButton('Share', onTap: () => _msg('Add share_plus to share your invite link')),
              ])),
          if (tab == 0)
            for (final f in friends) _friend(f)
          else
            for (final r in requests) _request(r),
        ], gap: 12),
      ),
    );
  }
}
