#!/bin/bash

# Get metadata using playerctl
# We target 'brave' or 'spotify' specifically, or just use the active player
PLAYER_INFO=$(playerctl metadata --format "{{title}} - {{artist}}" 2>/dev/null)
ALBUM_ART=$(playerctl metadata mpris:artUrl 2>/dev/null)

# # If no music is playing, exit
# if [ -z "$PLAYER_INFO" ]; then
#   notify-send "Media" "No music playing" -i audio-x-generic
#   exit 1
# fi

# Send to SwayNC
# Use a specific ID (synchronous) so it replaces the previous song notification
notify-send "Now Playing" "$PLAYER_INFO" \
  -i "$ALBUM_ART" \
  -h string:x-canonical-private-synchronous:music-notify \
  -u low
