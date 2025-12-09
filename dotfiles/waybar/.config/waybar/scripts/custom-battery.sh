#!/usr/bin/env bash

BAT_PATH="/sys/class/power_supply/BAT0"
CAPACITY=$(cat "$BAT_PATH/capacity")
STATUS=$(cat "$BAT_PATH/status")

ICONS=("󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹")
CHECKPOINTS=(100 40 30 20 10)
COLORS=("good" "warning" "critical" "critical" "critical")
LOW_CMD="notify-send -u critical 'Battery critically low' $CAPACITY%"

NUM_ICONS=${#ICONS[@]}
ICON_INDEX=$(( (CAPACITY * (NUM_ICONS - 1)) / 100 ))
ICON=${ICONS[$ICON_INDEX]}

# === PICK COLOR BASED ON CHECKPOINTS ===
COLOR="good"
for i in "${!CHECKPOINTS[@]}"; do
    if (( CAPACITY <= CHECKPOINTS[i] )); then
        COLOR=${COLORS[i]}
    fi
done

# === SEND NOTIFICATION IF LOW ===
if [ "$COLOR" == "critical" ] && [ "$STATUS" == "Discharging" ]; then
    $LOW_CMD &
fi

# === ADD CHARGING ICON ===
if [ "$STATUS" == "Charging" ] || [ "$STATUS" == "Full" ]; then
    ICON=""
fi


TOOLTIP="$STATUS"

# === OUTPUT FOR WAYBAR ===
echo "{\"text\": \"$ICON $CAPACITY%\", \"class\": \"$CLASS\", \"tooltip\": \"$TOOLTIP\"}"
