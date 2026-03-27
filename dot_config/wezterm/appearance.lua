-- dot_config/wezterm/appearance.lua
local wezterm = require("wezterm")

local M = {}

function M.apply(config)
  local is_macos = wezterm.target_triple:find("darwin") ~= nil

  -- Font
  config.font = wezterm.font("MesloLGS NF")
  config.font_size = 13

  -- Window chrome
  config.window_decorations = "TITLE | RESIZE"
  config.window_padding = {
    left = 12,
    right = 12,
    top = 12,
    bottom = 12,
  }

  -- Tab bar
  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = false
  config.window_frame = {
    font = wezterm.font("MesloLGS NF"),
    font_size = 12,
  }

  -- Pane dimming
  config.inactive_pane_hsb = {
    saturation = 0.85,
    brightness = 0.85,
  }

  -- Platform-specific
  if is_macos then
    config.macos_window_background_blur = 20
  else
    config.window_background_opacity = 0.95
  end

  -- Tokyo Night color scheme
  config.colors = {
    foreground = "#c0caf5",
    background = "#1a1b26",
    cursor_bg = "#c0caf5",
    cursor_border = "#c0caf5",
    cursor_fg = "#1a1b26",
    selection_bg = "#283457",
    selection_fg = "#c0caf5",
    split = "#7aa2f7",
    compose_cursor = "#ff9e64",
    scrollbar_thumb = "#292e42",

    ansi = {
      "#15161e", -- black
      "#f7768e", -- red
      "#9ece6a", -- green
      "#e0af68", -- yellow
      "#7aa2f7", -- blue
      "#bb9af7", -- magenta
      "#7dcfff", -- cyan
      "#a9b1d6", -- white
    },
    brights = {
      "#414868", -- bright black
      "#ff899d", -- bright red
      "#9fe044", -- bright green
      "#faba4a", -- bright yellow
      "#8db0ff", -- bright blue
      "#c7a9ff", -- bright magenta
      "#a4daff", -- bright cyan
      "#c0caf5", -- bright white
    },

    tab_bar = {
      background = "#16161e",
      active_tab = {
        bg_color = "#7aa2f7",
        fg_color = "#16161e",
        intensity = "Bold",
      },
      inactive_tab = {
        bg_color = "#292e42",
        fg_color = "#545c7e",
      },
      inactive_tab_hover = {
        bg_color = "#292e42",
        fg_color = "#c0caf5",
        italic = true,
      },
      new_tab = {
        bg_color = "#16161e",
        fg_color = "#545c7e",
      },
      new_tab_hover = {
        bg_color = "#292e42",
        fg_color = "#c0caf5",
      },
      inactive_tab_edge = "#16161e",
    },
  }
end

return M
