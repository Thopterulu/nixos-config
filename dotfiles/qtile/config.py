# type: ignore
# ruff: noqa: E722
import os
import time
import subprocess
import threading
from libqtile import bar, layout, qtile, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from background import rander_background
from libqtile.widget import (
    Battery,
    CurrentLayout,
    GroupBox,
    Prompt,
    WindowName,
    Chord,
    GenPollText,
    TextBox,
    PulseVolume,
    OpenWeather,
    Clock,
    Spacer,
    Systray,
    Notify,
    Bluetooth,
)


BLACK = "#000000"
GREY = "#222222"
DARK_GREY = "#111111"
BLUE = "#007fdf"
DARK_BLUE = "#002a4a"
ORANGE = "#dd6600"
DARK_ORANGE = "#371900"
CYAN = "#00a6b2"
LIGHT_GREEN = "#42d6a4"
SOME_RED = "#d56d77"
YOINK_BLUE = "#59adf6"


def parse_notification(message: str) -> str:
    return message.replace("\n", "⏎")


# Shutdown
def shutdown_now() -> None:
    qtile.cmd_spawn("shutdown now")  # type: ignore


# Reboot
def reboot_now() -> None:
    qtile.cmd_spawn("reboot")  # type: ignore


def refresh_wallpaper(screens: list[Screen]):
    while True:
        time.sleep(5)
        rander_background(screens)
        time.sleep(4 * 60)


def get_music_info() -> str:
    try:
        status = (
            subprocess.check_output(["playerctl", "status"], stderr=subprocess.DEVNULL)
            .decode()
            .strip()
        )
        if status == "Playing":
            title = (
                subprocess.check_output(
                    ["playerctl", "metadata", "--format", "{{ artist }} - {{ title }}"],
                    stderr=subprocess.DEVNULL,
                )
                .decode()
                .strip()
            )
            if len(title) > 40:
                title = title[:37] + "..."
            return f"♪ {title}"
        elif status == "Paused":
            return "⏸ Paused"
    except:
        pass
    return ""


def has_battery() -> bool:
    """Check if system has a battery"""
    try:
        return os.path.exists("/sys/class/power_supply/BAT0") or os.path.exists(
            "/sys/class/power_supply/BAT1"
        )
    except:
        return False


def get_network_info() -> str:
    """Get network connection status by checking interfaces only"""
    try:
        # Check active interfaces
        result = subprocess.run(
            ["ip", "link", "show"], capture_output=True, text=True, timeout=2
        )
        if result.returncode == 0:
            lines = result.stdout.split("\n")
            for line in lines:
                if "state UP" in line and ("enp" in line or "eth" in line):
                    return "🌐 Ethernet"
                elif "state UP" in line and ("wlp" in line or "wlan" in line):
                    # Try to get WiFi SSID
                    try:
                        wifi_result = subprocess.run(
                            ["iwgetid", "-r"], capture_output=True, text=True, timeout=1
                        )
                        if wifi_result.returncode == 0 and wifi_result.stdout.strip():
                            ssid = wifi_result.stdout.strip()
                            return f"📶 {ssid}"
                        else:
                            return "📶 WiFi"
                    except:
                        return "📶 WiFi"
        return "❌ Disconnected"
    except:
        return "❌ Error"


@hook.subscribe.screen_change
def set_screens(event) -> None:
    """Dynamically reconfigure screens when they change"""
    lazy.restart()


@hook.subscribe.startup_once
def autostart() -> None:
    """Run scripts on Qtile startup"""
    home = os.path.expanduser("~")
    # Mount Google Drive first
    subprocess.Popen([f"{home}/.local/bin/mount-gdrive"])
    thread_bg_changer.start()


@hook.subscribe.shutdown
def shutdown() -> None:
    """Run scripts on Qtile startup"""
    # Stop background changer
    thread_bg_changer.join()


