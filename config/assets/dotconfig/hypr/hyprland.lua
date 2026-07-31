-- #####################################################################################
-- Hyprland Lua config (replaces hyprland.conf).
-- The legacy .conf format is deprecated and its support is removed in Hyprland 0.57.
-- API reference: https://wiki.hypr.land/Configuring/Start/
-- #####################################################################################

-- Set programs that you use
local terminal    = "ghostty"
local fileManager = "dolphin"
local menu        = "trebuchet"

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({ output = "DP-1",     mode = "1920x1080@60", position = "0x0",    scale = 1 })
hl.monitor({ output = "HDMI-A-1", mode = "3440x1440@85", position = "1920x0", scale = 1 })
hl.monitor({ output = "DP-2",     mode = "3840x2160@59", position = "5360x0", scale = 1 })

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
-- Runs once at compositor start (equivalent to the old `exec-once`).
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Disable input method modules to fix dead key composition in GTK/Qt apps (e.g. Ghostty)
hl.env("GTK_IM_MODULE", "")
hl.env("QT_IM_MODULE", "")

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- See https://wiki.hypr.land/Configuring/Basics/Variables/
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

        -- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before enabling
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        -- See https://wiki.hypr.land/Configuring/Variables/#blur
        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    dwindle = {
        -- pseudotile was removed in Hyprland 0.55 (was a no-op)
        preserve_split = true, -- you probably want this
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = -1,   -- set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = false,
    },
})

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { { 0.23, 1 },    { 0.32, 1 }    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 }    } })
hl.curve("linear",         { type = "bezier", points = { { 0, 0 },       { 1, 1 }       } })
hl.curve("almostLinear",   { type = "bezier", points = { { 0.5, 0.5 },   { 0.75, 1 }    } })
hl.curve("quick",          { type = "bezier", points = { { 0.15, 0 },    { 0.1, 1 }     } })

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

------------------------------
---- WORKSPACE RULES ----
------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- Persistent workspaces, bound to monitors. Wrapped in pcall because the
-- `monitor`/`persistent` field names aren't part of the shipped example; if a
-- future build rejects one we skip that rule instead of aborting the whole config.
local function workspace_rule(rule)
    local ok, err = pcall(hl.workspace_rule, rule)
    if not ok then
        -- best-effort notice; pcalled so the handler itself can never abort the config
        pcall(hl.notification.create, { text = "hyprland.lua: workspace_rule skipped: " .. tostring(err), timeout = 5000 })
    end
end

for _, r in ipairs({
    { workspace = "1", monitor = "DP-1"     },
    { workspace = "2", monitor = "DP-1"     },
    { workspace = "3", monitor = "DP-1"     },
    { workspace = "4", monitor = "HDMI-A-1" },
    { workspace = "5", monitor = "HDMI-A-1" },
    { workspace = "6", monitor = "HDMI-A-1" },
    { workspace = "7", monitor = "DP-2"     },
    { workspace = "8", monitor = "DP-2"     },
    { workspace = "9", monitor = "DP-2"     },
}) do
    workspace_rule({ workspace = r.workspace, monitor = r.monitor, persistent = true })
end

---------------
---- INPUT ----
---------------

-- See https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity    = 0.5, -- -1.0 - 1.0, 0 means no modification
        natural_scroll = true,

        touchpad = {
            natural_scroll = true,
        },
    },
})

-- See https://wiki.hypr.land/Configuring/Basics/Gestures/
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})

---------------------
---- KEYBINDINGS ----
---------------------

-- See https://wiki.hypr.land/Configuring/Basics/Binds/
hl.bind(mainMod .. " + T",      hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M",      hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + F",      hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SPACE",  hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P",      hl.dsp.window.pseudo()) -- dwindle
hl.bind(mainMod .. " + J",      hl.dsp.layout("togglesplit")) -- dwindle only
hl.bind(mainMod .. " + L",      hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + V",      hl.dsp.exec_cmd("~/.local/bin/aplec"))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("command -v grimblast >/dev/null 2>&1 && grimblast copy area"))

-- Toggle pin (always-on-top) for the active window.
-- `pin` isn't in the shipped Lua example; use the verified `hyprctl` IPC name.
hl.bind(mainMod .. " + SHIFT + J", function() hl.exec_cmd("hyprctl dispatch pin") end)

-- Alt-Tab focus cycling (uses the verified `cyclenext` IPC dispatcher).
hl.bind("ALT + Tab",         function() hl.exec_cmd("hyprctl dispatch cyclenext") end)
hl.bind("ALT + SHIFT + Tab", function() hl.exec_cmd("hyprctl dispatch cyclenext prev") end)

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left"  }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up"    }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down"  }))

-- Switch workspaces / move active window with mainMod (+ SHIFT) + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,          hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,  hl.dsp.window.move({ workspace = i }))
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),  { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),       { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),      { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                   { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

---------------------------------
---- WINDOWS AND WORKSPACES ----
---------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})
