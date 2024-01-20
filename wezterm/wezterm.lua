-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.hide_tab_bar_if_only_one_tab = true
config.color_scheme = 'Ayu Mirage'
config.font = wezterm.font 'JetBrainsMono Nerd Font'
config.window_background_opacity = 0.9
config.font_size = 14.0
config.initial_cols = 120
config.initial_rows = 30
-- This is where you actually apply your config choices
return config
