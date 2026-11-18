#!/usr/bin/env bash
# Builds supabase/app-updates/update.json for a release APK.
#
#   tool/make_update_json.sh <apk> ["note 1" "note 2" ...]
#
# Reads version name/code from pubspec.yaml, computes the APK's SHA-256 and
# size, and names the upload drotix-<name>-<code>.apk. Then upload BOTH files
# to the Supabase Storage bucket "app-updates" (APK first, then update.json).
# Set MIN_CODE=<n> to force everyone below build <n> to update.
set -euo pipefail
cd "$(dirname "$0")/.."

apk="${1:?usage: tool/make_update_json.sh <apk> [notes...]}"
shift || true
[ -f "$apk" ] || { echo "APK not found: $apk" >&2; exit 1; }

ver=$(grep -E '^version:' pubspec.yaml | awk '{print $2}')
name="${ver%%+*}"
code="${ver##*+}"
min="${MIN_CODE:-1}"
sha=$(sha256sum "$apk" | awk '{print $1}')
size=$(stat -c%s "$apk")
base_url=$(grep -oE 'https://[a-z0-9]+\.supabase\.co' lib/config/supabase_config.dart | head -1)
file="drotix-${name}-${code}.apk"
ios_url="${IOS_APP_STORE_URL:-}"

notes_json=$(python3 -c 'import json,sys; print(json.dumps(sys.argv[1:]))' "$@")

mkdir -p supabase/app-updates
cp "$apk" "supabase/app-updates/$file"
python3 - "$name" "$code" "$min" "$base_url/storage/v1/object/public/app-updates/$file" \
  "$sha" "$size" "$notes_json" "$ios_url" > supabase/app-updates/update.json <<'PY'
import json, sys, datetime
name, code, mn, url, sha, size, notes, ios = sys.argv[1:9]
print(json.dumps({
  "update_available": True,
  "latest_version_name": name,
  "latest_version_code": int(code),
  "min_supported_version_code": int(mn),
  "apk_url": url,
  "apk_sha256": sha,
  "apk_size_bytes": int(size),
  "release_notes": json.loads(notes),
  "ios_app_store_url": ios,
  "published_at": datetime.date.today().isoformat(),
}, indent=2))
PY

echo "Wrote supabase/app-updates/update.json"
echo "Upload to Storage bucket 'app-updates':"
echo "  1. supabase/app-updates/$file"
echo "  2. supabase/app-updates/update.json  (overwrite)"
