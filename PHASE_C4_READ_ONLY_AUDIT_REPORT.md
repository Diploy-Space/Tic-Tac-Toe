# PHASE C4 — Read-Only Security Audit Report

**Project:** Tic Tac Toe (Flutter + Dart + Supabase)  
**Scope:** Server-side turn, move, board, and game-result validation for online multiplayer  
**Prior phases:** C1 (matchmaking), C2 (Realtime + moves), C3 (private rooms), D1–D4 (offline)  
**Audit mode:** READ-ONLY — no code, SQL, RLS, or dependency changes were made  
**Evidence basis:** Repository migrations under `supabase/migrations/` and Flutter sources under `lib/`  
**Production / Dashboard:** NOT VERIFIED (no live Supabase project inspection in this audit)

**Verification legend**
- **VERIFIED** — Confirmed in repository source (SQL or Dart)
- **NOT VERIFIED** — Requires Dashboard / live DB / runtime proof
- **VULNERABLE** — Gap or weakness confirmed in repository source

---

## 1. Executive Summary

The online multiplayer stack already has a **strong move-submission foundation**:

| Control | Status |
|---------|--------|
| Auth required for move RPC | VERIFIED |
| Participant-only moves | VERIFIED |
| Turn enforcement (`current_turn` vs auth mark) | VERIFIED |
| Cell bounds + occupied-cell checks | VERIFIED |
| Mark derived server-side from `auth.uid()` (client cannot choose O/X) | VERIFIED |
| Row lock `FOR UPDATE` + `move_count` optimistic concurrency | VERIFIED |
| Direct client UPDATE/INSERT/DELETE on `multiplayer_rooms` (per migration grants) | Denied in SQL — production grants **NOT VERIFIED** |
| Server-side win / draw / finish | **Missing (intentional C2 deferral)** — **VULNERABLE** vs C4 goals |
| Server-side match history / coin settlement for online | **Missing** |
| Client-submitted winner/result via move RPC | Not possible — VERIFIED (RPC has no winner params) |

**Bottom line:** C4 is the designed next step. The architecture is **ready for C4 implementation** without prerequisite redesign. The critical missing piece is **server-derived terminal state** (win/draw → `winner` + `status`) after each validated move. Related HIGH issue: `public.matches` allows authenticated self-inserts including `mode = 'online'`, so leaderboard integrity is client-trusting today.

**Recommendation:** Proceed with C4 implementation after approval. No blocking prerequisite schema rewrite is required; extend `submit_online_move` (and related finish/settlement RPCs as needed) while preserving C1–C3 and D1–D4.

---

## 2. Existing Database Schema

### 2.1 `public.multiplayer_rooms` (C1 → C2 → C3)

**Created / evolved in:**  
`supabase/migrations/005_multiplayer_queue.sql`, `006_multiplayer_realtime.sql`, `007_private_rooms.sql`

| Column | Role | Client-controlled via RPC? | Server-controlled? |
|--------|------|----------------------------|--------------------|
| `id` | Room UUID PK | No (generated) | Yes |
| `board_size` | 3\|4\|5 | Set at create/match only | Yes after create |
| `stake` | 10\|25\|50\|100 | Set at create/match only | Yes after create |
| `player_o` / `player_x` | Participant UUIDs | Via matchmaking / private join RPCs | Yes |
| `status` | waiting\|matched\|active\|finished\|completed\|cancelled\|expired\|abandoned | Via RPCs only (intended) | Yes |
| `board` | JSONB cell array | **Only via `submit_online_move` cell write** | Yes |
| `current_turn` | `'O'`\|`'X'` | No direct client write | Yes (flipped on move) |
| `move_count` | Monotonic move counter | Client sends *expected* value for OCC; server owns truth | Yes |
| `winner` | `'O'`\|`'X'`\|`'draw'`\|null | **No RPC sets this today** | Intended server; currently unused |
| `code` / `visibility` / `expires_at` | Private rooms (C3) | Create/join RPCs | Yes |
| `created_at` / `updated_at` | Timestamps | No | Yes |

