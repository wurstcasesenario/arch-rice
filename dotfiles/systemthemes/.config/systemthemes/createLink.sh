#!/usr/bin/env bash

# Hardcoded target path
TARGET_PATH="$HOME/.config/systemthemes"

# Get hostname
HOSTNAME=$(uname -n)

# Construct final path with hostname
FINAL_PATH="${TARGET_PATH}/${HOSTNAME}"

# Symlink name (you can adjust this)
SYMLINK_NAME="${TARGET_PATH}/current"

rm "$SYMLINK_NAME"

# Create the symlink
ln -s "$FINAL_PATH" "$SYMLINK_NAME"

echo "Symlink created: $SYMLINK_NAME -> $FINAL_PATH"

