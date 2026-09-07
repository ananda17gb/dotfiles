#!/bin/bash

# Replace with your TWS MAC address
DEVICE="F4:B6:2D:60:56:AB"

# Optional: Friendly name for notifications
NAME="soundcore R50i"

# Get current connection status
STATUS=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')
if [[ "$STATUS" != "yes" ]]; then
  bluetoothctl power on
  sleep 1
fi

# Check if device is connected
if bluetoothctl info "$DEVICE" | grep -q "Connected: yes"; then
  # Disconnect
  bluetoothctl disconnect "$DEVICE" >/dev/null 2>&1
  notify-send -a "Bluetooth" "$NAME" "Disconnected" -t 2000
else
  # Connect
  bluetoothctl connect "$DEVICE" >/dev/null 2>&1
  if bluetoothctl info "$DEVICE" | grep -q "Connected: yes"; then
    notify-send -a "Bluetooth" "$NAME" "Connected" -t 2000
  else
    notify-send -a "Bluetooth" "$NAME" "Failed to connect!" -t 3000
  fi
fi
