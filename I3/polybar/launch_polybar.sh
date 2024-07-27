#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bars for each monitor
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    echo "Found monitor: $m"
    if [ "$m" == "eDP-1" ]; then
      MONITOR=$m polybar --reload toph &
      echo "Launching polybar on $m"
    elif [ "$m" == "eDP-1-1" ]; then
      if xrandr --query | grep "$m disconnected"; then
        echo "Monitor $m is disconnected"
      else
        MONITOR=$m polybar --reload toph &
        echo "Launching polybar on $m"
      fi
    fi
  done
else
  polybar --reload toph &
  echo "xrandr command not found"
fi
