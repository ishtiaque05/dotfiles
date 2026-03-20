-- dot_config/wezterm/status_bar.lua
local wezterm = require("wezterm")

local M = {}

-- Cache for git info per directory (updated by update-status, read by format-tab-title)
local git_cache = {}

-- Tokyo Night colors
local colors = {
  bg = "#16161e",
  fg = "#c0caf5",
  muted = "#545c7e",
  blue = "#7aa2f7",
  yellow = "#e0af68",
  green = "#9ece6a",
  red = "#f7768e",
  cyan = "#7dcfff",
  magenta = "#bb9af7",
}

-- Read a file's first line, return nil if not found
local function read_file(path)
  local f = io.open(path, "r")
  if not f then
    return nil
  end
  local content = f:read("*l")
  f:close()
  return content and content:match("^%s*(.-)%s*$") -- trim whitespace
end

-- Check if a directory exists
local function dir_exists(path)
  local f = io.open(path .. "/.", "r")
  if f then
    f:close()
    return true
  end
  return false
end

-- Get git branch and dirty status for a directory (runs git, so only call from update-status)
local function get_git_info(cwd)
  if not cwd then
    return nil
  end

  local branch_success, branch_stdout, branch_stderr =
    wezterm.run_child_process({ "git", "-C", cwd, "rev-parse", "--abbrev-ref", "HEAD" })
  if not branch_success then
    return nil
  end

  local branch = branch_stdout:match("^%s*(.-)%s*$")

  local dirty_success, dirty_stdout, dirty_stderr =
    wezterm.run_child_process({ "git", "-C", cwd, "status", "--porcelain", "--untracked-files=no" })
  local is_dirty = dirty_success and #dirty_stdout > 0

  return { branch = branch, dirty = is_dirty }
end

-- Get battery info (cross-platform)
local function get_battery()
  local is_macos = wezterm.target_triple:find("darwin") ~= nil

  if is_macos then
    local success, stdout, stderr = wezterm.run_child_process({ "pmset", "-g", "batt" })
    if success then
      local percent = stdout:match("(%d+)%%")
      if percent then
        return tonumber(percent)
      end
    end
  else
    local content = read_file("/sys/class/power_supply/BAT0/capacity")
    if content then
      return tonumber(content)
    end
  end
  return nil
end

-- Build a styled segment for the right status
local function segment(icon, text, color)
  return wezterm.format({
    { Foreground = { Color = color } },
    { Text = " " .. icon .. " " .. text .. " " },
  })
end

local function separator()
  return wezterm.format({
    { Foreground = { Color = colors.muted } },
    { Text = "│" },
  })
end

function M.setup(wezterm_mod)
  -- Status update interval: 5 seconds
  -- (balances responsiveness with I/O from reading version files)

  -- Right-side status dashboard
  wezterm_mod.on("update-status", function(window, pane)
    local cwd_uri = pane:get_current_working_dir()
    local cwd = nil
    if cwd_uri then
      cwd = cwd_uri.file_path
    end

    -- Update git cache for this directory
    if cwd then
      git_cache[cwd] = get_git_info(cwd)
    end

    local segments = {}

    if cwd then
      -- Ruby version
      local ruby_version = read_file(cwd .. "/.ruby-version")
      if ruby_version then
        table.insert(segments, segment(wezterm.nerdfonts.dev_ruby, ruby_version, colors.red))
      end

      -- Node version
      local node_version = read_file(cwd .. "/.node-version") or read_file(cwd .. "/.nvmrc")
      if node_version then
        table.insert(segments, segment(wezterm.nerdfonts.dev_nodejs_small, node_version, colors.green))
      end

      -- Python version
      local python_version = read_file(cwd .. "/.python-version")
      if python_version then
        table.insert(segments, segment(wezterm.nerdfonts.dev_python, python_version, colors.yellow))
      end

      -- Terraform
      if dir_exists(cwd .. "/.terraform") then
        local workspace = os.getenv("TF_WORKSPACE") or "default"
        table.insert(segments, segment("󱁢", workspace, colors.magenta))
      end
    end

    -- AWS profile
    local aws_profile = os.getenv("AWS_PROFILE")
    if aws_profile then
      table.insert(segments, segment("󰸏", aws_profile, colors.cyan))
    end

    -- Battery
    local battery = get_battery()
    if battery then
      local battery_color = battery < 20 and colors.red or colors.green
      local battery_icon = battery < 20 and wezterm.nerdfonts.fa_battery_quarter or wezterm.nerdfonts.fa_battery_full
      table.insert(segments, segment(battery_icon, battery .. "%", battery_color))
    end

    -- Time
    table.insert(segments, segment(wezterm.nerdfonts.fa_clock_o, os.date("%H:%M"), colors.blue))

    -- Join segments with separators
    local status_parts = {}
    for i, seg in ipairs(segments) do
      if i > 1 then
        table.insert(status_parts, separator())
      end
      table.insert(status_parts, seg)
    end

    window:set_right_status(table.concat(status_parts))
  end)

  -- Tab title formatting with git info
  wezterm_mod.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local pane = tab.active_pane
    local cwd_uri = pane.current_working_dir
    local cwd = nil
    local dir_name = "~"

    if cwd_uri then
      cwd = cwd_uri.file_path
      dir_name = cwd:match("([^/]+)/?$") or "~"
    end

    -- Use custom title if set (via rename), otherwise use dir name
    local title = tab.tab_title
    if not title or #title == 0 then
      title = dir_name
    end

    -- Git info from cache (never run git here — this must be fast)
    local git_info = cwd and git_cache[cwd] or nil
    local git_str = ""
    if git_info then
      git_str = "  " .. git_info.branch
      if git_info.dirty then
        git_str = git_str .. " ±"
      end
    end

    local tab_index = tab.tab_index + 1
    local tab_text = " " .. tab_index .. ": " .. title .. git_str .. " "

    if tab.is_active then
      return {
        { Text = " ❯" .. tab_text },
      }
    else
      return {
        { Text = "  " .. tab_text },
      }
    end
  end)
end

return M
