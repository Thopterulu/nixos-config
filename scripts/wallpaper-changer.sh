#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/GoogleDrive/backgrounds"

while true; do
    if [ -d "$WALLPAPER_DIR" ] && [ "$(ls -A "$WALLPAPER_DIR")" ]; then
        # Get random wallpaper
        WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.bmp" -o -iname "*.webp" \) | shuf -n 1)
        
        if [ -n "$WALLPAPER" ]; then
            # Get all connected displays and set wallpaper on each
            xrandr --query | grep " connected" | cut -d' ' -f1 | while read output; do
                xwallpaper --output "$output" --zoom "$WALLPAPER"
            done
        fi
    fi
    
    sleep 120  # 2 minutes
done
