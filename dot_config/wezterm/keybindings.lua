-- dot_config/wezterm/keybindings.lua
local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

function M.apply(config)
  local is_macos = wezterm.target_triple:find("darwin") ~= nil

  -- Leader key: Cmd+. on macOS, Super+. on Linux
  config.leader = {
    key = ".",
    mods = is_macos and "CMD" or "SUPER",
    timeout_milliseconds = 1000,
  }

  config.keys = {
    -- === Pane Management ===

    -- Split right: Leader + |
    { key = "|", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    -- Split down: Leader + -
    { key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

    -- Navigate panes: Leader + h/j/k/l
    { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
    { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
    { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
    { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

    -- Resize panes: Leader + H/J/K/L (shift)
    { key = "H", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
    { key = "J", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
    { key = "K", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
    { key = "L", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },

    -- Zoom pane: Leader + z
    { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

    -- Close pane: Leader + x (matches tmux)
    { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },

    -- Swap pane: Leader + d (interactive pick)
    { key = "d", mods = "LEADER", action = act.PaneSelect({ mode = "SwapWithActive" }) },

    -- === Tab Management ===

    -- New tab: Leader + t
    { key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
    -- Next tab: Leader + n
    { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
    -- Previous tab: Leader + p
    { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
    -- Tab picker: Leader + w
    { key = "w", mods = "LEADER", action = act.ShowTabNavigator },

    -- Jump to tab by number: Leader + 1-9
    { key = "1", mods = "LEADER", action = act.ActivateTab(0) },
    { key = "2", mods = "LEADER", action = act.ActivateTab(1) },
    { key = "3", mods = "LEADER", action = act.ActivateTab(2) },
    { key = "4", mods = "LEADER", action = act.ActivateTab(3) },
    { key = "5", mods = "LEADER", action = act.ActivateTab(4) },
    { key = "6", mods = "LEADER", action = act.ActivateTab(5) },
    { key = "7", mods = "LEADER", action = act.ActivateTab(6) },
    { key = "8", mods = "LEADER", action = act.ActivateTab(7) },
    { key = "9", mods = "LEADER", action = act.ActivateTab(8) },

    -- Rename tab: Leader + ,
    {
      key = ",",
      mods = "LEADER",
      action = act.PromptInputLine({
        description = "Enter new tab name:",
        action = wezterm.action_callback(function(window, pane, line)
          if line then
            window:active_tab():set_title(line)
          end
        end),
      }),
    },

    -- === Workspace (Session) Management ===

    -- Workspace picker: Leader + s
    { key = "s", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "WORKSPACES" }) },

    -- Create new workspace: Leader + S
    {
      key = "S",
      mods = "LEADER|SHIFT",
      action = act.PromptInputLine({
        description = "Enter workspace name:",
        action = wezterm.action_callback(function(window, pane, line)
          if line then
            window:perform_action(act.SwitchToWorkspace({ name = line }), pane)
          end
        end),
      }),
    },

    -- Previous workspace: Leader + (
    { key = "(", mods = "LEADER|SHIFT", action = act.SwitchWorkspaceRelative(-1) },
    -- Next workspace: Leader + )
    { key = ")", mods = "LEADER|SHIFT", action = act.SwitchWorkspaceRelative(1) },

    -- === Utility ===

    -- Reload config: Leader + r
    { key = "r", mods = "LEADER", action = act.ReloadConfiguration },
    -- Search: Leader + f
    { key = "f", mods = "LEADER", action = act.Search({ CaseInSensitiveString = "" }) },
    -- Copy mode: Leader + c
    { key = "c", mods = "LEADER", action = act.ActivateCopyMode },
    -- Quick select: Leader + Space
    { key = " ", mods = "LEADER", action = act.QuickSelect },

    -- === No-Leader Shortcuts ===

    -- Fullscreen (macOS)
    { key = "Enter", mods = is_macos and "CMD" or "ALT", action = act.ToggleFullScreen },
  }

  -- Copy/Paste platform-specific
  if is_macos then
    table.insert(config.keys, { key = "c", mods = "CMD|SHIFT", action = act.CopyTo("Clipboard") })
    table.insert(config.keys, { key = "v", mods = "CMD|SHIFT", action = act.PasteFrom("Clipboard") })
  else
    table.insert(config.keys, { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") })
    table.insert(config.keys, { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") })
  end
end

return M
