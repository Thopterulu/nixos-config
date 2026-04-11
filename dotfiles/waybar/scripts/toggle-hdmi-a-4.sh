#!/usr/bin/env bash
# Toggle HDMI-A-4 on/off and show status

MONITOR="HDMI-A-4"
CONFIG_FILE="$HOME/.config/hypr/hdmi-a-4.conf"

# Function to send notification safely
notify() {
    if command -v dunstify &>/dev/null; then
        dunstify -t 2000 "$1" "$2"
    elif command -v notify-send &>/dev/null; then
        notify-send "$1" "$2" -t 2000
    fi
}

# Function to check if monitor is enabled
is_enabled() {
    local monitor_info=$(hyprctl monitors -j 2>/dev/null | jq -r ".[] | select(.name == \"$MONITOR\")")
    if [ -z "$monitor_info" ]; then
        # Monitor not found at all, consider it disabled
        return 1
    fi
    # Check if disabled field is false (meaning enabled)
    echo "$monitor_info" | jq -r ".disabled" | grep -q "false"
}

# Function to get current monitor config
get_current_config() {
    local width=$(hyprctl monitors -j 2>/dev/null | jq -r ".[] | select(.name == \"$MONITOR\") | .width")
    local height=$(hyprctl monitors -j 2>/dev/null | jq -r ".[] | select(.name == \"$MONITOR\") | .height")
    local refresh=$(hyprctl monitors -j 2>/dev/null | jq -r ".[] | select(.name == \"$MONITOR\") | .refreshRate")
    local x=$(hyprctl monitors -j 2>/dev/null | jq -r ".[] | select(.name == \"$MONITOR\") | .x")
    local y=$(hyprctl monitors -j 2>/dev/null | jq -r ".[] | select(.name == \"$MONITOR\") | .y")
    local scale=$(hyprctl monitors -j 2>/dev/null | jq -r ".[] | select(.name == \"$MONITOR\") | .scale")

    if [ -n "$width" ] && [ "$width" != "null" ]; then
        # Round refresh rate to avoid decimal issues
        refresh=$(printf "%.0f" "$refresh")
        echo "${width}x${height}@${refresh},${x}x${y},${scale}"
    fi
}

# If called with "status" argument, just print status
if [ "$1" == "status" ]; then
    if is_enabled; then
        echo '{"text": "󰍹", "tooltip": "HDMI-A-4: Enabled (Click to disable)", "class": "enabled"}'
    else
        echo '{"text": "󰍺", "tooltip": "HDMI-A-4: Disabled (Click to enable)", "class": "disabled"}'
    fi
    exit 0
fi

# Toggle the monitor - run in background to prevent terminal crashes
(
    if is_enabled; then
        # Save current config before disabling
        config=$(get_current_config)
        if [ -n "$config" ]; then
            echo "$config" > "$CONFIG_FILE"
        fi

        # Disable it
        hyprctl keyword monitor "$MONITOR,disable" &>/dev/null

        # Update monitors.conf
        if [ -f ~/.config/hypr/monitors.conf ]; then
            sed -i "s|monitor=HDMI-A-4,.*|monitor=HDMI-A-4,disable|" ~/.config/hypr/monitors.conf
        fi

        notify "Monitor" "HDMI-A-4 disabled"
    else
        # Restore from saved config if it exists
        if [ -f "$CONFIG_FILE" ]; then
            config=$(cat "$CONFIG_FILE")
            hyprctl keyword monitor "$MONITOR,$config" &>/dev/null

            # Update monitors.conf with saved settings
            if [ -f ~/.config/hypr/monitors.conf ]; then
                sed -i "s|monitor=HDMI-A-4,.*|monitor=HDMI-A-4,$config|" ~/.config/hypr/monitors.conf
            fi

            notify "Monitor" "HDMI-A-4 enabled"
        else
            # Use default config
            hyprctl keyword monitor "$MONITOR,3840x2160@60,4480x0,1" &>/dev/null

            if [ -f ~/.config/hypr/monitors.conf ]; then
                sed -i "s|monitor=HDMI-A-4,.*|monitor=HDMI-A-4,3840x2160@60,4480x0,1|" ~/.config/hypr/monitors.conf
            fi

            notify "Monitor" "HDMI-A-4 enabled"
        fi
    fi
) &

# Exit immediately, don't wait for background process
exit 0
