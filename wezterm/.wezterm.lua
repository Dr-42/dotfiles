-- Pull in the wezterm API
local wezterm = require 'wezterm'


local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'ayu'
config.font = wezterm.font 'JetBrainsMono NFM'
config.default_prog = { 'pwsh', '-NoLogo' }
config.hide_tab_bar_if_only_one_tab = true

-- and finally, return the configuration to wezterm
return config
