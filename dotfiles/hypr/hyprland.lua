-- Hyprland Lua Config
-- Equivalent to hyprland.conf for Hyprland 0.55.2+
-- Save this as ~/.config/hypr/hyprland.lua

-- #######################
-- ### AUTOSTART ###
-- #######################

local hl = require("hl")

-- Source monitors.conf if it exists
if hl.file_exists(os.getenv("HOME") .. "/.config/hypr/monitors.conf") then
    hl.source("~/.config/hypr/monitors.conf")
end

-- Default monitors (fallback)
hl.monitor("desc:Samsung Electric Company LC27G7xT H4ZR601106", { x = 0, y = 0, width = 2560, height = 1440, refresh_rate = 120, scale = 1, vrr = 1 })
hl.monitor("desc:Dell Inc. DELL G2722HS C3WW7P3", { x = 2560, y = 0, width = 1920, height = 1080, refresh_rate = 60, scale = 1, vrr = 1 })
hl.monitor("desc:JMG JMGO 0x00000001", { x = 4480, y = 0, width = 3840, height = 2160, refresh_rate = 60, scale = 1, vrr = 1 })
hl.monitor("", { preferred = true, auto = true })

-- #######################
-- ### MY PROGRAMS ###
-- #######################

local terminal = "ghostty"
local fileManager = "pcmanfm"
local menu = "rofi -show drun"

-- #################
-- ### AUTOSTART ###
-- #################

hl.exec_once("~/.config/hypr/autostart.sh")
hl.exec_once("hyprshell run")
hl.exec_once("waybar")

-- #############################
-- ### ENVIRONMENT VARIABLES ###
-- #############################

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- #####################
-- ### LOOK AND FEEL ###
-- #####################

hl.general = {
    gaps_in = 5,
    gaps_out = 20,
    border_size = 2,
    active_border = "rgba(33ccffee) rgba(00ff99ee) 45deg",
    inactive_border = "rgba(595959aa)",
    resize_on_border = false,
    allow_tearing = true,
    layout = "dwindle"
}

hl.decoration = {
    rounding = 10,
    rounding_power = 2,
    active_opacity = 1.0,
    inactive_opacity = 1.0,
    dim_inactive = true,
    dim_strength = 0.05,
    shadow = {
        enabled = true,
        range = 4,
        render_power = 3,
        color = "rgba(1a1a1aee)"
    },
    blur = {
        enabled = true,
        size = 3,
        passes = 1,
        vibrancy = 0.1696
    }
}

-- #######################
-- ### ANIMATIONS ###
-- #######################

hl.animations = {
    enabled = true,
    -- Bezier curves
    easeOutQuint = { 0.23, 1, 0.32, 1 },
    easeInOutCubic = { 0.65, 0.05, 0.36, 1 },
    linear = { 0, 0, 1, 1 },
    almostLinear = { 0.5, 0.5, 0.75, 1 },
    quick = { 0.15, 0, 0.1, 1 },
    -- Animations
    global = { 1, 10, "default" },
    border = { 1, 5.39, "easeOutQuint" },
    windows = { 1, 4.79, "easeOutQuint" },
    windowsIn = { 1, 4.1, "easeOutQuint", "popin 87%" },
    windowsOut = { 1, 1.49, "linear", "popin 87%" },
    fadeIn = { 1, 1.73, "almostLinear" },
    fadeOut = { 1, 1.46, "almostLinear" },
    fade = { 1, 3.03, "quick" },
    layers = { 1, 3.81, "easeOutQuint" },
    layersIn = { 1, 4, "easeOutQuint", "fade" },
    layersOut = { 1, 1.5, "linear", "fade" },
    fadeLayersIn = { 1, 1.79, "almostLinear" },
    fadeLayersOut = { 1, 1.39, "almostLinear" },
    workspaces = { 1, 1.94, "almostLinear", "fade" },
    workspacesIn = { 1, 1.21, "almostLinear", "fade" },
    workspacesOut = { 1, 1.94, "almostLinear", "fade" },
    zoomFactor = { 1, 7, "quick" }
}

-- #####################
-- ### DWINDLE ###
-- #####################

hl.dwindle = {
    preserve_split = true,
    smart_split = false,
    smart_resizing = true,
    force_split = 0
}

-- ###################
-- ### MASTER ###
-- ###################

hl.master = {
    new_status = "master"
}

-- ###################
-- ### MISC ###
-- ###################

hl.misc = {
    force_default_wallpaper = -1,
    disable_hyprland_logo = false,
    enable_swallow = false,
    swallow_regex = "^(Alacritty|com\\.mitchellh\\.ghostty|foot)$"
}

-- ###################
-- ### CURSOR ###
-- ###################

hl.cursor = {
    no_hardware_cursors = true,
    enable_hyprcursor = true,
    no_break_fs_vrr = true
}

-- ###############
-- ### INPUT ###
-- ###############

hl.input = {
    kb_layout = "fr",
    kb_variant = "",
    kb_model = "pc105",
    kb_options = "caps:escape",
    kb_rules = "",
    follow_mouse = 1,
    sensitivity = 0,
    touchpad = {
        natural_scroll = false
    }
}

-- Per-device config
hl.device("epic-mouse-v1", { sensitivity = -0.5 })

