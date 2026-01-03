#!/usr/bin/env bash

# Power menu for Waybar using rofi

options="⏻ Shutdown\n Reboot\n🌙 Suspend\n🔒 Lock"

chosen=$(echo -e "$options" | rofi -dmenu -p "Power Menu" -theme-str 'window {width: 250px;}')

case "$chosen" in
    "⏻ Shutdown")
        shutdown now
        ;;
    " Reboot")
        reboot
        ;;
    "🌙 Suspend")
        systemctl suspend
        ;;
    "🔒 Lock")
        hyprlock || i3lock-fancy
        ;;
    *)
        ;;
esac