@lazy.function
def move_to_next_group(qtile) -> None:
    current_group = qtile.current_screen.group
    group_names = [g.name for g in qtile.groups]
    current_index = group_names.index(current_group.name)
    next_index = (current_index + 1) % len(group_names)
    qtile.current_window.togroup(group_names[next_index], switch_group=True)


@lazy.function
def move_to_prev_group(qtile) -> None:
    current_group = qtile.current_screen.group
    group_names = [g.name for g in qtile.groups]
    current_index = group_names.index(current_group.name)
    prev_index = (current_index - 1) % len(group_names)
    qtile.current_window.togroup(group_names[prev_index], switch_group=True)


mod = "mod4"
terminal = guess_terminal()

keys = [
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Envoyer fenêtre vers l'autre écran
    Key([mod, "mod1"], "h", lazy.window.toscreen(0), desc="Move window to screen 0"),
    Key([mod, "mod1"], "l", lazy.window.toscreen(1), desc="Move window to screen 1"),
    # Key([mod, "shift"], "x", lazy.spawn("i3lock -c 000000"), desc="Lock screen"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key(
        [mod],
        "t",
        lazy.window.toggle_floating(),
        desc="Toggle floating on the focused window",
    ),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([mod], "e", lazy.spawn("pcmanfm")),
    Key([mod], "d", lazy.spawn("rofi -show drun")),
    Key([mod], "m", lazy.spawn("firefox")),
    Key(["mod1"], "Tab", lazy.layout.next(), desc="Next window"),
    Key(["mod1", "shift"], "Tab", lazy.layout.previous(), desc="Previous window"),
    # IMPORTANT : Forcer le mode fenêtré temporaire
    Key([mod, "mod1"], "f", lazy.window.toggle_fullscreen()),
    # Minimiser la fenêtre
    Key([mod, "mod1"], "m", lazy.window.toggle_minimize()),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )


groups = [Group(i) for i in "123456"]

