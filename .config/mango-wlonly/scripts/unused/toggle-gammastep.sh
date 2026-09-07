#!/usr/bin/env bash

if pgrep -x "gammastep" >/dev/null; then
    # It's running → kill it
    pkill -x gammastep
    notify-send "GammaStep" "Disabled" -t 1000
else
    # It's not running → start it
    gammastep -c ~/.config/gammastep/config.ini &
    notify-send "GammaStep" "Enabled" -t 1000
fi
