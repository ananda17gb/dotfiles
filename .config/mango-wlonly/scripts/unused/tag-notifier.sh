#!/bin/bash

status_output=$(mmsg get all-tags)

read -r active_tag window_count <<<$(echo "$status_output" | jq -r '
  .all_tags[] 
  | select(.monitor == "eDP-1") 
  | .tags[] 
  | select(.is_active == true) 
  | "\(.index) \(.client_count)"
')

if [ -n "$active_tag" ]; then
  if [ "$window_count" -gt 1 ]; then
    message="$active_tag-$window_count"
  else
    message="$active_tag"
  fi

  notify-send -a "MangoWM" -i dialog-information "$message"
else
  notify-send -a "MangoWM" -u critical "Error" "Could not parse MangoWM tags."
fi