**Constraints (VERIFIED in migrations):** board_size, stake, status, visibility, current_turn, winner domain, distinct players, unique non-null `code`.

**Move history table:** **None** — only current `board` snapshot. NOT present in repo.

**Indexes (VERIFIED):** players idx; queue search idx; private code unique / waiting code idx.

**Triggers (VERIFIED):** `multiplayer_rooms_init_board` → `_mp_init_room_board()` initializes empty board / turn / `updated_at`.

### 2.2 `public.multiplayer_queue` (C1)

Own-row SELECT only for authenticated; mutations via SECURITY DEFINER RPCs (per migration comments/grants).

### 2.3 `public.matches` (cloud history / leaderboard)

**File:** `supabase/migrations/003_matches_and_stats.sql`

- Modes: `ai` \| `quick_match` \| `online`
- RLS: SELECT/INSERT own rows (`auth.uid() = user_id`)
- **Grant:** `select, insert` to `authenticated`
- Online PvP does **not** write here from Flutter today; AI/`quick_match` do via `MatchSyncService`
- **Client can still INSERT `mode='online'` rows via PostgREST** if JWT is valid — VERIFIED policy design, production enforcement **NOT VERIFIED**

### 2.4 Field control summary

| Capability | Who controls |
|------------|--------------|
| Placing a mark on a cell | Server (`submit_online_move`) using auth-derived mark |
| Declaring winner | **Nobody in app path today** (column unused) |
| Finishing room status | Not set by move RPC |
| Recording ranked online result | Client-capable via `matches` insert; app does not for online |

---

## 3. Existing RPC Inventory

All multiplayer RPCs below are **SECURITY DEFINER** with **`set search_path = public`** (VERIFIED in SQL). Execute grants: `authenticated` only (revoke from `public`); live role grants **NOT VERIFIED**.

### 3.1 C1 — Matchmaking

| Function | Signature | Auth | Notes |
|----------|-----------|------|-------|
| `join_online_matchmaking` | `(p_board_size int, p_stake int) → jsonb` | `auth.uid()` required | Advisory lock; `FOR UPDATE SKIP LOCKED` opponent; creates room |
| `poll_online_matchmaking` | `() → jsonb` | Required | Searching / matched / timeout |
| `leave_online_matchmaking` | `() → jsonb` | Required | Deletes own searching row |
| `_mp_cleanup_stale_queue` | `() → void` | Internal | Revoked from anon/authenticated |
| `_mp_match_payload` | `(uuid, uuid) → jsonb` | Internal | Participant mark/opponent |

**Bypass risk:** Clients cannot invent opponent IDs through these RPCs without being paired. Direct table insert into rooms denied by grants in migration.

### 3.2 C2 — Snapshot & moves

| Function | Signature | Auth | Turn / board checks |
|----------|-----------|------|---------------------|
| `get_online_room` | `(p_room_id uuid) → jsonb` | Required + participant | Activates C1 `matched`→`active`; returns board/turn/winner |
| `submit_online_move` | `(p_room_id uuid, p_cell_index int, p_expected_move_count int) → jsonb` | Required + participant | See §5–§8 |
| `_mp_empty_board` | `(int) → jsonb` | Internal | Empty JSON null array |
| `_mp_init_room_board` | trigger | Definer | Board init |

**Latest body:** `007_private_rooms.sql` replaces `get_online_room` and `submit_online_move` from `006`.

**Explicit comment in `006_multiplayer_realtime.sql` line ~146:**  
> “Lightweight move submit (C2 sync). Full win/forfeit validation is C4.”

### 3.3 C3 — Private rooms

| Function | Signature | Auth | Notes |
|----------|-----------|------|-------|
| `create_private_room` | `(board_size, stake) → jsonb` | Required | Host = O; status `waiting`; code |
| `join_private_room` | `(p_code text) → jsonb` | Required | `FOR UPDATE`; sets X; `active` |
| `cancel_private_room` | `(p_room_id uuid) → jsonb` | Host only | waiting → cancelled |
| `_mp_new_room_code` | `() → text` | Internal | Also `007a_fix_room_code_random.sql` |
| `_mp_expire_private_rooms` | `() → void` | Internal | waiting past `expires_at` |

