import os
import random
from libqtile.config import Screen
from pathlib import Path

BACKGROUND_DIR = os.path.join(Path.home(), "/GoogleDrive/backgrounds")


def get_wallpapers():
    """Get wallpaper"""
    if os.path.exists(BACKGROUND_DIR):
        list_bg = os.listdir(BACKGROUND_DIR)
        return list_bg
    else:
        return []

def rander_background(screens : list[Screen]):
    """Randomly change background"""
    wallpapers = get_wallpapers()
    if wallpapers:
        random_wallpaper = random.choice(wallpapers)
        wallpaper_path = os.path.join(BACKGROUND_DIR, random_wallpaper)
        for screen in screens:
            screen.set_wallpaper(wallpaper_path)

