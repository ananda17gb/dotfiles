#!/usr/bin/env bash

# Define choices with quick 2-character shortcuts
OPTIONS=(
  "s1 📸 Screen (Save File)"
  "r1 📐 Region (Save File)"
  "w1 🪟 Window (Save File)"
  "s2 📋 Screen ➜ Clipboard & File"
  "r2 📋 Region ➜ Clipboard & File"
  "w2 📋 Window ➜ Clipboard & File"
)

# Render menu and return the selected index (0-indexed)
SELECTION=$(printf "%s\n" "${OPTIONS[@]}" | fuzzel -d -p "Screenshot: " --index)

# Exit if selection was canceled
if [ -z "$SELECTION" ]; then
  exit 0
fi

SCRIPT="$HOME/.config/mango/scripts/screenshot/screenshot.sh"

# Match against the index numbers for instant execution
case "$SELECTION" in
0) exec "$SCRIPT" fullscreen false false ;; # s1
1) exec "$SCRIPT" region false false ;;     # r1
2) exec "$SCRIPT" window false false ;;     # w1

3) exec "$SCRIPT" fullscreen false true ;; # s2
4) exec "$SCRIPT" region false true ;;     # r2
5) exec "$SCRIPT" window false true ;;     # w2

*) exit 0 ;;
esac
