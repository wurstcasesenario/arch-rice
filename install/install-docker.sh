#!/usr/bin/env bash

echo "=== Installing Docker ==="

sudo pacman -S --needed --noconfirm docker docker-compose

echo "=== Enabling and starting Docker service ==="

sudo systemctl enable docker.service
sudo systemctl start docker.service

echo "=== Adding current user to docker group ==="

sudo usermod -aG docker $USER
