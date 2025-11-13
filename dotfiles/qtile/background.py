import os
import random
from libqtile.config import Screen
from pathlib import Path

BACKGROUND_DIR = os.path.join(Path.home(), "GoogleDrive", "backgrounds")


def get_wallpapers():
    """Get wallpaper"""
    if os.path.exists(BACKGROUND_DIR):
        list_bg = os.listdir(BACKGROUND_DIR)
        return list_bg
    else:
        return []


def rander_background(screens: list[Screen]) -> None:
    """Randomly change background"""
    if not os.path.exists(BACKGROUND_DIR):
        return  # Skip if GoogleDrive not mounted yet
    wallpapers = get_wallpapers()
    if wallpapers:
        for screen in screens:
            random_wallpaper = random.choice(wallpapers)
            wallpaper_path = os.path.join(BACKGROUND_DIR, random_wallpaper)
            screen.set_wallpaper(wallpaper_path, "stretch")
