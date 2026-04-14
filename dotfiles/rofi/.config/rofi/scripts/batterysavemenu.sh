#!/usr/bin/env bash

set -euo pipefail

require_powerprofilesctl() {
	if ! command -v powerprofilesctl >/dev/null 2>&1; then
		echo "Error: powerprofilesctl is not installed." >&2
		exit 1
	fi
}

notify() {
	local title="$1"
	local body="$2"
	if command -v notify-send >/dev/null 2>&1; then
		notify-send "$title" "$body"
	fi
}

current_profile() {
	powerprofilesctl get
}

available_profiles() {
	powerprofilesctl list | sed -nE 's/^[[:space:]]*\*?[[:space:]]*([a-z-]+):.*/\1/p'
}

profile_available() {
	local wanted="$1"
	available_profiles | grep -qx "$wanted"
}

set_profile() {
	local profile="$1"
	if ! profile_available "$profile"; then
		echo "Error: profile '$profile' is not available on this system." >&2
		exit 1
	fi
	powerprofilesctl set "$profile"
}

run_action() {
	local action="$1"
	local mode="$2"
	local current
	local message=""

	case "$action" in
		saver | power-saver)
			set_profile "power-saver"
			message="Power profile set to power-saver."
			;;
		balanced)
			set_profile "balanced"
			message="Power profile set to balanced."
			;;
		performance)
			set_profile "performance"
			message="Power profile set to performance."
			;;
		toggle)
			current="$(current_profile)"
			if [[ "$current" == "power-saver" ]]; then
				set_profile "balanced"
				message="Power profile set to balanced."
			else
				set_profile "power-saver"
				message="Power profile set to power-saver."
			fi
			;;
		*)
			echo "Error: unknown action '$action'." >&2
			usage >&2
			exit 1
			;;
	esac

	if [[ "$mode" == "cli" ]]; then
		printf "%s\n" "$message"
	else
		notify "Battery Saver" "$message"
	fi
}

label_for_profile() {
	local profile="$1"
	local current="$2"
	local suffix=""
	if [[ "$profile" == "$current" ]]; then
		suffix=" (current)"
	fi

	case "$profile" in
		power-saver) printf "󰌪  Power Saver%s" "$suffix" ;;
		balanced) printf "󰾆  Balanced%s" "$suffix" ;;
		performance) printf "󰓅  Performance%s" "$suffix" ;;
		*) printf "%s%s" "$profile" "$suffix" ;;
	esac
}

show_rofi_menu() {
	local current profiles options choice
	current="$(current_profile)"
	mapfile -t profiles < <(available_profiles)

	options=()
	for p in "${profiles[@]}"; do
		case "$p" in
			power-saver | balanced | performance)
				options+=("$(label_for_profile "$p" "$current")")
				;;
		esac
	done
	options+=("󰤄  Toggle Saver/Balanced")
	options+=("󰜺  Cancel")

	choice=$(printf '%s\n' "${options[@]}" | rofi -dmenu -i -p "Battery Mode")
	[[ -z "$choice" ]] && exit 0

	case "$choice" in
		"󰌪  Power Saver" | "󰌪  Power Saver (current)") run_action power-saver rofi ;;
		"󰾆  Balanced" | "󰾆  Balanced (current)") run_action balanced rofi ;;
		"󰓅  Performance" | "󰓅  Performance (current)") run_action performance rofi ;;
		"󰤄  Toggle Saver/Balanced") run_action toggle rofi ;;
		*) exit 0 ;;
	esac
}

main() {
	require_powerprofilesctl
	show_rofi_menu
}

main "$@"
