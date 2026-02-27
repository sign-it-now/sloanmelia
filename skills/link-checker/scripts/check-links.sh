#!/bin/bash
# SloanMelia Link Checker
# Usage:
#   bash check-links.sh           → local file check only
#   bash check-links.sh --live    → local + live HTTP check on sloanmelia.com

SITE_DIR="${SITE_DIR:-$(cd "$(dirname "$0")/../../.." && pwd)}"
BASE_URL="https://sloanmelia.com"
LIVE=false

for arg in "$@"; do
  [[ "$arg" == "--live" ]] && LIVE=true
done

BROKEN=()
CHECKED=0

echo "🔗 SloanMelia Link Checker"
echo "Project: $SITE_DIR"
$LIVE && echo "Mode: local + live (${BASE_URL})" || echo "Mode: local files only"
echo "---"

# ── Local file check ──────────────────────────────────────────────────────────
for html_file in "$SITE_DIR"/*.html; do
  filename=$(basename "$html_file")

  while IFS= read -r href; do
    # Skip empty, anchors, mailto, javascript, external URLs, root /, and JS template literals
    [[ -z "$href" ]] && continue
    [[ "$href" == "#"* ]] && continue
    [[ "$href" == "mailto:"* ]] && continue
    [[ "$href" == "javascript:"* ]] && continue
    [[ "$href" == http* ]] && continue
    [[ "$href" == "/" ]] && continue
    [[ "$href" == *'${'* ]] && continue

    # Strip in-page anchor (e.g. dashboard.html#colleges → dashboard.html)
    local_path="${href%%#*}"
    [[ -z "$local_path" ]] && continue

    if [[ ! -f "$SITE_DIR/$local_path" ]]; then
      BROKEN+=("MISSING FILE  → $local_path  (in $filename)")
    fi
    ((CHECKED++))
  done < <(grep -oP 'href=["'"'"']\K[^"'"'"']+' "$html_file" | sort -u)
done

echo "Local links checked: $CHECKED"

# ── Live HTTP check ───────────────────────────────────────────────────────────
if $LIVE; then
  echo ""
  echo "Checking live site..."
  LIVE_CHECKED=0

  # Collect all unique local HTML files referenced across the project
  all_pages=()
  while IFS= read -r href; do
    [[ -z "$href" || "$href" == "#"* || "$href" == "mailto:"* || "$href" == "javascript:"* || "$href" == http* ]] && continue
    page="${href%%#*}"
    [[ -z "$page" ]] && continue
    all_pages+=("$page")
  done < <(grep -rhoP 'href=["'"'"']\K[^"'"'"']+' "$SITE_DIR"/*.html | sort -u)

  # Deduplicate
  mapfile -t unique_pages < <(printf '%s\n' "${all_pages[@]}" | sort -u)

  for page in "${unique_pages[@]}"; do
    url="${BASE_URL}/${page}"
    status=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$url")
    if [[ "$status" != "200" && "$status" != "301" && "$status" != "302" ]]; then
      BROKEN+=("HTTP ${status}  → ${url}")
    fi
    ((LIVE_CHECKED++))
  done

  echo "Live URLs checked: $LIVE_CHECKED"
fi

# ── Report ────────────────────────────────────────────────────────────────────
echo ""
if [[ ${#BROKEN[@]} -eq 0 ]]; then
  echo "✅ All links are working!"
else
  echo "❌ Found ${#BROKEN[@]} broken link(s):"
  for b in "${BROKEN[@]}"; do
    echo "   $b"
  done
  exit 1
fi