### 3.4 Missing RPCs (relevant to C4)

| Capability | Present? |
|------------|----------|
| Complete / settle match | **No** |
| Forfeit / resign | **No** |
| Reconnect-specific RPC | **No** (reuse `get_online_room`) |
| Server write of `matches` for online | **No** |
| Client RPC to set `winner` | **No** (good) |

### 3.5 Can clients bypass rules by calling RPCs directly?

| Attack | Via RPC? |
|--------|----------|
| Move as non-participant | Rejected — VERIFIED |
| Choose opponent’s mark | Impossible — mark from `auth.uid()` — VERIFIED |
| Submit winner UUID | No parameter — VERIFIED |
| Submit full board overwrite | No parameter — VERIFIED |
| Play after waiting/cancelled/expired/finished | Rejected by status list — VERIFIED |
| Keep playing after a geometric win | **Allowed today** — winner never set — **VULNERABLE** |

---

## 4. RLS & Security Analysis

### 4.1 `multiplayer_rooms` (migration VERIFIED)

```
enable RLS
revoke all from anon, authenticated
grant select to authenticated
policy: select where auth.uid() in (player_o, player_x)
-- comment: no direct insert/update/delete — SECURITY DEFINER RPCs only
```

| Operation | Policy | Grant | Effective (if migration applied) |
|-----------|--------|-------|----------------------------------|
| SELECT | Participants | Yes | Allowed for members |
| INSERT | None | No | Denied |
| UPDATE | None | No | Denied |
| DELETE | None | No | Denied |

**Implication:** Direct REST updates of `board` / `winner` / `current_turn` should fail without table UPDATE privilege.  
**Production application of these grants/policies:** **NOT VERIFIED**.

### 4.2 `multiplayer_queue`

SELECT own row only; no client write grants in migration — VERIFIED in SQL; live **NOT VERIFIED**.

### 4.3 `matches`

SELECT + INSERT own rows — **VERIFIED**. Authenticated user can insert arbitrary `result` / `mode` including `online` / `win`.  
**VULNERABLE** for leaderboard / stats integrity (not board state).

### 4.4 RPC execution

- `revoke all … from public` + `grant execute … to authenticated` on move/matchmaking/private RPCs — VERIFIED in SQL  
- Anonymous execute: intended denied — live **NOT VERIFIED**  
- Service-role key in client: **Not found in audited Flutter config pattern** (publishable key only in `lib/config/supabase_config.dart`). Service role must never ship in app — treat as operational requirement; key material not reproduced here.

### 4.5 Realtime

`006` adds `multiplayer_rooms` to `supabase_realtime` publication + `replica identity full`.  
Whether Realtime respects RLS for non-participants in the deployed project: **NOT VERIFIED**.

---

## 5. Server-side Turn Validation Analysis

Source of truth for moves: **`public.submit_online_move`** in `supabase/migrations/007_private_rooms.sql` (supersedes `006`).

| Check | Present? | Evidence |
|-------|----------|----------|
| 1. Authenticated user | Yes | `auth.uid()` null → error |
| 2. User belongs to room | Yes | Must be `player_o` or `player_x` |
| 3. Game allow-list status | Partial | Rejects waiting/cancelled/expired/finished/completed/abandoned; allows `matched`→active and `active` |
| 4. It is player’s turn | Yes | `current_turn` must equal auth mark |
| 5. Cell in bounds | Yes | `0 .. board_size²-1` |
| 6. Cell empty | Yes | JSON null check |
| 7. Move valid per win-length rules | **N/A for placement** (any empty cell is legal under tic-tac-toe) | Rules for *ending* game missing |
| 8. Accept once / atomic turn change | Yes | `FOR UPDATE` + flip `current_turn` + `move_count+1` in same update |
| 9. Opponent present | Yes | `player_x is null` → error |
| 10. Terminal state blocks further moves | **Incomplete** | Relies on `status` finished/completed; **`winner` never set, status never finished by move RPC** |

