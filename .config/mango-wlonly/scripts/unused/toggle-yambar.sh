#!/bin/bash

if pgrep -x "yambar" >/dev/null; then
  pkill -x "yambar"
else
  # Launch yambar. Redirect output so it doesn't clutter your terminal/logs.
  yambar >/dev/null 2>&1 &
fi
