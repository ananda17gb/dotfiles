#!/usr/bin/env bash

options="Lock
Logout
Sleep
Reboot
Poweroff
Hibernate"

chosen=$(
  echo -e "$options" | fuzzel --dmenu \
    --lines 6
)

action=$(echo "$chosen" | xargs)

case "$action" in
Logout)
  mmsg dispatch quit
  ;;
Sleep)
  sync
  systemctl suspend
  swaylock --clock --indicator
  ;;
Lock)
  sync
  swaylock --clock --indicator
  ;;
Reboot)
  sync
  if mountpoint -q "/mnt/external-harddrive/"; then
    pkexec umount -l /mnt/external-harddrive/
  fi
  systemctl reboot
  ;;
Poweroff)
  sync
  if mountpoint -q "/mnt/external-harddrive/"; then
    pkexec umount -l /mnt/external-harddrive/
  fi
  systemctl poweroff
  ;;
Hibernate)
  sync
  systemctl hibernate
  ;;
*)
  exit 0
  ;;
esac