**Classification:** Turn/auth/cell gates are **HIGH-quality for C2**. Absence of post-win lock via derived `winner`/`finished` is the **C4 CRITICAL gap**.

---

## 6. Board Validation Analysis

| Topic | Finding |
|-------|---------|
| Who writes cells | Server only, single cell via `jsonb_set` |
| Client-supplied board | Not accepted — VERIFIED |
| Length invariant after move | **Not re-asserted** (trusts existing board + index) — MEDIUM |
| Cell alphabet (`O`/`X`/null only) | **Not scanned** on whole board — MEDIUM (corruption would require prior DB write) |
| Board size vs array length | Init via `_mp_empty_board`; no ongoing CHECK constraint on jsonb shape — MEDIUM |
| Occupied overwrite | Rejected — VERIFIED |
| Out-of-range index | Rejected — VERIFIED |

**Invalid board states:** Unlikely via honest RPC use; possible if service role / SQL editor / broken prior state. C4 should optionally assert `jsonb_array_length(board) = board_size*board_size` before apply.

---

## 7. Win/Draw Validation Analysis

| Question | Answer |
|----------|--------|
| Server calculates X win / O win / draw? | **No** — VULNERABLE vs C4 objective |
| Server sets `winner`? | **No** path in RPCs |
| Server sets `status` to finished/completed on win? | **No** |
| Server sets winner UUID field? | **No such column** (winner is mark or `draw`) |
| Client can submit winner via `submit_online_move`? | **No** — VERIFIED |
| Client UI computes online win locally? | **No** — `OnlineGameScreen` displays `room.winner` only |
| Match completion → `matches` row? | **Not implemented** for online |

**Existing local win rules (must be mirrored, not changed):**  
`lib/game/board.dart` — 3×3 needs 3-in-a-row; 4×4/5×5 need 4-in-a-row (`winLength`).

**Exploitation today:** Players can continue placing marks after a winning line exists; UI never shows “You win” from server; no authoritative finish.  
**Fake winner via RPC:** Not available.  
**Fake winner via direct UPDATE:** Should fail if grants match migrations — production **NOT VERIFIED**.  
**Fake online win on leaderboard:** Possible via `matches` INSERT — **VULNERABLE (HIGH/CRITICAL for rankings)**.

---

## 8. Concurrent Request & Transaction Safety

| Scenario | Protection | Verdict |
|----------|------------|---------|
| Two players move at once | `FOR UPDATE` on room row; only matching `current_turn` succeeds | VERIFIED strong |
| Same player double-submit same turn | Client `submitInFlight`; server turn flip + `move_count` OCC | VERIFIED layered |
| Two requests same `p_expected_move_count` | Serialized by row lock; second sees stale count or wrong turn | VERIFIED |
| Lost update on board | Single-row lock + single writer path | VERIFIED |
| `get_online_room` activate race | Update without `FOR UPDATE` when matched→active | LOW/MEDIUM edge |
| Private join race | `FOR UPDATE` + `player_x is null` conditional update | VERIFIED |
| Matchmaking pair race | `SKIP LOCKED` + advisory lock | VERIFIED |

**Multiple winners:** Not applicable until win logic exists; post-C4 must set winner once inside same locked transaction as the completing move.

---

## 9. Flutter Client Integration Analysis

### 9.1 Move path

| Component | Path | Behavior |
|-----------|------|----------|
| UI | `lib/screens/online_game_screen.dart` | Tap → local guards → `OnlineRealtimeService.submitMove` |
| Service | `lib/services/online_realtime_service.dart` | Optimistic cell; RPC `submit_online_move`; reconcile on error/stale |
| State | `lib/models/online_room_state.dart` | `isMyTurn` requires `winner == null` and `roomStatus == 'active'` |
| Payload | `p_room_id`, `p_cell_index`, `p_expected_move_count` only | No winner/board — good |

