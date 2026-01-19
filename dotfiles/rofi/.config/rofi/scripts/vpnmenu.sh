#!/usr/bin/env bash

# ===== ICONS (Nerd Font) =====
ICON_ON=""
ICON_CONNECT="󰖂"
ICON_EXIT="󰗼"
ICON_LOAD="󰱼"

SCRIPT_PATH="$(realpath "$0")"

# ===== FUNCTIONS =====
get_wireguard() {
  nmcli -t -f NAME,TYPE connection show "$@" |
  while IFS= read -r line; do
    type="${line##*:}"
    name="${line%:*}"
    [ "$type" = "wireguard" ] && echo "$name"
  done
}

# ===== STATE =====
ACTIVE_VPN=$(get_wireguard --active)
VPN_LIST=$(get_wireguard)

if [ -z "$VPN_LIST" ]; then
  VPN_LIST=""
fi

# ===== UI =====
if [ -n "$ACTIVE_VPN" ]; then
  CHOICE=$(printf "%s  Disconnect (%s)\n" "$ICON_ON" "$ACTIVE_VPN" \
    | rofi -dmenu -p "VPN Connected")
else
  CHOICE=$(printf "%s  Connect\n%s  Load config\n%s  Exit\n" \
    "$ICON_CONNECT" "$ICON_LOAD" "$ICON_EXIT" \
    | rofi -dmenu -p "VPN Disconnected")
fi

case "$CHOICE" in
  *Disconnect*)
    nmcli connection down "$ACTIVE_VPN" >/dev/null 2>&1
    ;;

  *Connect*)
    VPN=$(printf "%s\n" "$VPN_LIST" | rofi -dmenu -p "Select VPN")
    [ -z "$VPN" ] && exit 0
    nmcli connection up "$VPN" >/dev/null 2>&1
    ;;

  *Load*)
    CONFIG_PATH=$(rofi -dmenu -p "Path to WireGuard config")

    [ -z "$CONFIG_PATH" ] && exit 0
    [ ! -f "$CONFIG_PATH" ] && rofi -e "File not found" && exit 1

    VPN_NAME="$(basename "$CONFIG_PATH" .conf)"

    nmcli connection import type wireguard file "$CONFIG_PATH"

    # # Import if it doesn't exist
    # if ! nmcli connection show "$VPN_NAME" >/dev/null 2>&1; then
    #   nmcli connection import type wireguard file "$CONFIG_PATH" >/dev/null 2>&1 \
    #     || { rofi -e "Import failed"; exit 1; }
    # fi

    nmcli connection up "$VPN_NAME" >/dev/null 2>&1
    exec "$SCRIPT_PATH"
    ;;

  *)
    exit 0
    ;;
esac
