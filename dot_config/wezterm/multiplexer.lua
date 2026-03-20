-- dot_config/wezterm/multiplexer.lua
local M = {}

function M.apply(config)
  -- Status bar update interval (5 seconds)
  config.status_update_interval = 5000

  -- Scrollback
  config.scrollback_lines = 50000

  -- Default workspace name
  config.default_workspace = "main"
end

return M
