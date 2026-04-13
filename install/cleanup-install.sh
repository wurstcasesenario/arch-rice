#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat <<'USAGE'
Usage: ./install/cleanup-install.sh [--profile laptop|pc]

Options:
  -p, --profile   Hardware profile to prepare for (default: ARCH_RICE_PROFILE or laptop)
      --laptop    Shortcut for --profile laptop
      --pc        Shortcut for --profile pc
  -h, --help      Show this help message
USAGE
}

PROFILE="${ARCH_RICE_PROFILE:-laptop}"

while [[ $# -gt 0 ]]; do
    case "$1" in
        -p|--profile)
            if [[ $# -lt 2 ]]; then
                echo "Missing value for $1"
                usage
                exit 1
            fi
            PROFILE="$2"
            shift 2
            ;;
        --laptop)
            PROFILE="laptop"
            shift
            ;;
        --pc)
            PROFILE="pc"
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

case "$PROFILE" in
    laptop|pc) ;;
    *)
        echo "Unsupported profile: $PROFILE"
        echo "Supported profiles: laptop, pc"
        exit 1
        ;;
esac

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALL_PATH="$ROOT_DIR/install"
DOTFILES_DIR="$ROOT_DIR/dotfiles"

resolve_symlink_target() {
    local symlink_path="$1"
    local raw_target

    raw_target="$(readlink "$symlink_path" 2>/dev/null || true)"
    if [[ -z "$raw_target" ]]; then
        return 1
    fi

    if [[ "$raw_target" == /* ]]; then
        printf '%s\n' "$raw_target"
    else
        readlink -m "$(dirname "$symlink_path")/$raw_target"
    fi
}

remove_if_matches_legacy_target() {
    local target_path="$1"
    local resolved_target

    if [[ ! -L "$target_path" ]]; then
        return 0
    fi

    resolved_target="$(resolve_symlink_target "$target_path" || true)"
    if [[ -z "$resolved_target" ]]; then
        return 0
    fi

    case "$resolved_target" in
        "$ROOT_DIR"/dotfiles/zsh/*|\
        "$ROOT_DIR"/dotfiles/waybar/*|\
        "$ROOT_DIR"/dotfiles/systemthemes/*|\
        "$ROOT_DIR"/dotfiles/webapps/.local/share/applications/webapp-*.desktop)
            rm -rf -- "$target_path"
            echo "Removed legacy link: $target_path"
            ;;
    esac
}

cleanup_legacy_stow_artifacts() {
    echo "=== Cleanup: removing legacy dotfile artifacts ==="

    local -a scan_roots=(
        "$HOME/.config"
        "$HOME/.local/share/applications"
        "$HOME/.local/share/icons"
        "$HOME/.themes"
    )

    local scan_root
    local symlink_path
    local resolved_target
    for scan_root in "${scan_roots[@]}"; do
        [[ -d "$scan_root" ]] || continue
        while IFS= read -r -d '' symlink_path; do
            resolved_target="$(resolve_symlink_target "$symlink_path" || true)"
            if [[ -n "$resolved_target" && "$resolved_target" == "$ROOT_DIR"/dotfiles/* && ! -e "$resolved_target" ]]; then
                rm -f -- "$symlink_path"
                echo "Removed broken legacy link: $symlink_path"
            fi
        done < <(find "$scan_root" -type l -print0 2>/dev/null)
    done

    local -a known_legacy_paths=(
        "$HOME/.zshrc"
        "$HOME/.config/waybar"
    )

    local legacy_path
    for legacy_path in "${known_legacy_paths[@]}"; do
        remove_if_matches_legacy_target "$legacy_path"
    done

    local desktop_file
    for desktop_file in "$HOME"/.local/share/applications/webapp-*.desktop; do
        [[ -e "$desktop_file" ]] || continue
        remove_if_matches_legacy_target "$desktop_file"
    done
}

remove_packages_if_installed() {
    local title="$1"
    shift

    local -a requested=("$@")
    local -a installed=()
    local pkg

    for pkg in "${requested[@]}"; do
        if pacman -Q "$pkg" >/dev/null 2>&1; then
            installed+=("$pkg")
        fi
    done

    if [[ "${#installed[@]}" -eq 0 ]]; then
        echo "No installed packages to remove for $title."
        return 0
    fi

    echo "Removing packages for $title: ${installed[*]}"
    if ! sudo pacman -Rns --noconfirm "${installed[@]}"; then
        echo "Warning: Failed to remove one or more packages for $title. Continuing."
    fi
}

cleanup_other_profile_packages() {
    echo "=== Cleanup: removing opposite-profile driver packages ==="

    case "$PROFILE" in
        laptop)
            remove_packages_if_installed "PC profile" \
                nvidia nvidia-utils lib32-nvidia-utils nvidia-settings egl-wayland
            ;;
        pc)
            remove_packages_if_installed "Laptop profile" \
                vulkan-intel lib32-vulkan-intel
            ;;
    esac
}

unstow_all_dotfiles() {
    echo "=== Cleanup: unstowing all managed dotfile packages ==="

    if ! command -v stow >/dev/null 2>&1; then
        echo "GNU Stow not found. Installing it before cleanup."
        "$INSTALL_PATH/install-stow.sh"
    fi

    local -a stow_packages
    mapfile -t stow_packages < <(find "$DOTFILES_DIR" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort)

    cd "$DOTFILES_DIR"

    local pkg
    for pkg in "${stow_packages[@]}"; do
        echo "Unstowing package: $pkg"
        stow -D -t "$HOME" -v "$pkg" || true
    done

    cd "$ROOT_DIR"
}

echo "=== Running cleanup (target profile: $PROFILE) ==="
unstow_all_dotfiles
cleanup_legacy_stow_artifacts
cleanup_other_profile_packages
echo "=== Cleanup finished (target profile: $PROFILE) ==="

