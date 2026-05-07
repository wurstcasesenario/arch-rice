#!/usr/bin/env bash

set -euo pipefail

LOG_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/clipboard-daemon.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

error() {
    log "ERROR: $*"
}

cleanup() {
    log "Stopping clipboard watchers..."
    kill 0 2>/dev/null || true
}

start_watchers() {
    log "Starting wl-paste watchers..."

    # Text clipboard
    wl-paste --type text --watch cliphist store \
        || error "Text clipboard watcher crashed" &

    # Image clipboard
    wl-paste --type image --watch cliphist store \
        || error "Image clipboard watcher crashed" &
}

clear_clipboard_history() {
    log "Clearing cliphist history..."
    cliphist wipe || error "Failed to wipe cliphist history"
}

open_rofi_menu() {
    local menu="${HOME}/.config/rofi/scripts/cliphistmenu.sh"

    if [[ -x "$menu" ]]; then
        log "Opening rofi clipboard menu..."
        "$menu" || error "Rofi menu failed"
    else
        error "Rofi script not found or not executable: $menu"
    fi
}

main() {
    case "${1:-start}" in
        start)
            start_watchers
            wait
            ;;
        clear)
            clear_clipboard_history
            ;;
        menu)
            open_rofi_menu
            ;;
        *)
            echo "Usage: $0 {start|clear|menu}"
            exit 1
            ;;
    esac
}

main "$@"
