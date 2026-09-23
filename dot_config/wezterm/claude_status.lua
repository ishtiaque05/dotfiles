-- dot_config/wezterm/claude_status.lua
-- Shows Claude Code's state on the tab / pane running it.
--
--   waiting (needs your input) -> yellow   done -> green   error -> red
--
-- A tab takes the most urgent state of its panes (error > waiting > done).
-- When the tab is split, the pane itself is tinted too, so you can tell which
-- pane needs you. WezTerm has no per-pane border color, so the tint is a
-- change to the pane's background (OSC 11), undone with OSC 111.
--
-- States come from ~/.local/bin/claude-term-state (run by Claude Code hooks)
-- through two channels:
--   * a file ~/.local/state/claude-term-state/wezterm-<pane_id>, for local
--     panes. Polled on every update-status tick.
--   * the `claude_state` user var (OSC 1337), for panes where Claude runs over
--     SSH. Applied immediately via user-var-changed.
-- Both carry "<state> <epoch>"; the newer one wins.
local wezterm = require("wezterm")

local M = {}

local state_dir = wezterm.home_dir .. "/.local/state/claude-term-state/"

M.colors = {
  waiting = "#e0af68",
  done = "#9ece6a",
  error = "#f7768e",
}

-- The state color blended 15% into the Tokyo Night background (#1a1b26).
-- Visible at a glance, dark enough to keep text readable.
local tints = {
  waiting = "#383130",
  done = "#2e3630",
  error = "#3b2936",
}

local priority = { done = 1, waiting = 2, error = 3 }

local tab_states = {} -- tab_id  -> most urgent state among its panes
local applied_tint = {} -- pane_id -> state whose tint is on screen

local function parse(value)
  if not value then
    return nil, 0
  end
  local s, ts = value:match("^(%a+)%s+(%d+)")
  if s and priority[s] then
    return s, tonumber(ts)
  end
  return nil, 0
end

local function read_state(pane)
  local file_state, file_ts
  local f = io.open(state_dir .. "wezterm-" .. pane:pane_id(), "r")
  if f then
    file_state, file_ts = parse(f:read("*l"))
    f:close()
  else
    file_state, file_ts = nil, 0
  end

  local ok, vars = pcall(function()
    return pane:get_user_vars()
  end)
  local var_state, var_ts = parse(ok and vars and vars.claude_state or nil)

  if var_state and var_ts > file_ts then
    return var_state
  end
  return file_state
end

local function set_tint(pane, state)
  local id = pane:pane_id()
  if applied_tint[id] == state then
    return
  end
  local seq = state and ("\x1b]11;" .. tints[state] .. "\x1b\\") or "\x1b]111\x1b\\"
  -- inject_output only works on local panes; skip the rest silently.
  if pcall(function()
    pane:inject_output(seq)
  end) then
    applied_tint[id] = state
  end
end

-- Re-read every pane in the window. Cheap: one small file read per pane.
function M.refresh(window)
  local ok, mux_window = pcall(function()
    return window:mux_window()
  end)
  if not ok or not mux_window then
    return
  end

  for _, tab in ipairs(mux_window:tabs()) do
    local panes = tab:panes()
    local split = #panes > 1
    local worst = nil
    for _, pane in ipairs(panes) do
      local state = read_state(pane)
      if state and (not worst or priority[state] > priority[worst]) then
        worst = state
      end
      set_tint(pane, split and state or nil)
    end
    tab_states[tab:tab_id()] = worst
  end
end

-- State for format-tab-title. Reads the cache only, never the disk.
function M.tab_state(tab_id)
  return tab_states[tab_id]
end

function M.setup()
  wezterm.on("user-var-changed", function(window, pane, name, value)
    if name == "claude_state" then
      M.refresh(window)
    end
  end)
end

return M
