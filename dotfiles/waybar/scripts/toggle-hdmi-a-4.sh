#!/usr/bin/env bash
# Toggle HDMI-A-4 on/off and show status

MONITOR="HDMI-A-4"
CONFIG_FILE="$HOME/.config/hypr/hdmi-a-4.conf"

# Function to check if monitor is enabled
is_enabled() {
    hyprctl monitors -j | jq -r ".[] | select(.name == \"$MONITOR\") | .disabled" 2>/dev/null | grep -q "false"
}

# Function to get current monitor config
get_current_config() {
    local width=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$MONITOR\") | .width")
    local height=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$MONITOR\") | .height")
    local refresh=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$MONITOR\") | .refreshRate")
    local x=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$MONITOR\") | .x")
    local y=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$MONITOR\") | .y")
    local scale=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$MONITOR\") | .scale")

    if [ -n "$width" ] && [ "$width" != "null" ]; then
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

# Toggle the monitor
if is_enabled; then
    # Save current config before disabling
    config=$(get_current_config)
    if [ -n "$config" ]; then
        echo "$config" > "$CONFIG_FILE"
    fi

    # Disable it
    hyprctl keyword monitor "$MONITOR,disable"
    # Update monitors.conf
    sed -i "s|monitor=HDMI-A-4,.*|monitor=HDMI-A-4,disable|" ~/.config/hypr/monitors.conf
    notify-send "Monitor" "HDMI-A-4 disabled (config saved)" -t 2000
else
    # Restore from saved config if it exists
    if [ -f "$CONFIG_FILE" ]; then
        config=$(cat "$CONFIG_FILE")
        hyprctl keyword monitor "$MONITOR,$config"
        # Update monitors.conf with saved settings
        sed -i "s|monitor=HDMI-A-4,.*|monitor=HDMI-A-4,$config|" ~/.config/hypr/monitors.conf
        notify-send "Monitor" "HDMI-A-4 enabled (config restored)" -t 2000
    else
        # Use default config
        hyprctl keyword monitor "$MONITOR,3840x2160@60,4480x0,1"
        sed -i "s|monitor=HDMI-A-4,.*|monitor=HDMI-A-4,3840x2160@60.0,4480x0,1.0|" ~/.config/hypr/monitors.conf
        notify-send "Monitor" "HDMI-A-4 enabled (default config)" -t 2000
    fi
fi
