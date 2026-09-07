#!/usr/bin/env bash

filename=$(basename "$0")

kill $(pgrep -f $filename | /usr/bin/grep -v ^$$\$)

notified_full=false

while true; do

    percentage=$(cat /sys/class/power_supply/BAT1/capacity)
    status=$(cat /sys/class/power_supply/BAT1/status)

    if [[ $status == "Discharging" ]]; then
        if [[ $percentage -le 15 ]]; then
            notify-send -r 9999991 -u critical "Critical" "Battery is currently at: $percentage%"
        elif [[ $percentage -le 30 ]]; then
            notify-send -r 9999991 -u critical "Warning" "Battery is currently at: $percentage%"
        fi
    fi

    if [[ $status == "Charging" ]]; then
        if [[ $percentage == 100 ]]; then
            if [[ $notified_full == false ]]; then
                notify-send -r 9999991 "Full" "Battery is currently at: $percentage%"
                notified_full=true
            fi
        else
            notified_full=false
        fi
    fi
    sleep 60
done