### 9.2 Trust model

- **Authoritative truth:** PostgreSQL snapshot (design comment in service)
- **Optimistic UI:** Temporary; rolled back via `fetchSnapshot` on error/stale
- **Does client trust local win for online?** No local win engine on online path — waits for `winner` (never set today)
- **Duplicate submit protection:** `submitInFlight` ValueNotifier — VERIFIED
- **Reconnect:** `WidgetsBindingObserver` resume → `refresh()`; Realtime resubscribe path re-fetches — VERIFIED client-side
- **Online → cloud `MatchSyncService`:** Not used for online rooms — VERIFIED
- **Offline D1–D4:** Online entry gated; local AI unchanged — compatible

### 9.3 Compatibility notes

- C1: `/online-matching` → `/online-room` with `OnlineRoomArgs`
- C3: private lobby/join → same `OnlineGameScreen` / `submit_online_move`
- Leaving game only `detach()` — **no server forfeit** (MEDIUM product/security gap)

---

## 10. Security Vulnerability List

### CRITICAL

#### C4-01 — No server-side win/draw/finish after moves
- **Where:** `public.submit_online_move` (`006` / superseded by `007_private_rooms.sql`); comment explicitly defers to C4
- **Problem:** `winner` never set; `status` stays `active`; play can continue past winning boards
- **Exploit:** Ignore geometric wins; prolong or distort match; UI never authoritative end-state
- **Fix:** After successful cell write, server evaluates win/draw using same rules as `Board` (3 or 4 in a row); set `winner`, `status='finished'`, stop further moves
- **Regression risk:** Low–medium if winLength mismatched with Flutter `Board`

#### C4-02 — `matches` self-insert allows fabricated `online` results (leaderboard)
- **Where:** `003_matches_and_stats.sql` policies; `MatchRepository.insertMatch`
- **Problem:** Any authenticated user can INSERT `mode='online', result='win'`
- **Exploit:** Inflate leaderboard / statistics without playing
- **Fix (C4-aligned):** Disallow client insert for `mode='online'`; server SECURITY DEFINER writes both players’ results on finish; or CHECK + trigger rejecting client online inserts
- **Regression risk:** Medium for AI/`quick_match` sync path — keep those modes working

### HIGH

#### C4-03 — No forfeit / abandon server path
- **Where:** Flutter `_leave` only detaches; no RPC
- **Problem:** Rooms can remain `active` forever; opponent stuck
- **Exploit:** Griefing / stalling (not board spoofing)
- **Fix:** `forfeit_online_room` / timeout job setting winner + finished
- **Regression risk:** Low if optional in C4 scope

#### C4-04 — Production RLS/grants/Realtime not proven
- **Where:** Live Supabase project
- **Problem:** Audit cannot confirm migrations applied identically
- **Exploit:** If UPDATE were granted on `multiplayer_rooms`, clients could rewrite board/winner
- **Fix:** Dashboard verification checklist before C4 ship
- **Regression risk:** N/A (ops)

### MEDIUM

#### C4-05 — No whole-board structural assertions in move RPC
- **Where:** `submit_online_move`
- **Problem:** Corrupt/truncated `board` jsonb not rejected
- **Fix:** Assert array length and cell domain before write
- **Regression risk:** Low

#### C4-06 — `get_online_room` matched→active without row lock
- **Where:** `get_online_room` in `007_private_rooms.sql`
- **Problem:** Minor race under concurrent first fetches
- **Fix:** `FOR UPDATE` when transitioning status
- **Regression risk:** Low

#### C4-07 — No move audit log
- **Where:** Schema
- **Problem:** Harder to dispute/replay cheating investigations
- **Fix:** Optional `multiplayer_moves` append-only table in C4+
- **Regression risk:** Low

### LOW

#### C4-08 — Status vocabulary overlap (`finished` vs `completed`)
- **Where:** status check constraint in `007`
- **Problem:** Ambiguity for clients/jobs
- **Fix:** Standardize on one terminal status in C4
- **Regression risk:** Low if Flutter only checks `winner` / finished set

