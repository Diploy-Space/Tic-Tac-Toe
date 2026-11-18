// Sends an FCM push for every new row in public.notifications.
//
// Trigger: Supabase Dashboard → Database → Webhooks → Create:
//   table public.notifications, event INSERT, type "Supabase Edge Functions",
//   function send-push, HTTP header  x-webhook-secret: <WEBHOOK_SECRET>
//
// Deploy:
//   supabase functions deploy send-push --no-verify-jwt
//   supabase secrets set FIREBASE_SERVICE_ACCOUNT="$(cat service-account.json)"
//   supabase secrets set WEBHOOK_SECRET="<long random string>"
//
// Texts come from templates.json (generated from the app's ARB files by
// tool/gen_push_templates.py), in the language the device registered with.
import { createClient } from "jsr:@supabase/supabase-js@2";
import { importPKCS8, SignJWT } from "npm:jose@5";
import templates from "./templates.json" with { type: "json" };

const sa = JSON.parse(Deno.env.get("FIREBASE_SERVICE_ACCOUNT")!);
const sb = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);

type Tpl = Record<string, Record<string, [string, string]>>;
const TPL = templates as unknown as Tpl;

let cachedToken: { value: string; exp: number } | null = null;

async function fcmAccessToken(): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  if (cachedToken && cachedToken.exp - 60 > now) return cachedToken.value;
  const key = await importPKCS8(sa.private_key, "RS256");
  const jwt = await new SignJWT({
    scope: "https://www.googleapis.com/auth/firebase.messaging",
  })
    .setProtectedHeader({ alg: "RS256", typ: "JWT" })
    .setIssuer(sa.client_email)
    .setSubject(sa.client_email)
    .setAudience("https://oauth2.googleapis.com/token")
    .setIssuedAt(now)
    .setExpirationTime(now + 3600)
    .sign(key);
  const res = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: jwt,
    }),
  });
  const json = await res.json();
  if (!json.access_token) throw new Error("FCM auth failed: " + JSON.stringify(json));
  cachedToken = { value: json.access_token, exp: now + 3600 };
  return json.access_token;
}

function fill(s: string, data: Record<string, unknown>): string {
  return s.replace(/\{(\w+)\}/g, (_, k) => (data[k] ?? "") + "");
}

function render(
  rec: { type: string; title: string; body: string; data: Record<string, unknown> },
  locale: string,
): [string, string] {
  const key = rec.type === "match_result" ? `match_result:${rec.data.result}` : rec.type;
  const lang = TPL[locale]?.[key] ? locale : "en";
  const t = TPL[lang]?.[key];
  if (!t) return [rec.title, rec.body];
  return [fill(t[0], rec.data), fill(t[1], rec.data)];
}

Deno.serve(async (req) => {
  if (req.headers.get("x-webhook-secret") !== Deno.env.get("WEBHOOK_SECRET")) {
    return new Response("unauthorized", { status: 401 });
  }
  const payload = await req.json(); // { type, table, record, old_record }
  const rec = payload.record;
  if (payload.type !== "INSERT" || !rec?.user_id) return Response.json({ skipped: true });
  if (rec.push === false) return Response.json({ skipped: "muted" });

  const { data: rows, error } = await sb
    .from("push_tokens")
    .select("token, locale")
    .eq("user_id", rec.user_id);
  if (error) return new Response(error.message, { status: 500 });
  if (!rows?.length) return Response.json({ sent: 0, reason: "no tokens" });

  const accessToken = await fcmAccessToken();
  const data: Record<string, string> = { type: String(rec.type), id: String(rec.id) };
  for (const [k, v] of Object.entries(rec.data ?? {})) {
    if (v !== null && v !== undefined) data[k] = String(v);
  }

  let sent = 0;
  for (const row of rows) {
    const [title, body] = render(rec, row.locale ?? "en");
    const res = await fetch(
      `https://fcm.googleapis.com/v1/projects/${sa.project_id}/messages:send`,
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${accessToken}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          message: {
            token: row.token,
            notification: { title, body },
            data,
            android: {
              priority: "HIGH",
              notification: { channel_id: "drotix_events", sound: "default", tag: String(rec.type) },
            },
            apns: { payload: { aps: { sound: "default" } } },
          },
        }),
      },
    );
    if (res.ok) {
      sent++;
    } else {
      const err = await res.text();
      // Uninstalled app / stale token → forget it.
      if (res.status === 404 || err.includes("UNREGISTERED")) {
        await sb.from("push_tokens").delete().eq("token", row.token);
      }
      console.error("FCM error", res.status, err);
    }
  }
  if (sent > 0) await sb.rpc("mark_push_sent", { p_id: rec.id });
  return Response.json({ sent });
});
