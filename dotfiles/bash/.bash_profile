if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec start-hyprland
fi
export PATH="/home/tim/develop/flutter/bin:$PATH"
