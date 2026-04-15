#!/usr/bin/env bash
set -euo pipefail

# Check if command exists in PATH
if ! command -v nightmode >/dev/null 2>&1; then
	echo "nightmode not found in PATH"
	notify-send -u critical "Night Mode" "nightmode not found in PATH"
	exit 1
fi

# Run check
if ! OUTPUT="$(nightmode check 2>&1)"; then
	echo "$OUTPUT"
	notify-send -u critical "Night Mode" "$OUTPUT"
	exit 1
fi

# Toggle
STATE="$(nightmode toggle)"

# Notify
if [[ "$STATE" == "true" ]]; then
	notify-send -u low "Night Mode" "Enabled"
else
	notify-send -u low "Night Mode" "Disabled"
fi