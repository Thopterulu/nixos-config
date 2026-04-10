#!/usr/bin/env bash
# Toggle monitor on/off using hyprctl
# Usage: toggle-monitor.sh MONITOR_NAME

MONITOR="$1"

if [ -z "$MONITOR" ]; then
    echo "Usage: $0 MONITOR_NAME"
    echo "Available monitors:"
    hyprctl monitors | grep "Monitor" | awk '{print $2}'
    exit 1
fi

# Check if monitor is currently enabled
if hyprctl monitors | grep -q "Monitor $MONITOR"; then
    echo "Disabling $MONITOR"
    hyprctl keyword monitor "$MONITOR,disable"
else
    echo "Monitor $MONITOR is already disabled or doesn't exist"
fi