for i in groups:
    keys.extend(
        [
            Key([mod], f"F{i.name}", lazy.group[i.name].toscreen()),
            Key(
                [mod, "shift"],
                f"F{i.name}",
                lazy.window.togroup(i.name, switch_group=True),
            ),
            # mod + group number = switch to group
            #  Key(
            #      [mod],
            #      i.name,
            #      lazy.group[i.name].toscreen(),
            #      desc=f"Switch to group {i.name}",
            #  ),
            #  # mod + shift + group number = switch to & move focused window to group
            #  Key(
            #      [mod, "shift"],
            #      i.name,
            #      lazy.window.togroup(i.name, switch_group=True),
            #      desc=f"Switch to & move focused window to group {i.name}",
            #  ),
            # Or, use below if you prefer not to switch to that group.
            # # mod + shift + group number = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

layout_theme = {
    "border_width": 1,
    "margin": 6,
    "border_focus": "89bdc5",
    "border_normal": "d56d77",
}


layouts = [
    layout.Columns(**layout_theme),
    layout.Max(**layout_theme),  # Gaming-friendly layout
    layout.Floating(**layout_theme),  # For games that need floating
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="JetBrainsMono Nerd Font Mono", fontsize=14, padding=3, padding_y=4
)
extension_defaults = widget_defaults.copy()


# Create base widgets (common to both screens)
def create_base_widgets():
    widgets = [
        CurrentLayout(),
        GroupBox(
            disable_drag=True,
        ),
        Prompt(),
        WindowName(),
        Chord(
            chords_colors={
                "launch": ("#ff0000", "#ffffff"),
            },
            name_transform=lambda name: name.upper(),
        ),
        GenPollText(
            func=get_music_info,
            update_interval=2,
            mouse_callbacks={
                "Button1": lambda: subprocess.run(["playerctl", "play-pause"])
            },
            **widget_defaults,
        ),
    ]

    # Add battery widget if battery exists
    if os.path.isdir("/sys/module/battery"):
        widgets.insert(
            -1,
            Battery(
                format="🔋 {percent:2.0%} {char}",
                charge_char="⚡",
                discharge_char="↓",
                empty_char="❌",
                full_char="✓",
                low_percentage=0.2,
                low_foreground="ff0000",
                **widget_defaults,
            ),
        )

    # Add network widget
    widgets.append(
        GenPollText(
            func=get_network_info,
            update_interval=5,
            **widget_defaults,
        )
    )
    return widgets


def end_widgets():  # type: ignore
    return [
        TextBox(
            text="󱎕",
            foreground=LIGHT_GREEN,
            background=BLACK,
            fontsize=35,
            padding=-3,
        ),
        TextBox(
            text="",
            foreground=ORANGE,
            background=LIGHT_GREEN,
            fontsize=45,
        ),
        PulseVolume(
            background=LIGHT_GREEN,
            foreground=ORANGE,
            limit_max_volume=True,
            padding_y=1,
            fontsize=16,
            volume_app="pavucontrol",
        ),
        TextBox(
            text="󱎕",
            foreground=CYAN,
            background=LIGHT_GREEN,
            fontsize=35,
            padding=-3,
        ),
        OpenWeather(
            location="Lyon",
            format="Lyon {icon} {main_temp:.0f}°{units_temperature}",
            background=CYAN,
            foreground=ORANGE,
            mouse_callbacks={
                "Button1": lambda: subprocess.run(
                    [
                        "xdg-open",
                        "https://meteofrance.com/previsions-meteo-france/lyon/69000",
                    ]
                )
            },
        ),
        TextBox(
            text="󱎕",
            foreground=DARK_BLUE,
            background=CYAN,
            fontsize=35,
            padding=-3,
        ),
        TextBox(
            text="",
            foreground=ORANGE,
            background=DARK_BLUE,
            fontsize=22,
            padding=1,
            padding_y=0,
        ),
        Clock(
            format="%a %d/%m/%Y %H:%M %p",
            background=DARK_BLUE,
            foreground=ORANGE,
        ),
        TextBox(
            text="",
            foreground=ORANGE,
            background=DARK_BLUE,
            fontsize=26,
            padding=1,
            padding_y=0,
            mouse_callbacks={"Button1": shutdown_now, "Button3": reboot_now},
        ),
        Spacer(
            length=6,
            background=DARK_BLUE,
        ),
    ]


# Primary screen widgets (with systray)
def create_primary_widgets():
    widgets = create_base_widgets()
    widgets.extend(
        [
            Notify(fmt=" 🔥 {} ", parse_text=parse_notification),
            Bluetooth(),
            Systray(),
        ]
        + end_widgets()
    )
    return widgets


# Secondary screen widgets (no systray)
def create_secondary_widgets():
    widgets = create_base_widgets()
    widgets.extend(end_widgets())
    return widgets


screens = [
    Screen(
        top=bar.Bar(
            create_primary_widgets(),
            25,
            margin=[0, 0, 0, 0],
        ),
    ),
    Screen(
        top=bar.Bar(
            create_secondary_widgets(),
            25,
            margin=[0, 0, 0, 0],
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        # Gaming rules - force certain games to not float
        Match(
            wm_class="steam_app_"
        ),  # Force Steam games to float for proper fullscreen
        Match(wm_class="cs2"),
        Match(wm_class="csgo"),
        Match(title="Counter-Strike"),
    ]
)
auto_fullscreen = True
respect_minimum_size = False
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = False  # Disable for gaming


# Gaming window rules
@hook.subscribe.client_new
def auto_fullscreen_games(window) -> None:
    """Auto-fullscreen games and disable window decorations"""
    game_classes = [
        "steam_app_",  # Steam games
        "cs2",
        "csgo",
        "dota2",
        "hl2_linux",
    ]

    wm_class = window.get_wm_class()
    if wm_class:
        for game_class in game_classes:
            if any(game_class.lower() in cls.lower() for cls in wm_class):
                # Set floating first, then fullscreen for proper scaling
                window.floating = True
                window.fullscreen = True
                # Disable tiling completely for games
                window.togroup(qtile.current_screen.group.name)
                break


# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
thread_bg_changer = threading.Thread(target=refresh_wallpaper, args=(screens,))
