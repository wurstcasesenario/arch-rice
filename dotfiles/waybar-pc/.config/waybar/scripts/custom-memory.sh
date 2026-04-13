#!/usr/bin/env bash

mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')      # kB
mem_free=$(grep MemAvailable /proc/meminfo | awk '{print $2}')  # kB
mem_used=$((mem_total - mem_free))
mem_usage=$((100 * mem_used / mem_total))

mem_total_mb=$((mem_total / 1024))
mem_used_mb=$((mem_used / 1024))
mem_free_mb=$((mem_free / 1024))

TEXT="  $mem_usage%"
TOOLTIP="Total: $mem_total_mb" 
# --- CSS-Klasse je nach Auslastung ---
if (( mem_usage < 50 )); then
    CLASS="good"
elif (( mem_usage < 75 )); then
    CLASS="warning"
else
    CLASS="critical"
fi

# --- JSON-Ausgabe für Waybar ---
echo "{\"text\": \"$TEXT\", \"class\": \"$CLASS\", \"tooltip\": \"$TOOLTIP\"}"
