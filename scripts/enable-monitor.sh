#!/usr/bin/env bash
# Re-enable a disabled monitor
# Usage: enable-monitor.sh MONITOR_NAME RESOLUTION@REFRESH X Y

MONITOR="$1"
MODE="$2"
X="${3:-auto}"
Y="${4:-auto}"

if [ -z "$MONITOR" ] || [ -z "$MODE" ]; then
    echo "Usage: $0 MONITOR_NAME RESOLUTION@REFRESH [X] [Y]"
    echo "Example: $0 HDMI-A-1 1920x1080@60 2560 0"
    exit 1
fi

echo "Enabling $MONITOR at $MODE, position ${X}x${Y}"
hyprctl keyword monitor "$MONITOR,$MODE,${X}x${Y},1"
