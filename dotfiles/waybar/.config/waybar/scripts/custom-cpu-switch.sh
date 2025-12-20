#!/usr/bin/env bash

STATE_FILE="/tmp/waybar-cpu-mode"

if [ ! -f "$STATE_FILE" ]; then
    echo "usage" > "$STATE_FILE"
fi

MODE=$(cat "$STATE_FILE")

# Umschalten
if [ "$MODE" == "usage" ]; then
    echo "temp" > "$STATE_FILE"
else
    echo "usage" > "$STATE_FILE"
fi
