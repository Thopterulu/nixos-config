-- Hyprland Lua config for 0.55.2
-- API reference: https://github.com/hyprwm/Hyprland/blob/v0.55.2/example/hyprland.lua
-- Real-world ref: https://github.com/fancypantalons/hyprland-config
-- Known bug worked around: https://github.com/hyprwm/Hyprland/discussions/14844
--   (hl.on("hyprland.start") leaks CAP_SYS_NICE/CAP_SETPCAP to children on
--   NixOS — sandboxed apps refuse to start. We strip caps via `setpriv`.)

------------------
---- MONITORS ----
------------------

-- Hardcoded because the Lua manager has no hl.source() for hyprlang
-- monitors.conf, so nwg-displays integration is bypassed.
hl.monitor({ output = "desc:Samsung Electric Company LC27G7xT H4ZR601106", mode = "2560x1440@120", position = "0x0",    scale = "1", vrr = 1 })
hl.monitor({ output = "desc:Dell Inc. DELL G2722HS C3WW7P3",               mode = "1920x1080@60",  position = "2560x0", scale = "1", vrr = 1 })
-- JMGO projector explicitly disabled — it crashed the config when active
-- and gets picked up by the catch-all rule below otherwise.
hl.monitor({ output = "desc:JMG JMGO 0x00000001",                          disabled = true })
hl.monitor({ output = "",                                                  mode = "preferred",     position = "auto",   scale = "auto" })


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "ghostty"
local fileManager = "pcmanfm"
local menu        = "rofi -show drun"


-------------------
---- AUTOSTART ----
-------------------

-- setpriv strips inherited Linux capabilities so sandboxed children
-- (discord/electron, flatpak, steam) don't get bwrap rejection.
local function strip_caps(cmd)
    return "setpriv --ambient-caps -all -- " .. cmd
end

hl.on("hyprland.start", function()
    -- Import env vars into systemd user manager + dbus, then explicitly
    -- start graphical-session.target so unit-managed services
    -- (xdg-desktop-portal-hyprland, hyprshell, ...) can activate.
    -- Redundant with start-hyprland but harmless if it does the same.
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE")
    hl.exec_cmd("systemctl --user start graphical-session.target")

    -- User autostart script (dunst, hypridle, copyq, discord, wallpaper, ...).
    -- Wrapped to strip caps so discord/electron isn't broken by bwrap.
    hl.exec_cmd(strip_caps(os.getenv("HOME") .. "/.config/hypr/autostart.sh"))

    -- Start waybar + hyprshell directly. The home.nix systemd units exist
    -- but won't activate reliably if graphical-session.target setup races;
    -- starting them imperatively here is the simplest robust path.
    hl.exec_cmd(strip_caps("waybar"))
    hl.exec_cmd(strip_caps("hyprshell run"))
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE",   "24")
hl.env("HYPRCURSOR_SIZE","24")


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 20,
        border_size = 2,
        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = false,
        allow_tearing    = true,
        layout = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        dim_inactive = true,
        dim_strength = 0.05,
        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },
        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
        smart_split    = false,
        smart_resizing = true,
        force_split    = 0,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = false,
        enable_swallow          = false,
        swallow_regex           = "^(Alacritty|com\\.mitchellh\\.ghostty|foot)$",
    },

    cursor = {
        no_hardware_cursors = true,
        enable_hyprcursor   = true,
        no_break_fs_vrr     = true,
    },

    input = {
        kb_layout  = "fr",
        kb_variant = "",
        kb_model   = "pc105",
        kb_options = "caps:escape",
        kb_rules   = "",
        follow_mouse = 1,
        sensitivity  = 0,
        touchpad = {
            natural_scroll = false,
        },
    },
})


--------------------
---- ANIMATIONS ----
--------------------

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1} } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1} } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })


----------------
---- INPUT  ----
----------------

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + T",         hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q",         hl.dsp.window.close())
hl.bind(mainMod .. " + M",         hl.dsp.exit())
hl.bind(mainMod .. " + E",         hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V",         hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P",         hl.dsp.window.pseudo())
hl.bind(mainMod .. " + F",         hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))

hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("pkill hyprshell; hyprshell run"))

hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("copyq toggle"))

hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/wallpaper.sh"))

hl.bind(mainMod .. " + SHIFT + S",       hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | swappy -f -"))
hl.bind(mainMod .. " + SHIFT + ALT + S", hl.dsp.exec_cmd("grim - | swappy -f -"))
hl.bind(mainMod .. " + CTRL + S",        hl.dsp.exec_cmd("grimblast --notify copysave screen ~/Pictures/Screenshots/$(date +%Y%m%d-%H%M%S).png"))

hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- AZERTY top-row digit keys via raw keycodes.
-- Only 2 workspaces: one per active monitor (Samsung=1, Dell=2).
local wsKeycodes = { [1] = 10, [2] = 11 }
for ws, code in pairs(wsKeycodes) do
    hl.bind(mainMod .. " + code:" .. code,           hl.dsp.focus({ workspace = ws }))
    hl.bind(mainMod .. " + SHIFT + code:" .. code,   hl.dsp.window.move({ workspace = ws }))
end

hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


--------------------------------
---- WORKSPACES PER MONITOR ----
--------------------------------

hl.workspace_rule({ workspace = "1", persistent = true, monitor = "desc:Samsung Electric Company LC27G7xT H4ZR601106", default = true, layout = "master" })
hl.workspace_rule({ workspace = "2", persistent = true, monitor = "desc:Dell Inc. DELL G2722HS C3WW7P3" })
-- hl.workspace_rule({ workspace = "3", persistent = true, monitor = "desc:JMG JMGO 0x00000001" })


-----------------------------
---- GAMING WINDOW RULES ----
-----------------------------

hl.window_rule({
    name  = "steam-apps",
    match = { class = "^(steam_app_.*)$" },
    float    = true,
    no_blur  = true,
    no_shadow = true,
    border_size = 0,
    rounding = 0,
})

hl.window_rule({
    name  = "cs2",
    match = { class = "^(cs2)$" },
    float    = true,
    no_blur  = true,
    no_shadow = true,
    border_size = 0,
    rounding = 0,
})

hl.window_rule({
    name  = "battle-net",
    match = { title = "^(Battle.net)$" },
    float    = true,
    size     = "1200 800",
    center   = true,
    no_blur  = true,
    no_shadow = true,
    border_size = 0,
    rounding = 0,
})

hl.window_rule({
    name  = "starcraft-ii",
    match = { title = "^(StarCraft II)$" },
    float    = true,
    no_blur  = true,
    no_shadow = true,
    border_size = 0,
    rounding = 0,
})