-- Gestures
hl.gesture("3", "horizontal", "workspace")

-- ###################
-- ### KEYBINDINGS ###
-- ###################

local mainMod = "SUPER"

-- Standard binds
hl.bind(mainMod, "T", "exec", terminal)
hl.bind(mainMod, "Q", "killactive")
hl.bind(mainMod, "M", "exit")
hl.bind(mainMod, "E", "exec", fileManager)
hl.bind(mainMod, "V", "togglefloating")
hl.bind(mainMod, "P", "pseudo") -- dwindle
hl.bind(mainMod, "F", "fullscreen", "1")
hl.bind(mainMod .. " SHIFT", "F", "fullscreen", "0")

-- Lock screen
hl.bind(mainMod, "L", "exec", "hyprlock")

-- Restart hyprshell
hl.bind(mainMod .. " SHIFT", "R", "exec", "pkill hyprshell; hyprshell run")

-- Clipboard manager
hl.bind(mainMod, "C", "exec", "copyq toggle")

-- Wallpaper changer
hl.bind(mainMod, "W", "exec", "~/.config/hypr/scripts/wallpaper.sh")

-- Screenshots with swappy
hl.bind(mainMod .. " SHIFT", "S", "exec", "grim -g \"\$(slurp)\" - | swappy -f -")
hl.bind(mainMod .. " SHIFT ALT", "S", "exec", "grim - | swappy -f -")
hl.bind(mainMod .. " CTRL", "S", "exec", "grimblast --notify copysave screen ~/Pictures/Screenshots/\$(date +%Y%m%d-%H%M%S).png")

-- Move focus with mainMod + arrow keys
hl.bind(mainMod, "left", "movefocus", "l")
hl.bind(mainMod, "right", "movefocus", "r")
hl.bind(mainMod, "up", "movefocus", "u")
hl.bind(mainMod, "down", "movefocus", "d")

-- Workspaces
hl.bind("SUPER", "code:10", "workspace", "1")
hl.bind("SUPER", "code:11", "workspace", "2")
hl.bind("SUPER", "code:12", "workspace", "3")
hl.bind("SUPER", "code:13", "workspace", "4")

-- Send to Workspaces
hl.bind("SUPER SHIFT", "code:10", "movetoworkspace", "1")
hl.bind("SUPER SHIFT", "code:11", "movetoworkspace", "2")
hl.bind("SUPER SHIFT", "code:12", "movetoworkspace", "3")

-- Example special workspace (scratchpad)
hl.bind(mainMod, "S", "togglespecialworkspace", "magic")
hl.bind(mainMod .. " SHIFT", "S", "movetoworkspace", "special:magic")

-- Scroll through workspaces with mainMod + scroll
hl.bind(mainMod, "mouse_down", "workspace", "e+1")
hl.bind(mainMod, "mouse_up", "workspace", "e-1")

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bindm(mainMod, "mouse:272", "movewindow")
hl.bindm(mainMod, "mouse:273", "resizewindow")

-- Laptop multimedia keys for volume and LCD brightness
hl.bindel("", "XF86AudioRaiseVolume", "exec", "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+")
hl.bindel("", "XF86AudioLowerVolume", "exec", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
hl.bindel("", "XF86AudioMute", "exec", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
hl.bindel("", "XF86AudioMicMute", "exec", "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")
hl.bindel("", "XF86MonBrightnessUp", "exec", "brightnessctl -e4 -n2 set 5%+")
hl.bindel("", "XF86MonBrightnessDown", "exec", "brightnessctl -e4 -n2 set 5%-")

-- Requires playerctl
hl.bindl("", "XF86AudioNext", "exec", "playerctl next")
hl.bindl("", "XF86AudioPause", "exec", "playerctl play-pause")
hl.bindl("", "XF86AudioPlay", "exec", "playerctl play-pause")
hl.bindl("", "XF86AudioPrev", "exec", "playerctl previous")

-- ##############################
-- ### WINDOWS AND WORKSPACES ###
-- ##############################

hl.workspace("1", { persistent = true, monitor = "desc:Samsung Electric Company LC27G7xT H4ZR601106", default = true })
hl.workspace("2", { persistent = true, monitor = "desc:Dell Inc. DELL G2722HS C3WW7P3" })
hl.workspace("3", { persistent = true, monitor = "desc:JMG JMGO 0x00000001" })

-- ##############################
-- ### GAMING WINDOW RULES ###
-- ##############################

-- Steam games
hl.window_rule({
    match = { class = "^(steam_app_.*)$" },
    float = true,
    no_blur = true,
    no_border = true,
    no_shadow = true,
    rounding = 0
})

hl.window_rule({
    match = { class = "^(cs2)$" },
    float = true,
    no_blur = true,
    no_border = true,
    no_shadow = true,
    rounding = 0
})

-- Battle.net launcher
hl.window_rule({
    match = { title = "^(Battle.net)$" },
    float = true,
    size = { 1200, 800 },
    center = true,
    no_blur = true,
    no_border = true,
    no_shadow = true,
    rounding = 0
})

-- StarCraft II
hl.window_rule({
    match = { title = "^(StarCraft II)$" },
    float = true,
    no_blur = true,
    no_border = true,
    no_shadow = true,
    rounding = 0
})
