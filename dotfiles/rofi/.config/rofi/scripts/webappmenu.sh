#!/usr/bin/env bash

WEBAPP_DIR="$HOME/.local/share/webapps"
DESKTOP_DIR="$HOME/.local/share/applications"
ICON_DIR="$HOME/.local/share/icons/webapps"
BROWSER="chromium"   # or brave / google-chrome / firefox

mkdir -p "$WEBAPP_DIR" "$ICON_DIR"

choice=$(printf "Add Web App\nRemove Web App" | rofi -dmenu -p "Web Apps")

case "$choice" in
  "Add Web App")
    name=$(rofi -dmenu -p "App Name")
    [ -z "$name" ] && exit

    url=$(rofi -dmenu -p "URL")
    [ -z "$url" ] && exit

    # icon=$(rofi -dmenu -p "Icon (optional, path)")
    app_id=$(echo "$name" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')

    # Prüfen, ob URL schon mit http:// oder https:// beginnt
    if [[ ! "$url" =~ ^https?:// ]]; then
        url="https://$url"
    fi


    # Use favicon if no icon provided
    if [ -z "$icon" ]; then
        # Simple way to get favicon.ico
        tmp_icon="$ICON_DIR/$app_id.png"
        curl -sSL "$url/favicon.ico" -o "$tmp_icon"
        if [ ! -s "$tmp_icon" ]; then
            # fallback to generic icon if favicon not found
            tmp_icon="applications-internet"
        fi
        icon="$tmp_icon"
    fi

    desktop_file="$DESKTOP_DIR/webapp-$app_id.desktop"

    exec_cmd=""
    if [[ "$BROWSER" == "firefox" ]]; then
      exec_cmd="firefox --new-window $url"
    else
      exec_cmd="$BROWSER --app=$url"
    fi

    cat > "$desktop_file" <<EOF
[Desktop Entry]
Name=$name
Exec=$exec_cmd
Terminal=false
Type=Application
Categories=Network;WebApp;
Icon=$icon
EOF

    update-desktop-database "$DESKTOP_DIR" 2>/dev/null
    notify-send "Web App added" "$name"
    ;;
    
  "Remove Web App")
    apps=$(ls "$DESKTOP_DIR" | grep '^webapp-.*\.desktop$' | sed 's/webapp-//' | sed 's/.desktop//')
    app=$(echo "$apps" | rofi -dmenu -p "Remove App")
    [ -z "$app" ] && exit

    rm "$DESKTOP_DIR/webapp-$app.desktop"
    rm -f "$ICON_DIR/$app.png"
    update-desktop-database "$DESKTOP_DIR" 2>/dev/null
    notify-send "Web App removed" "$app"
    ;;
esac
