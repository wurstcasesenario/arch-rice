#!/usr/bin/env bash

echo "=== Installing Printer Stuff ==="

sudo pacman -S --noconfirm --needed cups cups-pdf ghostscript gsfonts gutenprint system-config-printer
sudo pacman -S --noconfirm --needed system-config-printer

sudo systemctl enable cups.service
sudo systemctl start cups.service

# http://localhost:631