#### C4-09 — Online stake displayed but not server-settled
- **Where:** `OnlineGameScreen` stake label; no coin RPC
- **Problem:** Economic rules incomplete (not board integrity)
- **Fix:** Separate economy phase; do not block C4 validation
- **Regression risk:** N/A for validation scope

---

## 11. Security Test Matrix

| # | Scenario | Expected secure behavior | Existing protection | Current vulnerability | Testability |
|---|----------|--------------------------|---------------------|----------------------|-------------|
| 1 | Unauthorized user submits move | Reject | Auth null check in RPC | None if JWT required | SQL/RPC test as anon |
| 2 | Non-room player submits move | Reject | Participant check | None if RPC enforced | Second user JWT + room_id |
| 3 | Out-of-turn move | Reject “Not your turn” | `current_turn` gate | None for turn | Alternate marks |
| 4 | Occupied cell | Reject | Cell null check | None | Replay same index |
| 5 | Out-of-range index | Reject | Bounds check | None | index -1 / 99 |
| 6 | Multiple simultaneous moves (same player) | One success | `FOR UPDATE` + OCC + client inflight | Residual if client bypasses inflight — server still OK | Parallel HTTP |
| 7 | Overwrite full board via REST | Deny | No UPDATE grant/policy (migration) | **NOT VERIFIED** live | PostgREST PATCH |
| 8 | Fake winner UUID via move RPC | Impossible | No param | N/A | Inspect signature |
| 9 | Fake draw via move RPC | Impossible | No param | N/A | Inspect signature |
| 10 | Finish without winning board | Should reject | **No finish RPC** | Finish not implemented | After C4 |
| 11 | Both players move simultaneously | One accepted | Row lock + turn | None expected | Parallel requests |
| 12 | Move after match completion | Reject | Status list **if** finished set | **Games never finish** today | After C4 |
| 13 | Unauthenticated move RPC | Reject / 401 | Auth check + grant to authenticated | Live grants **NOT VERIFIED** | Anon key call |
| 14 | Direct DB manipulation of board/winner | Deny for authenticated | RLS + revoke UPDATE | Live **NOT VERIFIED**; service role always can | Dashboard/SQL |
| 15 | Reconnect then valid move | Snapshot then move OK | `get_online_room` + submit | Works if still active | Lifecycle test |
| 16 | Continue after 3-in-a-row | Should lock board | **Missing** | **VULNERABLE** | Play to win, move again |
| 17 | Insert `matches` online win | Should deny or server-only | Insert allowed | **VULNERABLE** | REST insert |

---

## 12. C1–C3 Compatibility Assessment

| Phase | Impact of C4 (planned) | Risk if done carefully |
|-------|------------------------|------------------------|
| **C1** Matchmaking | Rooms still created the same; moves already use shared RPC | Low |
| **C2** Realtime | Extra column updates (`winner`, `status`) still notify clients; Flutter already reads `winner` | Low — UI mostly ready |
| **C3** Private rooms | Same `submit_online_move` / `get_online_room` | Low — keep waiting-room move rejection |
| AI / board rules | Must **port** `Board` winLength semantics into SQL/plpgsql or immutable SQL helpers — do not change Flutter AI | Medium if mismatched |
| Local history | Unaffected | None |

**Do not redesign** matchmaking, Realtime subscribe pattern, or private codes for C4.

---

## 13. D1–D4 Offline Compatibility Assessment

| Offline feature | C4 interaction |
|-----------------|----------------|
| ConnectivityService gates online entry | Compatible — C4 is server-side when online |
| Local Doll / Random AI / Pass & Play | Unrelated to `submit_online_move` |
| Skip cloud sync when offline | Unaffected |
| OnlineGameScreen | Still requires network; C4 finish still server-authoritative |

**No conflict.** Avoid making online finish depend on client connectivity beyond the move RPC itself.

---

