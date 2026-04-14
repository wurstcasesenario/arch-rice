#!/usr/bin/env bash

set -euo pipefail

usage() {
	cat <<'EOF'
Usage:
  nightmodemenu.sh               # Open rofi menu
  nightmodemenu.sh --cli ACTION  # Run without rofi

Actions:
  enable             Set color temperature to 4000K
  disable            Disable filter (identity)
EOF
}

require_hyprsunset() {
	if ! command -v hyprctl >/dev/null 2>&1; then
		echo "Error: hyprctl is not installed." >&2
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

run_action() {
	local action="$1"
	local mode="$2"
	local output=""
	local message=""

	case "$action" in
		enable)
			hyprctl hyprsunset temperature 4000 >/dev/null
			message="Blue-light filter enabled at 4000K."
			;;
		disable)
			hyprctl hyprsunset identity >/dev/null
			message="Blue-light filter disabled."
			;;
		*)
			echo "Error: unknown action '$action'." >&2
			usage >&2
			exit 1
			;;
	esac

	if [[ "$action" == "profile" ]]; then
		if [[ "$mode" == "cli" ]]; then
			printf "%s\n" "$output"
		else
			notify "Night Mode Profile" "${output:-No profile output}"
		fi
		return
	fi

	if [[ "$mode" == "cli" ]]; then
		printf "%s\n" "$message"
	else
		notify "Night Mode" "$message"
	fi
}

show_rofi_menu() {
	local choice
	choice=$(
		printf '%s\n' \
			"󰖔  Enable Night Mode (4000K)" \
			"󰖨  Disable Night Mode" \
			| rofi -dmenu -i -p "Night Mode"
	)

	[[ -z "$choice" ]] && exit 0

	case "$choice" in
		"󰖔  Enable Night Mode (4000K)") run_action enable rofi ;;
		"󰖨  Disable Night Mode") run_action disable rofi ;;
		*) exit 0 ;;
	esac
}

main() {
	if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
		usage
		exit 0
	fi

	require_hyprsunset

	if [[ "${1:-}" == "--cli" ]]; then
		shift
		if [[ $# -lt 1 ]]; then
			echo "Error: --cli requires an ACTION." >&2
			usage >&2
			exit 1
		fi
		run_action "$1" cli
		exit 0
	fi

	show_rofi_menu
}

main "$@"
