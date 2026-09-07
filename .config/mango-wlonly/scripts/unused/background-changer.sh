#!/usr/bin/env bash
set -e

IMG="$HOME/dotfiles/wallpapers/radio-tower-night.png"
SRC="${1:-$IMG}"

MANGOWC_WALL="$HOME/.config/mango/wallpaper.png"
ln -sf "$SRC" "$MANGOWC_WALL"

LIMINE_WALL="/boot/limine-splash.png"
sudo cp "$SRC" "$LIMINE_WALL"

echo "Wallpaper updated."
