#!/usr/bin/env bash

# Change brightness based on the argument passed to the script
case "$1" in
up)
  brightnessctl set +1%
  ;;
down)
  brightnessctl set 1%-
  ;;
esac

# Get current brightness percentage (numbers only)
BRIGHTNESS=$(brightnessctl i | grep -oP '\(\K[0-9]+(?=%\))')

# Send synchronous notification
notify-send -h string:x-canonical-private-synchronous:brightness_notif \
  -h int:value:"$BRIGHTNESS" \
  "Brightness: ${BRIGHTNESS}%" \
  -i display-brightness
