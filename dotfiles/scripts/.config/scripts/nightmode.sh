#!/usr/bin/env bash
set -euo pipefail

STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/nightmode.state"
LOCK_FILE="${XDG_RUNTIME_DIR:-/tmp}/nightmode.lock"

TEMPERATURE=5000

require_hyprctl() {
	if ! command -v hyprctl >/dev/null 2>&1; then
		echo "Error: hyprctl is not installed." >&2
		exit 1
	fi
}

lock() {
	exec 9>"$LOCK_FILE"
	flock -n 9 || exit 1
}

is_enabled() {
	[[ -f "$STATE_FILE" ]] && [[ "$(cat "$STATE_FILE")" == "true" ]]
}

set_state() {
	echo "$1" > "$STATE_FILE"
}

enable() {
	hyprctl hyprsunset temperature $TEMPERATURE >/dev/null
	set_state "true"
}

disable() {
	hyprctl hyprsunset identity >/dev/null
	set_state "false"
}

status() {
	is_enabled && echo "true" || echo "false"
}

toggle() {
	if is_enabled; then
		disable
		echo "false"
	else
		enable
		echo "true"
	fi
}

check() {
	local errors=0
	local msg=""

	if ! command -v hyprctl >/dev/null 2>&1; then
		msg+="hyprctl is not installed\n"
		((errors++))
	fi
	
	if [[ $errors -eq 0 ]]; then
		echo "ok"
		return 0
	else
		echo -e "$msg"
		return 1
	fi
}

usage() {
	cat <<'EOF'
Usage:
  nightmode.sh enable
  nightmode.sh disable
  nightmode.sh toggle
  nightmode.sh status
  nightmode.sh check
EOF
}

main() {
	require_hyprctl
	lock

	case "${1:-}" in
		enable)
			enable
			echo "true"
			;;
		disable)
			disable
			echo "false"
			;;
		toggle)
			toggle
			;;
		status)
			status
			;;
		check)
		    check
			;;
		-h|--help|"")
			usage
			;;
		*)
			echo "Unknown command: $1" >&2
			usage >&2
			exit 1
			;;
	esac
}

main "$@"
