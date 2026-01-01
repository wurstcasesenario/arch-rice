#!/usr/bin/env bash
set -euo pipefail

THEME="$1"
THEME_DIR="$HOME/.config/themes/$THEME"
COLORS_FILE="schema.json"

if [ -z "$THEME" ]; then
  echo "Theme must be provided"
  exit 1
fi

mkdir -p "$OUT_DIR"

# Requires jq
if ! command -v jq >/dev/null; then
  echo "Error: jq is required"
  exit 1
fi

for schema in "$SCHEMA_DIR"/*.schema; do
  name=$(basename "$schema" .schema)
  output="$OUT_DIR/$name.conf"

  content=$(cat "$schema")

  # Replace all placeholders {{key}}
  while read -r key value; do
    content=$(echo "$content" | sed "s/{{${key}}}/${value}/g")
  done < <(jq -r 'to_entries[] | "\(.key) \(.value)"' "$COLORS_FILE")

  echo "$content" > "$output"
  echo "Generated: $output"
done
