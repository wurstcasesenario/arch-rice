#!/usr/bin/env bash

BAT_PATH="/sys/class/power_supply/BAT0"
CAPACITY=$(cat "$BAT_PATH/capacity")
STATUS=$(cat "$BAT_PATH/status")

# === DISPLAY CONFIG ===
ICONS=("󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹")
CHECKPOINTS=(100 40 30 20 2)
COLORS=("good" "warning" "critical" "critical" "critical")

# === NOFITICATION CONFIG ===
NOTIFY_POINTS=(30 20 10 5)
NOTIFY_LEVELS=("normal" "normal" "critical" "critical")
NOTIFY_TITLES=("Battery low" "Battery low" "Battery critical" "Battery critical")

LOCK_DIR="/tmp/battery_notify"
mkdir -p "$LOCK_DIR"

# === ICON ===
NUM_ICONS=${#ICONS[@]}
ICON_INDEX=$(( (CAPACITY * (NUM_ICONS - 1)) / 100 ))
ICON=${ICONS[$ICON_INDEX]}

# === PICK COLOR FOR WAYBAR ===
COLOR="good"
for i in "${!CHECKPOINTS[@]}"; do
    if (( CAPACITY <= CHECKPOINTS[i] )); then
        COLOR=${COLORS[i]}
    fi
done

# === NOTIFICATIONS ===
if [[ "$STATUS" == "Discharging" ]]; then
    for i in "${!NOTIFY_POINTS[@]}"; do
        POINT=${NOTIFY_POINTS[i]}
        LEVEL=${NOTIFY_LEVELS[i]}
        TITLE=${NOTIFY_TITLES[i]}
        LOCK="$LOCK_DIR/$POINT.lock"

        if (( CAPACITY <= POINT )) && [[ ! -f "$LOCK" ]]; then
            notify-send -u "$LEVEL" -i battery-low "$TITLE" "Battery at $CAPACITY%"
            touch "$LOCK"
        fi
    done
fi

# === RESET NOTIFICATIONS WHEN CHARGING ===
if [[ "$STATUS" == "Charging" || "$STATUS" == "Full" ]]; then
    rm -f "$LOCK_DIR"/*.lock 2>/dev/null
    ICON=""
fi

TOOLTIP="$STATUS"

# === OUTPUT FOR WAYBAR ===
echo "{\"text\": \"$ICON $CAPACITY%\", \"class\": \"$COLOR\", \"tooltip\": \"$TOOLTIP\"}"
