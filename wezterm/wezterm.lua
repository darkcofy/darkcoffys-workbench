-- ──────────────────────────────────────────────
-- darkcoffys-workbench :: WezTerm config
-- ──────────────────────────────────────────────
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ── Appearance ──
config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("JetBrains Mono", { weight = "Medium" })
config.font_size = 13.0
config.line_height = 1.15
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

-- ── Performance ──
config.front_end = "WebGpu"
config.animation_fps = 30
config.max_fps = 60

-- ── Scrollback ──
config.scrollback_lines = 10000

-- ── Keybindings ──
local act = wezterm.action

config.keys = {
    -- Splits
    { key = "d", mods = "CTRL|SHIFT",       action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "e", mods = "CTRL|SHIFT",       action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "w", mods = "CTRL|SHIFT",       action = act.CloseCurrentPane({ confirm = true }) },

    -- Pane navigation (Alt + vim keys)
    { key = "h", mods = "ALT",              action = act.ActivatePaneDirection("Left") },
    { key = "j", mods = "ALT",              action = act.ActivatePaneDirection("Down") },
    { key = "k", mods = "ALT",              action = act.ActivatePaneDirection("Up") },
    { key = "l", mods = "ALT",              action = act.ActivatePaneDirection("Right") },

    -- Pane resizing (Alt+Shift + vim keys)
    { key = "H", mods = "ALT|SHIFT",        action = act.AdjustPaneSize({ "Left", 3 }) },
    { key = "J", mods = "ALT|SHIFT",        action = act.AdjustPaneSize({ "Down", 3 }) },
    { key = "K", mods = "ALT|SHIFT",        action = act.AdjustPaneSize({ "Up", 3 }) },
    { key = "L", mods = "ALT|SHIFT",        action = act.AdjustPaneSize({ "Right", 3 }) },

    -- Tabs
    { key = "t", mods = "CTRL|SHIFT",       action = act.SpawnTab("CurrentPaneDomain") },
    { key = "[", mods = "CTRL|SHIFT",       action = act.ActivateTabRelative(-1) },
    { key = "]", mods = "CTRL|SHIFT",       action = act.ActivateTabRelative(1) },

    -- Font size
    { key = "=", mods = "CTRL",             action = act.IncreaseFontSize },
    { key = "-", mods = "CTRL",             action = act.DecreaseFontSize },
    { key = "0", mods = "CTRL",             action = act.ResetFontSize },
}

-- Quick tab switching with Ctrl+1..9
for i = 1, 9 do
    table.insert(config.keys, {
        key = tostring(i),
        mods = "CTRL",
        action = act.ActivateTab(i - 1),
    })
end

return config
