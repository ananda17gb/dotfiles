#!/bin/bash

playerctl metadata --format '{{title}}' --follow | while read -r line; do
  # Run your notification script every time the title changes
  ~/.config/mango/scripts/music_notify.sh
done
