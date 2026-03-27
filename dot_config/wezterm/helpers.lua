-- dot_config/wezterm/helpers.lua
local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

-- Spawn a right-split pane with eza tree view of the current directory
-- Dismiss the eza pane with Leader+x (close pane)
function M.eza_tree_split()
  return wezterm.action_callback(function(window, pane)
    local cwd = pane:get_current_working_dir()
    local dir = wezterm.home_dir
    if cwd then
      dir = cwd.file_path or wezterm.home_dir
    end
    window:perform_action(
      act.SplitPane({
        direction = "Right",
        size = { Percent = 30 },
        command = {
          args = { "zsh", "-lc", 'eza --tree --level=3 --icons=always --git-ignore "' .. dir .. '"; echo; read -r "?[Enter to close]"' },
          cwd = dir,
        },
      }),
      pane
    )
  end)
end

return M
