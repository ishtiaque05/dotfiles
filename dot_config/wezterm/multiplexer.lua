-- dot_config/wezterm/multiplexer.lua
local M = {}

function M.apply(config)
  -- Status bar update interval (1 second). Drives the Claude Code tab/pane
  -- colors; the slower status segments throttle themselves to 5s.
  config.status_update_interval = 1000

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
