#!/usr/bin/env bash

# Show clipboard history in rofi with 2 columns
selected=$(cliphist list | rofi -dmenu -display-columns 2)

# If something was selected, decode and copy to clipboard
if [[ -n "$selected" ]]; then
    cliphist decode "$selected" | wl-copy
fi
