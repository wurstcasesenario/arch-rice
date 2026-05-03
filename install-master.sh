#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat <<'USAGE'
Usage: ./install-master.sh [--profile laptop|pc] [--mode standard|clean] [--no-update]

Options:
  -p, --profile   Hardware profile to install (default: laptop)
      --laptop    Shortcut for --profile laptop
      --pc        Shortcut for --profile pc
  -m, --mode      Install mode: standard or clean (default: standard)
      --clean-install Shortcut for --mode clean
      --no-update Skip pacman/flatpak system update step
  -h, --help      Show this help message
USAGE
}

PROFILE="${ARCH_RICE_PROFILE:-laptop}"
INSTALL_MODE="standard"
RUN_SYSTEM_UPDATE=1

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
        -m|--mode)
            if [[ $# -lt 2 ]]; then
                echo "Missing value for $1"
                usage
                exit 1
            fi
            INSTALL_MODE="$2"
            shift 2
            ;;
        --clean-install)
            INSTALL_MODE="clean"
            shift
            ;;
        --no-update)
            RUN_SYSTEM_UPDATE=0
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

case "$INSTALL_MODE" in
    standard|clean) ;;
    *)
        echo "Unsupported install mode: $INSTALL_MODE"
        echo "Supported modes: standard, clean"
        exit 1
        ;;
esac

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_PATH="$ROOT_DIR/install"

export ARCH_RICE_PROFILE="$PROFILE"
cd "$ROOT_DIR"

echo "=== Arch Rice Installer ==="
echo "Profile: $ARCH_RICE_PROFILE"
echo "Mode: $INSTALL_MODE"

if [[ "$RUN_SYSTEM_UPDATE" -eq 1 ]]; then
    echo "=== Updating System ==="
    sudo pacman -Syu --noconfirm

    if command -v flatpak >/dev/null 2>&1; then
        flatpak update -y
    fi
else
    echo "=== Skipping system updates (--no-update) ==="
fi

"$ROOT_DIR/install-hooks.sh"

if [[ "$INSTALL_MODE" == "clean" ]]; then
    "$INSTALL_PATH/cleanup-install.sh" --profile "$ARCH_RICE_PROFILE"
fi

cd "$INSTALL_PATH"

scripts=(
    install-linuxHeaders.sh
    install-stow.sh
    install-tools.sh
    install-drivers.sh
    install-fonts.sh
    install-network.sh
    install-hypr.sh
    install-terminal.sh
    install-qt.sh
    install-fileManager.sh
    install-audio.sh
    install-polkit.sh
    install-applications.sh
    install-discord.sh
    install-vscode.sh
    install-steam.sh
    install-browser.sh
    install-rofi.sh
    install-bambuStudio.sh
    install-libreOffice.sh
    install-roblox.sh
    install-print.sh
    install-kicad.sh
    install-docker.sh
    install-openRGB.sh
    install-dotfiles.sh
)

for script in "${scripts[@]}"; do
    echo "=== Running $script (profile: $ARCH_RICE_PROFILE) ==="
    "./$script"
done

echo "=== Install complete for profile: $ARCH_RICE_PROFILE (mode: $INSTALL_MODE) ==="
