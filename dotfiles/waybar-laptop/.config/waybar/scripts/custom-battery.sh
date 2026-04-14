#!/usr/bin/env bash

ICONS=("" "" "" "" "")
NOTIFY_POINTS=(30 20 10 5)
NOTIFY_LEVELS=("normal" "normal" "critical" "critical")
NOTIFY_TITLES=("Battery low" "Battery low" "Battery critical" "Battery critical")
LOCK_DIR="/tmp/battery_notify"

escape_json() {
    local s=$1
    s=${s//\\/\\\\}
    s=${s//\"/\\\"}
    s=${s//$'\n'/\\n}
    s=${s//$'\r'/}
    printf '%s' "$s"
}

emit_output() {
    local text=$1
    local class=$2
    local tooltip=$3
    printf '{"text":"%s","class":"%s","tooltip":"%s"}\n' \
        "$(escape_json "$text")" \
        "$(escape_json "$class")" \
        "$(escape_json "$tooltip")"
}

find_battery_path() {
    local path="/sys/class/power_supply/BAT0"

    if [[ -d "$path" ]]; then
        printf '%s\n' "$path"
        return
    fi

    for candidate in /sys/class/power_supply/BAT*; do
        if [[ -d "$candidate" ]]; then
            printf '%s\n' "$candidate"
            return
        fi
    done
}

require_powerprofilesctl() {
    command -v powerprofilesctl >/dev/null 2>&1
}

get_power_profile_raw() {
    if ! require_powerprofilesctl; then
        printf 'unknown\n'
        return
    fi

    local raw
    raw=$(powerprofilesctl get 2>/dev/null) || raw="unknown"
    printf '%s\n' "$raw"
}

get_profile_display() {
    local raw=$1
    case "$raw" in
        power-saver) printf '󰌪|Power Saver\n' ;;
        balanced) printf '󰾆|Balanced\n' ;;
        performance) printf '󰓅|Performance\n' ;;
        *) printf '?|Unknown\n' ;;
    esac
}

get_battery_icon() {
    local capacity=$1
    local num_icons=${#ICONS[@]}
    local icon_index=$(( (capacity * (num_icons - 1)) / 100 ))

    if (( icon_index < 0 )); then
        icon_index=0
    elif (( icon_index >= num_icons )); then
        icon_index=$((num_icons - 1))
    fi

    printf '%s\n' "${ICONS[$icon_index]}"
}

get_color_class() {
    local capacity=$1
    if (( capacity <= 15 )); then
        printf 'critical\n'
    elif (( capacity <= 30 )); then
        printf 'warning\n'
    else
        printf 'good\n'
    fi
}

notify_low_battery() {
    local capacity=$1
    local status=$2

    mkdir -p "$LOCK_DIR"

    if [[ "$status" != "Discharging" ]]; then
        rm -f "$LOCK_DIR"/*.lock 2>/dev/null
        return
    fi

    local i point level title lock
    for i in "${!NOTIFY_POINTS[@]}"; do
        point=${NOTIFY_POINTS[i]}
        level=${NOTIFY_LEVELS[i]}
        title=${NOTIFY_TITLES[i]}
        lock="$LOCK_DIR/$point.lock"

        if (( capacity <= point )) && [[ ! -f "$lock" ]]; then
            notify-send -u "$level" -i battery-low "$title" "Battery at $capacity%"
            touch "$lock"
        fi
    done
}

main() {
    local bat_path capacity status
    bat_path=$(find_battery_path)
    if [[ -z "$bat_path" ]]; then
        emit_output "N/A" "warning" "Battery not found"
        return 0
    fi

    capacity=$(<"$bat_path/capacity")
    status=$(<"$bat_path/status")

    local profile_raw profile_data profile_icon profile_text
    profile_raw=$(get_power_profile_raw)
    profile_data=$(get_profile_display "$profile_raw")
    profile_icon=${profile_data%%|*}
    profile_text=${profile_data#*|}

    local icon color
    icon=$(get_battery_icon "$capacity")
    color=$(get_color_class "$capacity")

    notify_low_battery "$capacity" "$status"

    if [[ "$status" == "Charging" || "$status" == "Full" ]]; then
        icon=""
    fi

    local tooltip text
    tooltip="$status | $profile_text"
    text="$icon $capacity% $profile_icon"
    emit_output "$text" "$color" "$tooltip"
}

main "$@"
