#!/usr/bin/env bash

nbfc_status=$(nbfc status -f 0)

IFS=$'\n' read -d '' -r -a nbfc_status_arr <<<"$nbfc_status"

fan_speed_status="${nbfc_status_arr[5]}"

read -r -a fan_speed_arr <<<"$fan_speed_status"

fan_speed_float=${fan_speed_arr[4]}
fan_speed=${fan_speed_float%.*}

if [[ -z $1 || ($1 != "faster" && $1 != "slower" && $1 != "info") ]]; then
    echo "Argument 1 is either empty or using the wrong argument, 
please provide it (faster (+10)/ slower (-10)/ info)!"
    exit 1
fi

if [[ $1 == "info" ]]; then
    notify-send "NBFC" "Current fan speed is: $fan_speed"
    exit 1
fi

if [[ $fan_speed -ge 0 ]]; then
    if [[ $1 == "faster" ]]; then
        fan_speed=$((fan_speed + 10))
    elif [[ $1 == "slower" ]]; then
        fan_speed=$((fan_speed - 10))
    fi
fi

error_output=$(pkexec nbfc set -s "$fan_speed" 2>&1)
exit_status=$?

if [[ $exit_status -eq 0 ]]; then
    notify-send "NBFC" "Fan speed set to: $fan_speed"
else
    if [[ "$error_output" == *"Not authorized"* ]]; then
        notify-send "NBFC Error" "Permission denied: You are not authorized."
    else
        notify-send "NBFC Error" "Failed to set fan speed: $error_output"
    fi
fi
