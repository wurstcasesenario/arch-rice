#!/usr/bin/env bash
set -e

# === Paths ===
DOTFILES_DIR="$HOME/arch-rice/dotfiles"
STOW_PKG="webapps"

STOW_APPS_DIR="$DOTFILES_DIR/$STOW_PKG/.local/share/applications"
STOW_ICON_DIR="$DOTFILES_DIR/$STOW_PKG/.local/share/icons/webapps"

DESKTOP_DIR="$HOME/.local/share/applications"

BROWSER="chromium"   # or brave / google-chrome / firefox

mkdir -p "$STOW_APPS_DIR" "$STOW_ICON_DIR"

# === Helper ===
restow_webapps() {
  stow -t ~ -D -d "$DOTFILES_DIR" webapps >/dev/null 2>&1 || true
  stow -t ~   -d "$DOTFILES_DIR" webapps >/dev/null
}


# === Menu ===
choice=$(printf "Add Web App\nRemove Web App\nSync" | rofi -dmenu -p "Web Apps")

case "$choice" in
  "Add Web App")
    name=$(rofi -dmenu -p "App Name")
    [ -z "$name" ] && exit

    url=$(rofi -dmenu -p "URL")
    [ -z "$url" ] && exit

    app_id=$(echo "$name" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')

    # Ensure https
    [[ "$url" =~ ^https?:// ]] || url="https://$url"

    # === Icon ===
    icon="$STOW_ICON_DIR/$app_id.png"
    curl -sSL "$url/favicon.ico" -o "$icon" || true
    [ -s "$icon" ] || icon="applications-internet"

    # === Exec ===
    if [[ "$BROWSER" == "firefox" ]]; then
      exec_cmd="firefox --new-window $url"
    else
      exec_cmd="$BROWSER --app=$url"
    fi

    desktop_file="$STOW_APPS_DIR/webapp-$app_id.desktop"

    cat > "$desktop_file" <<EOF
[Desktop Entry]
Name=$name
Exec=$exec_cmd
Terminal=false
Type=Application
Categories=Network;WebApp;
Icon=$icon
EOF

    restow_webapps

    update-desktop-database "$DESKTOP_DIR" 2>/dev/null
    notify-send "Web App added" "$name"
    ;;

  "Remove Web App")
    apps=$(basename -a "$STOW_APPS_DIR"/webapp-*.desktop 2>/dev/null \
      | sed 's/webapp-//' | sed 's/.desktop//')


    app=$(echo "$apps" | rofi -dmenu -p "Remove App")
    [ -z "$app" ] && exit

    rm -f "$STOW_APPS_DIR/webapp-$app.desktop"
    rm -f "$STOW_ICON_DIR/$app.png"

    restow_webapps

    update-desktop-database "$DESKTOP_DIR" 2>/dev/null
    notify-send "Web App removed" "$app"
    ;;
  
  "Sync")
    restow_webapps
    ;;
esac
