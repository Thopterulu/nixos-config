#!/usr/bin/env bash
# Toggle HDMI-A-4 on/off using DPMS (Display Power Management)
# This is safer than monitor reconfiguration and won't crash portals

MONITOR="HDMI-A-4"

# Function to send notification safely
notify() {
    if command -v dunstify &>/dev/null; then
        dunstify -t 2000 "$1" "$2"
    elif command -v notify-send &>/dev/null; then
        notify-send "$1" "$2" -t 2000
    fi
}

# Function to check if monitor DPMS is on
is_enabled() {
    local dpms_status=$(hyprctl monitors -j 2>/dev/null | jq -r ".[] | select(.name == \"$MONITOR\") | .dpmsStatus")
    [ "$dpms_status" = "true" ] || [ "$dpms_status" = "1" ]
}

# If called with "status" argument, just print status
if [ "$1" == "status" ]; then
    if is_enabled; then
        echo '{"text": "󰍹", "tooltip": "HDMI-A-4: On (Click to turn off)", "class": "enabled"}'
    else
        echo '{"text": "󰍺", "tooltip": "HDMI-A-4: Off (Click to turn on)", "class": "disabled"}'
    fi
    exit 0
fi

# Toggle the monitor using DPMS (safe, won't crash)
if is_enabled; then
    # Turn display off
    hyprctl dispatch dpms off "$MONITOR" &>/dev/null
    notify "Monitor" "HDMI-A-4 turned off"
else
    # Turn display on
    hyprctl dispatch dpms on "$MONITOR" &>/dev/null
    notify "Monitor" "HDMI-A-4 turned on"
fi

exit 0
