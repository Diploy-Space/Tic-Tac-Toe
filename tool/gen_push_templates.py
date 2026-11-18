#!/usr/bin/env python3
"""Builds supabase/functions/send-push/templates.json from the ARB files so
push notifications use the same 22-language texts as the app.

    python3 tool/gen_push_templates.py

Re-run after changing any notif* string, then redeploy `send-push`.
Keep TYPES in sync with lib/services/notification_service.dart.
"""
import json, os

ROOT = os.path.join(os.path.dirname(__file__), '..')
ARB = os.path.join(ROOT, 'lib', 'l10n', 'arb')
OUT = os.path.join(ROOT, 'supabase', 'functions', 'send-push', 'templates.json')

# type -> (title key, body key). match_result picks its title by data.result.
TYPES = {
    'challenge_request': ('notifChallengeRequestTitle', 'notifChallengeRequestBody'),
    'challenge_accepted': ('notifChallengeAcceptedTitle', 'notifChallengeAcceptedBody'),
    'challenge_declined': ('notifChallengeDeclinedTitle', 'notifChallengeDeclinedBody'),
    'challenge_busy': ('notifChallengeBusyTitle', 'notifChallengeBusyBody'),
    'challenge_expired': ('notifChallengeExpiredTitle', 'notifChallengeExpiredBody'),
    'challenge_cancelled': ('notifChallengeCancelledTitle', 'notifChallengeCancelledBody'),
    'room_joined': ('notifRoomJoinedTitle', 'notifRoomJoinedBody'),
    'match_result:win': ('notifMatchWonTitle', 'notifMatchBody'),
    'match_result:loss': ('notifMatchLostTitle', 'notifMatchBody'),
    'match_result:draw': ('notifMatchDrawTitle', 'notifMatchBody'),
    'coins_debit': ('notifCoinsDebitTitle', 'notifCoinsDebitBody'),
    'coins_purchase': ('notifCoinsPurchaseTitle', 'notifCoinsAddedBody'),
    'coins_reward': ('notifCoinsRewardTitle', 'notifCoinsRewardBody'),
    'coins_credit': ('notifCoinsCreditTitle', 'notifCoinsAddedBody'),
    'friend_request': ('notifFriendRequestTitle', 'notifFriendRequestBody'),
    'friend_accepted': ('notifFriendAcceptedTitle', 'notifFriendAcceptedBody'),
}

out = {}
for f in sorted(os.listdir(ARB)):
    if not f.endswith('.arb'):
        continue
    lang = f[len('app_'):-len('.arb')]
    arb = json.load(open(os.path.join(ARB, f), encoding='utf-8'))
    out[lang] = {t: [arb.get(a), arb.get(b)] for t, (a, b) in TYPES.items()
                 if arb.get(a) and arb.get(b)}
with open(OUT, 'w', encoding='utf-8') as fh:
    json.dump(out, fh, ensure_ascii=False, indent=1)
    fh.write('\n')
print(f'{len(out)} languages → {OUT}')
