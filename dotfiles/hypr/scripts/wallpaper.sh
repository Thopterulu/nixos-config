#!/usr/bin/env bash

# Wallpaper directories (primary and fallback)
PRIMARY_DIR="$HOME/GoogleDrive/backgrounds"
FALLBACK_DIR="$HOME/backgrounds"

# Determine which directory to use
if [ -d "$PRIMARY_DIR" ] && [ "$(ls -A "$PRIMARY_DIR" 2>/dev/null)" ]; then
    WALLPAPER_DIR="$PRIMARY_DIR"
elif [ -d "$FALLBACK_DIR" ] && [ "$(ls -A "$FALLBACK_DIR" 2>/dev/null)" ]; then
    WALLPAPER_DIR="$FALLBACK_DIR"
else
    echo "No wallpaper directory found"
    exit 1
fi

# Find all image files
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) 2>/dev/null)

if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Select random wallpaper
RANDOM_WALLPAPER="${WALLPAPERS[$RANDOM % ${#WALLPAPERS[@]}]}"

# Initialize swww daemon if not running
if ! pgrep -x swww-daemon > /dev/null; then
    swww-daemon &
    sleep 1
fi


# Set wallpaper with random transition
swww img "$RANDOM_WALLPAPER" \
    --transition-type random \
    --transition-duration 2 \
    --transition-fps 60
