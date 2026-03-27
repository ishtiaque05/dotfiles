-- dot_config/wezterm/multiplexer.lua
local M = {}

function M.apply(config)
  -- Status bar update interval (5 seconds)
  config.status_update_interval = 5000

  -- Scrollback
  config.scrollback_lines = 50000

  -- Default workspace name
  config.default_workspace = "main"

  -- Safe TERM value: works in containers and SSH
  config.term = "xterm-256color"

  -- Don't prompt when closing (tmux manages sessions)
  config.window_close_confirmation = "NeverPrompt"
end

return M
