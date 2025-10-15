#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/GoogleDrive/backgrounds"

while true; do
    if [ -d "$WALLPAPER_DIR" ] && [ "$(ls -A "$WALLPAPER_DIR")" ]; then
        # Get random wallpaper
        WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.bmp" -o -iname "*.webp" \) | shuf -n 1)
        
        if [ -n "$WALLPAPER" ]; then
            xwallpaper --output DP-2 --zoom "$WALLPAPER" \
                      --output HDMI-1-1 --zoom "$WALLPAPER"
        fi
    fi
    
    sleep 120  # 2 minutes
done
