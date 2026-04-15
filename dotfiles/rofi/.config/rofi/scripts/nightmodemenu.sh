#!/usr/bin/env bash
set -euo pipefail

NIGHTMODE_SCRIPT="$HOME/.config/scripts/nightmode.sh"

# Check if script exists
if [[ ! -f "$NIGHTMODE_SCRIPT" ]]; then
	echo "Night mode script not found at $NIGHTMODE_SCRIPT"
	notify-send -u critical "Night Mode" "Script not found"
	exit 1
fi

# Run check
if ! OUTPUT="$("$NIGHTMODE_SCRIPT" check 2>&1)"; then
	echo -e "$OUTPUT"
	notify-send -u critical "Night Mode" "$OUTPUT"
	exit 1
fi

# Toggle
STATE="$("$NIGHTMODE_SCRIPT" toggle)"

# Notify
if [[ "$STATE" == "true" ]]; then
	notify-send -u low "Night Mode" "Enabled"
else
	notify-send -u low "Night Mode" "Disabled"
fi