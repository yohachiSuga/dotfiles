-- Pull in the wezterm API
local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 12.0
config.use_ime = true
config.window_background_opacity = 0.90

-- disable tab bar 
config.hide_tab_bar_if_only_one_tab = true

-- conflict crtl-a 
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }

config.font = wezterm.font 'JetBrains Mono'

return config