## 14. Recommended Database Changes

*(Recommendations only — not implemented.)*

1. Keep `winner` + `status` as terminal fields; standardize terminal status (`finished`).
2. Optionally add CHECK or trigger: if `winner is not null` then `status in ('finished','completed')`.
3. Optional `multiplayer_moves` audit table `(room_id, move_count, cell_index, mark, user_id, created_at)` PK `(room_id, move_count)`.
4. Restrict `matches` inserts: prevent `mode = 'online'` from client role; allow only SECURITY DEFINER settler.
5. Optional board shape constraint helper used inside move RPC.
6. **Do not** change C1 queue schema or C3 code generation for C4.

---

## 15. Recommended RPC Changes

*(Recommendations only — not implemented.)*

1. **Extend `submit_online_move`** (same signature preferred for Flutter compatibility):
   - After placing mark under `FOR UPDATE`:
     - Evaluate win for mover (3×3 → 3; 4×4/5×5 → 4)
     - Else if board full → `draw`
     - If terminal: set `winner`, `status='finished'`, do **not** flip turn (or flip irrelevant)
     - Else: flip turn as today
   - Reject moves when `winner is not null` OR status finished
2. **Add** `forfeit_online_room(p_room_id)` — participant only; sets opponent win + finished
3. **Add** `settle_online_match(p_room_id)` or fold into finish — inserts **both** players’ `matches` rows server-side; idempotent
4. Keep `get_online_room` returning `winner` / `room_status` (already does)
5. Preserve SECURITY DEFINER + `search_path = public` + authenticated execute

---

## 16. Recommended Flutter Changes

*(Recommendations only — not implemented.)*

1. **Minimal:** When `room.winner != null`, disable board (partially already via `isMyTurn`); show result dialog; leave CTA
2. Keep optimistic UI; on snapshot with winner, stop submits
3. Do **not** locally declare online winners for ranking
4. Optional: call forfeit RPC on confirmed leave
5. Do not wire online results through client `MatchSyncService.syncCompletedMatch` once server settles
6. Preserve D1–D4 gates and C1–C3 navigation

---

## 17. Implementation Plan (Step-by-Step)

1. **Verify production** matches migrations (RLS, grants, RPC signatures, Realtime publication) — ops checklist  
2. **SQL helper** `_mp_wins_at(board, size, index, mark)` mirroring `Board.winsAt` / winLength  
3. **Patch `submit_online_move`** — terminal detection + reject post-finish; keep OCC/turn/cell checks  
4. **Flutter UX** — result dialog when `winner` set; regression on C1/C3 entry  
5. **Tests** — SQL unit tests for win/draw/out-of-turn/double-move; Dart tests for UI disabled state  
6. **`matches` lockdown** for `online` + server settle RPC (may be C4b if scoped)  
7. **Forfeit / stale-room job** (may be C4b)  
8. **Security matrix re-run** (scenarios 8–12, 16–17) against staging  

**Do not** modify AI algorithms, offline connectivity, or C1 pairing logic in this phase.

---

## 18. Final C4 Readiness Assessment

| Question | Answer |
|----------|--------|
| Is architecture ready for C4? | **Yes** |
| Prerequisite redesign required? | **No** |
| Blocking gaps before coding? | Confirm **live** RLS/grants (**NOT VERIFIED** here); then implement win/draw in `submit_online_move` |
| Biggest integrity hole today | No server terminal state after wins; optional separate hole: client `matches` inserts for `online` |
| Safe to approve implementation? | **Yes**, with C4 scoped to server validation + Flutter result handling; treat leaderboard settle as included or explicitly phased |

### Verdict

**READY FOR C4 IMPLEMENTATION** after approval.

The C2 move pipeline already enforces **authorization, turn, occupancy, bounds, and concurrency**. C4 must add **authoritative win/draw/finish (and preferably server-side online match records)** without rewriting C1–C3 or D1–D4.

---

*End of read-only audit. No application or database changes were made except creation of this report file. Awaiting approval before any implementation.*
