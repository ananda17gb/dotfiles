#!/usr/bin/env bash

if pgrep -f "Yambar-Inhibit" > /dev/null; then
    pkill -f "Yambar-Inhibit"
else
    systemd-inhibit --what=idle --why='Yambar-Inhibit' sleep infinity &
fi
