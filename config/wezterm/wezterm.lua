-- Import the wezterm module
local wezterm = require 'wezterm'
local mux = wezterm.mux

-- this is called by the mux server when it starts up.
-- It makes a window split top/bottom
wezterm.on('mux-startup', function()
  local tab, pane, window = mux.spawn_window {}
  local top_pane = pane:split { direction = 'Top' }
  pane:split({direction = 'Right'})
end)

local config = wezterm.config_builder()

config.color_scheme = "GruvboxDark"
config.window_decorations = 'RESIZE'
config.font = wezterm.font 'Inconsolata Nerd Font'
config.font_size = 14.0
config.keys = {
  -- Sends ESC + b and ESC + f sequence, which is used
  -- for telling your shell to jump back/forward.
  {
    key = 'LeftArrow',
    mods = 'OPT',
    action = wezterm.action.SendString '\x1bb',
  },
  {
    key = 'RightArrow',
    mods = 'OPT',
    action = wezterm.action.SendString '\x1bf',
  },
  {
    key = 'd',
    mods = 'CMD',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'd',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = '[',
    mods = 'CMD',
    action = wezterm.action.ActivatePaneDirection 'Prev',
  },
  {
    key = ']',
    mods = 'CMD',
    action = wezterm.action.ActivatePaneDirection 'Next',
  },
}
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = false
config.unix_domains = {
  {
    name = 'unix',
  },
}

-- This causes `wezterm` to act as though it was started as
-- `wezterm connect unix` by default, connecting to the unix
-- domain on startup.
-- If you prefer to connect manually, leave out this line.
config.default_gui_startup_args = { 'connect', 'unix' }

-- Returns our config to be evaluated. We must always do this at the bottom of this file
return config

