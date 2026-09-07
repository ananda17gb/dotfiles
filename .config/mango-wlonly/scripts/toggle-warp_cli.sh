#!/usr/bin/env bash

status=$(warp-cli status)

# using read -a to turn the input from the status variable into an array (-a as in a in array)
read -a status_arr <<<"$status"

connection_status="${status_arr[2]}"

echo "$connection_status"

if [[ $connection_status == "Disconnected" ]]; then
    warp-cli connect
    notify-send "warp-cli" "Connected"
else
    warp-cli disconnect
    notify-send "warp-cli" "Disconnected"
fi
