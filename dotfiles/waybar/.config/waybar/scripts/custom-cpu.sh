#!/usr/bin/env bash

STATE_FILE="/tmp/waybar-cpu-mode"

if [ ! -f "$STATE_FILE" ]; then
    echo "usage" > "$STATE_FILE"
fi
MODE=$(cat "$STATE_FILE")

read cpu user nice system idle iowait irq softirq steal guest < /proc/stat
total=$((user + nice + system + idle + iowait + irq + softirq + steal))
active=$((total - idle - iowait))
cpu_usage=$((100 * active / total))

if [ -f /sys/class/thermal/thermal_zone0/temp ]; then
    temp=$(($(cat /sys/class/thermal/thermal_zone0/temp)/1000))
else
    temp="N/A"
fi

if [ "$MODE" == "usage" ]; then
    TEXT=" $cpu_usage%"
    TOOLTIP=" Show Temp"
    # CSS-Klassen nach CPU-Auslastung
    if (( cpu_usage < 50 )); then
        CLASS="good"
    elif (( cpu_usage < 75 )); then
        CLASS="warning"
    else
        CLASS="critical"
    fi
else
    TOOLTIP=" Show Usage"
    if (( temp < 60 )); then
        CLASS="good"
        TEXT=" $temp°C"
    elif (( temp < 80 )); then
        CLASS="warning"
        TEXT=" $temp°C"
    else
        CLASS="critical"
        TEXT=" $temp°C"
    fi
fi

# === JSON-Ausgabe für Waybar ===
echo "{\"text\": \"$TEXT\", \"class\": \"$CLASS\", \"tooltip\": \"$TOOLTIP\"}"
