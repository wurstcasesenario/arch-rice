#!/usr/bin/env bash
set -euo pipefail

THEME="${1:-}"

if [[ -z "$THEME" ]]; then
  echo "Usage: $0 <theme>"
  exit 1
fi

THEME_DIR="$HOME/.config/themes/$THEME"
SCHEMA_DIR="schemas"
OUT_DIR="$THEME_DIR/out"
COLORS_FILE="$THEME_DIR/schema.json"

# Sanity checks
[[ -d "$SCHEMA_DIR" ]] || { echo "Missing schemas directory"; exit 1; }
[[ -f "$COLORS_FILE" ]] || { echo "Missing schema.json"; exit 1; }

mkdir -p "$OUT_DIR"

# Requires jq
if ! command -v jq >/dev/null; then
  echo "Error: jq is required"
  exit 1
fi

for schema in "$SCHEMA_DIR"/*.schema; do
  name="$(basename "$schema" .schema)"
  output="$OUT_DIR/$name.conf"

  content="$(cat "$schema")"

  # Replace all placeholders {{key}}
  while read -r key value; do
    content="$(sed "s/{{${key}}}/${value}/g" <<< "$content")"
  done < <(jq -r 'to_entries[] | "\(.key) \(.value)"' "$COLORS_FILE")

  printf "%s\n" "$content" > "$output"
  echo "Generated: $output"
done
