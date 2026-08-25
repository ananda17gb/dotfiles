#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$TARGET_DIR"
FILEPATH="$TARGET_DIR/$(date +%Y-%m-%d_%H-%M-%S).png"

MODE="${1:-fullscreen}" # fullscreen, region, window
COPY_CLIP="${3:-false}" # true, false

if [ "$MODE" = "region" ]; then
  # 1. Coordinate wayfreeze
  PIPE=$(mktemp -u).fifo
  mkfifo "$PIPE"

  # wayfreeze --hide-cursor --after-freeze-timeout 100 --after-freeze-cmd "echo > $PIPE" &
  wayfreeze --hide-cursor --after-freeze-cmd "echo > $PIPE" &
  WAYFREEZE_PID=$!
  read -r <"$PIPE"
  rm -f "$PIPE"

  # 2. Capture the full frozen frame to memory immediately
  TEMP_SNAP=$(mktemp -t frozen-XXXXXX.png)
  grim "$TEMP_SNAP"

  # 3. Drop wayfreeze right away so user has input controls back
  kill "$WAYFREEZE_PID" 2>/dev/null

  # 4. Use slurp to get the geometry region
  GEOMETRY=$(slurp -d)
  if [ -z "$GEOMETRY" ]; then
    rm -f "$TEMP_SNAP"
    exit 1
  fi

  # 5. FIX: Have grim crop the frozen image using standard input.
  # Grim perfectly scales logical coordinates (-g) over a physical image source (-)
  grim -g "$GEOMETRY" - <"$TEMP_SNAP" >"$FILEPATH"
  rm -f "$TEMP_SNAP"

else
  # Standard flow for Fullscreen and Window modes
  PIPE=$(mktemp -u).fifo
  mkfifo "$PIPE"

  # wayfreeze --hide-cursor --after-freeze-timeout 100 --after-freeze-cmd "echo > $PIPE" &
  wayfreeze --hide-cursor --after-freeze-cmd "echo > $PIPE" &
  WAYFREEZE_PID=$!
  read -r <"$PIPE"
  rm -f "$PIPE"

  GEOMETRY=""
  if [ "$MODE" = "window" ]; then
    GEOMETRY=$(mmsg get focusing-client | jq -r '"\(.x),\(.y) \(.width)x\(.height)"')
    if [ -z "$GEOMETRY" ]; then
      kill "$WAYFREEZE_PID" 2>/dev/null
      exit 1
    fi
  fi

  if [ -n "$GEOMETRY" ]; then
    grim -g "$GEOMETRY" "$FILEPATH"
  else
    grim "$FILEPATH"
  fi

  kill "$WAYFREEZE_PID" 2>/dev/null
fi

# 7. Copy to clipboard if requested
if [ "$COPY_CLIP" = "true" ] && [ -f "$FILEPATH" ]; then
  wl-copy <"$FILEPATH"
fi
