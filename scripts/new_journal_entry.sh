#!/usr/bin/env bash
# Create a new journal entry in content/journal/, in both English and
# Portuguese (the pt-br file is a translation stub you fill in by hand).
#
# The entry's slug (and filename) is today's date, so the URL is
# /journal/YYYY-MM-DD/. If an entry for today already exists, a numeric
# suffix (-2, -3, ...) is appended so you can log more than one per day.
#
# Usage:
#   scripts/new_journal_entry.sh ["Title"]
#
#   "Title"   Optional entry title. Defaults to today's date.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
JOURNAL_DIR="$REPO_ROOT/content/journal"

title=""

for arg in "$@"; do
  case "$arg" in
    -h|--help)
      sed -n '2,12p' "$0"
      exit 0
      ;;
    *)
      if [[ -z "$title" ]]; then
        title="$arg"
      else
        echo "Unexpected argument: $arg" >&2
        exit 1
      fi
      ;;
  esac
done

date_str="$(date +%F)"
[[ -z "$title" ]] && title="$date_str"

mkdir -p "$JOURNAL_DIR"

slug="$date_str"
suffix=2
while [[ -f "$JOURNAL_DIR/$slug.md" ]]; do
  slug="${date_str}-${suffix}"
  suffix=$((suffix + 1))
done

entry_file="$JOURNAL_DIR/$slug.md"
pt_file="$JOURNAL_DIR/$slug.pt-br.md"

cat > "$entry_file" <<EOF
+++
title = "$title"
date = $date_str
+++

Write today's entry here.
EOF

cat > "$pt_file" <<EOF
+++
title = "$title"
date = $date_str
+++

TODO: traduzir esta entrada.
EOF

echo "Created $entry_file"
echo "Created $pt_file"
