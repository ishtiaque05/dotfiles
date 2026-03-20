-- dot_config/wezterm/wezterm.lua
-- WezTerm productivity terminal configuration
-- Modules: appearance, keybindings, status_bar, multiplexer, helpers
local wezterm = require("wezterm")
local config = wezterm.config_builder()

require("appearance").apply(config)
require("keybindings").apply(config)
require("multiplexer").apply(config)
require("status_bar").setup(wezterm)

return config
