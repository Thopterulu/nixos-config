import os
import subprocess
from libqtile import bar, layout, qtile, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

def get_music_info():
    try:
        status = subprocess.check_output(['playerctl', 'status'], stderr=subprocess.DEVNULL).decode().strip()
        if status == 'Playing':
            title = subprocess.check_output(['playerctl', 'metadata', '--format', '{{ artist }} - {{ title }}'], stderr=subprocess.DEVNULL).decode().strip()
            if len(title) > 40:
                title = title[:37] + "..."
            return f"♪ {title}"
        elif status == 'Paused':
            return "⏸ Paused"
    except:
        pass
    return ""

def has_battery():
    """Check if system has a battery"""
    try:
        return os.path.exists('/sys/class/power_supply/BAT0') or os.path.exists('/sys/class/power_supply/BAT1')
    except:
        return False


@hook.subscribe.screen_change
def set_screens(event):
    """Dynamically reconfigure screens when they change"""
    lazy.restart()

@hook.subscribe.startup_once
def autostart():
    """Run scripts on Qtile startup"""
    home = os.path.expanduser('~')
    # Mount Google Drive first
    subprocess.Popen([f"{home}/.local/bin/mount-gdrive"])
    # Wait a bit, then start wallpaper changer
    subprocess.Popen(['bash', '-c', f'sleep 5 && {home}/nixos-config/scripts/wallpaper-changer.sh'])

@lazy.function
def move_to_next_group(qtile):
    current_group = qtile.current_screen.group
    group_names = [g.name for g in qtile.groups]
    current_index = group_names.index(current_group.name)
    next_index = (current_index + 1) % len(group_names)
    qtile.current_window.togroup(group_names[next_index], switch_group=True)

@lazy.function
def move_to_prev_group(qtile):
    current_group = qtile.current_screen.group
    group_names = [g.name for g in qtile.groups]
    current_index = group_names.index(current_group.name)
    prev_index = (current_index - 1) % len(group_names)
    qtile.current_window.togroup(group_names[prev_index], switch_group=True)

mod = "mod4"
terminal = guess_terminal()

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Envoyer fenêtre vers l'autre écran
    Key([mod, "mod1"], "h", lazy.window.toscreen(0), desc="Move window to screen 0"),
    Key([mod, "mod1"], "l", lazy.window.toscreen(1), desc="Move window to screen 1"),
    #Key([mod, "shift"], "x", lazy.spawn("i3lock -c 000000"), desc="Lock screen"),
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
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
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


groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
           Key([mod], f"F{i.name}", lazy.group[i.name].toscreen()),
           Key([mod, "shift"], f"F{i.name}", lazy.window.togroup(i.name, switch_group=True)),
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

layouts = [
    layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    layout.Max(),
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
    font="JetBrains Mono",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

# Create base widgets (common to both screens)
def create_base_widgets():
    widgets = [
        widget.CurrentLayout(),
        widget.GroupBox(disable_drag=True,),
        widget.Prompt(),
        widget.WindowName(),
        widget.Chord(
            chords_colors={
                "launch": ("#ff0000", "#ffffff"),
            },
            name_transform=lambda name: name.upper(),
        ),
        widget.GenPollText(
            func=get_music_info,
            update_interval=2,
            mouse_callbacks={'Button1': lambda: subprocess.run(['playerctl', 'play-pause'])},
            **widget_defaults,
        ),
    ]

    # Add battery widget if battery exists
    if has_battery():
        widgets.append(
            widget.Battery(
                format='🔋 {percent:2.0%} {char}',
                charge_char='⚡',
                discharge_char='↓',
                empty_char='❌',
                full_char='✓',
                low_percentage=0.2,
                low_foreground='ff0000',
                **widget_defaults,
            )
        )
    
    # Add network widget
    widgets.append(
        widget.Wlan(
            interface='auto',
            format='📶 {essid} {percent:2.0%}',
            disconnected_message='📶 Disconnected',
            ethernet_message='🌐 Ethernet',
            **widget_defaults,
        )
    )

    return widgets

# Primary screen widgets (with systray)
def create_primary_widgets():
    widgets = create_base_widgets()
    widgets.extend([
        widget.TextBox("&lt;M-r&gt;", foreground="#d75f5f"),
        widget.Systray(),
        widget.Clock(format="%a %d/%m/%Y %H:%M %p"),
        widget.QuickExit(),
    ])
    return widgets

# Secondary screen widgets (no systray)
def create_secondary_widgets():
    widgets = create_base_widgets()
    widgets.extend([
        widget.TextBox("&lt;M-r&gt;", foreground="#d75f5f"),
        widget.Clock(format="%a %d/%m/%Y %H:%M %p"),
        widget.QuickExit(),
    ])
    return widgets

screens = [
    Screen(
        bottom=bar.Bar(
            create_primary_widgets(),
            24,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
    ),
   Screen(
        bottom=bar.Bar(
            create_secondary_widgets(),
            24,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta

        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
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
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = False  # Disable for gaming

# Gaming window rules
@hook.subscribe.client_new
def auto_fullscreen_games(window):
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
                window.fullscreen = True
                window.floating = False
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
