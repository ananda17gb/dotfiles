#!/usr/bin/env bash

# Change volume or mute based on the argument passed to the script
case "$1" in
up) pactl set-sink-volume @DEFAULT_SINK@ +1% ;;
down) pactl set-sink-volume @DEFAULT_SINK@ -1% ;;
mute) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
esac

# Get current volume and mute status
VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | head -n 1 | awk '{print $5}' | tr -d '%')
IS_MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

if [ "$IS_MUTED" = "yes" ]; then
  notify-send "Muted"
else
  notify-send -h string:x-canonical-private-synchronous:volume_notif -h int:value:"$VOLUME" "Volume: ${VOLUME}%" -i audio-volume-high
fi
