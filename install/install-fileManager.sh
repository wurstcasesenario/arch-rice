#!/usr/bin/env bash

echo "=== Installing Filemanager ==="

sudo pacman -S --noconfirm nautilus

# Open Terminal Extension
yay -S --noconfirm nautilus-open-any-terminal
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal kitty
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal keybindings '<Ctrl><Alt>t'
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal new-tab true

# Eye of Gnome
sudo pacman -S --noconfirm eog
xdg-mime default org.gnome.eog.desktop image/jpeg
xdg-mime default org.gnome.eog.desktop image/png
xdg-mime default org.gnome.eog.desktop image/gif
xdg-mime default org.gnome.eog.desktop image/bmp
xdg-mime default org.gnome.eog.desktop image/tiff
xdg-mime default org.gnome.eog.desktop image/webp

