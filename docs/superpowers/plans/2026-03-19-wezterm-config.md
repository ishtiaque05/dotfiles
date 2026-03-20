# WezTerm Productivity Terminal — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the minimal WezTerm config with a modular, cross-platform, Tokyo Night-themed productivity terminal with tmux-mirrored keybindings, a status dashboard, and content preview tools.

**Architecture:** Six Lua modules (appearance, keybindings, status_bar, multiplexer, helpers) loaded by `wezterm.lua` entry point using `config_builder()`. Shell-side preview function in `dot_aliases`. Tmux and fzf updated to match Tokyo Night palette.

**Tech Stack:** WezTerm Lua API, zsh shell functions, chezmoi dotfiles, Homebrew

**Spec:** `docs/superpowers/specs/2026-03-19-wezterm-config-design.md`

---

## File Map

| File | Action | Responsibility |
|------|--------|----------------|
| `dot_config/wezterm/wezterm.lua` | Rewrite | Entry point — requires modules, returns config |
| `dot_config/wezterm/appearance.lua` | Create | Tokyo Night colors, font, window chrome, platform-specific appearance |
| `dot_config/wezterm/keybindings.lua` | Create | Leader key, all pane/tab/workspace/utility bindings |
| `dot_config/wezterm/status_bar.lua` | Create | Right-side dashboard + tab title formatting with git info |
| `dot_config/wezterm/multiplexer.lua` | Create | Pane/tab/workspace defaults |
| `dot_config/wezterm/helpers.lua` | Create | WezTerm-side helper functions (eza split, etc.) |
| `dot_config/tmux/tmux.conf` | Modify | Remap `c` → `t`, update colors to Tokyo Night |
| `dot_zshrc.tmpl` | Modify | Update fzf colors to Tokyo Night |
| `dot_aliases` | Modify | Add `preview` shell function |
| `Brewfile.tmpl` | Modify | Add glow, w3m, poppler |

---

### Task 1: Create `appearance.lua` — Tokyo Night Theme

**Files:**
- Create: `dot_config/wezterm/appearance.lua`

- [ ] **Step 1: Create the appearance module with Tokyo Night colors and platform detection**

```lua
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
```

- [ ] **Step 2: Verify the file is syntactically valid**

Run: `lua -c "loadfile('dot_config/wezterm/appearance.lua')"`

If `lua` is not installed, skip — WezTerm will validate on load in Task 6.

- [ ] **Step 3: Commit**

```bash
git add dot_config/wezterm/appearance.lua
git commit -m "feat(wezterm): add Tokyo Night appearance module

Cross-platform theme with retro tab bar, pane dimming,
and macOS blur / Linux opacity support."
```

---

### Task 2: Create `keybindings.lua` — Leader Key + All Bindings

**Files:**
- Create: `dot_config/wezterm/keybindings.lua`

- [ ] **Step 1: Create the keybindings module with leader and all bindings**

```lua
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
```

- [ ] **Step 2: Commit**

```bash
git add dot_config/wezterm/keybindings.lua
git commit -m "feat(wezterm): add keybindings module with Cmd+. leader

Pane/tab/workspace management with mnemonic keys mirroring tmux.
Cross-platform leader: Cmd+. (macOS) / Super+. (Linux)."
```

---

### Task 3: Create `status_bar.lua` — Dashboard + Tab Titles

**Files:**
- Create: `dot_config/wezterm/status_bar.lua`

This is the most complex module. It registers two WezTerm events:
1. `update-status` — builds the right-side dashboard (runtime versions, AWS, battery, time)
2. `format-tab-title` — formats tab titles with git branch + dirty indicator

Git info is cached in a module-level table by `update-status` (which can run async) and read synchronously by `format-tab-title` to avoid blocking the GUI thread.

- [ ] **Step 1: Create the status bar module**

```lua
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
        table.insert(segments, segment("", ruby_version, colors.red))
      end

      -- Node version
      local node_version = read_file(cwd .. "/.node-version") or read_file(cwd .. "/.nvmrc")
      if node_version then
        table.insert(segments, segment("", node_version, colors.green))
      end

      -- Python version
      local python_version = read_file(cwd .. "/.python-version")
      if python_version then
        table.insert(segments, segment("", python_version, colors.yellow))
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
      local battery_icon = battery < 20 and "" or ""
      table.insert(segments, segment(battery_icon, battery .. "%", battery_color))
    end

    -- Time
    table.insert(segments, segment("", os.date("%H:%M"), colors.blue))

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
```

- [ ] **Step 2: Commit**

```bash
git add dot_config/wezterm/status_bar.lua
git commit -m "feat(wezterm): add status bar with runtime/git/battery dashboard

Shows ruby/node/python versions, AWS profile, terraform workspace,
battery, and time. Git branch + dirty cached async for tab titles."
```

---

### Task 4: Create `multiplexer.lua` and `helpers.lua`

**Files:**
- Create: `dot_config/wezterm/multiplexer.lua`
- Create: `dot_config/wezterm/helpers.lua`

- [ ] **Step 1: Create the multiplexer module**

```lua
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
```

- [ ] **Step 2: Create the helpers module**

```lua
-- dot_config/wezterm/helpers.lua
local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

-- Spawn a right-split pane with eza tree view of the current directory
-- Dismiss the eza pane with Leader+x (close pane)
function M.eza_tree_split()
  return wezterm.action_callback(function(window, pane)
    local cwd = pane:get_current_working_dir()
    local dir = cwd and cwd.file_path or wezterm.home_dir
    window:perform_action(
      act.SplitPane({
        direction = "Right",
        size = { Percent = 30 },
        command = {
          args = { "eza", "--tree", "--level=3", "--icons=always", "--git-ignore", dir },
        },
      }),
      pane
    )
  end)
end

return M
```

- [ ] **Step 3: Commit**

```bash
git add dot_config/wezterm/multiplexer.lua dot_config/wezterm/helpers.lua
git commit -m "feat(wezterm): add multiplexer config and helpers module

Multiplexer sets status interval, scrollback, default workspace.
Helpers provides eza tree split for Leader+e explore binding."
```

---

### Task 5: Wire `helpers.lua` into keybindings

**Files:**
- Modify: `dot_config/wezterm/keybindings.lua`

The `Leader + e` binding needs to call `helpers.eza_tree_split()`, which we created in Task 4.

- [ ] **Step 1: Add helpers require and eza binding to keybindings.lua**

At the top of `keybindings.lua`, after the `act` line, add:

```lua
local helpers = require("helpers")
```

In the `config.keys` table, inside the `-- === Utility ===` section, add after the QuickSelect line:

```lua
    -- Explore: Leader + e (eza tree in split)
    { key = "e", mods = "LEADER", action = helpers.eza_tree_split() },
```

- [ ] **Step 2: Commit**

```bash
git add dot_config/wezterm/keybindings.lua
git commit -m "feat(wezterm): wire eza tree explorer into Leader+e binding"
```

---

### Task 6: Rewrite `wezterm.lua` Entry Point

**Files:**
- Rewrite: `dot_config/wezterm/wezterm.lua`

- [ ] **Step 1: Replace the current wezterm.lua with the modular entry point**

```lua
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
```

- [ ] **Step 2: Test by opening WezTerm**

Open WezTerm. You should see:
- Tokyo Night dark theme (`#1a1b26` background)
- Retro tab bar with blue active tab
- Right-side status showing time (other segments show when relevant files exist)
- `Cmd+. |` should split right
- `Cmd+. -` should split down
- `Cmd+. h/j/k/l` should navigate panes
- `Cmd+. t` should create a new tab
- `Cmd+. z` should zoom a pane

If WezTerm shows errors, check the debug overlay: `Cmd+Shift+L` on macOS.

- [ ] **Step 3: Commit**

```bash
git add dot_config/wezterm/wezterm.lua
git commit -m "feat(wezterm): rewrite entry point to load modular config

Replaces minimal 22-line config with modular architecture:
appearance, keybindings, status_bar, multiplexer, helpers."
```

---

### Task 7: Update Tmux Config — Tokyo Night + Remap `t`

**Files:**
- Modify: `dot_config/tmux/tmux.conf`

- [ ] **Step 1: Remap new window from `c` to `t`**

In `dot_config/tmux/tmux.conf`, find:

```conf
bind c new-window -c "#{pane_current_path}"
```

Replace with:

```conf
bind t new-window -c "#{pane_current_path}"
```

- [ ] **Step 2: Update all status bar and pane colors to Tokyo Night**

Replace the entire `# Status Bar` section (lines 71-100) with:

```conf
# =========================
# Status Bar (Tokyo Night)
# =========================

# Status bar position
set -g status-position bottom

# Status bar colors
set -g status-style 'bg=#16161e fg=#c0caf5'

# Left status
set -g status-left-length 30
set -g status-left '#[fg=#7aa2f7,bold] #S #[fg=#545c7e]│ '

# Right status
set -g status-right-length 60
set -g status-right '#[fg=#545c7e]%Y-%m-%d #[fg=#7aa2f7,bold]%H:%M '

# Window status
setw -g window-status-current-style 'fg=#16161e bg=#7aa2f7 bold'
setw -g window-status-current-format ' #I:#W#F '
setw -g window-status-style 'fg=#545c7e bg=#292e42'
setw -g window-status-format ' #I:#W#F '

# Pane borders
set -g pane-border-style 'fg=#292e42'
set -g pane-active-border-style 'fg=#7aa2f7'

# Message style
set -g message-style 'fg=#16161e bg=#7aa2f7 bold'
```

- [ ] **Step 3: Commit**

```bash
git add dot_config/tmux/tmux.conf
git commit -m "feat(tmux): update to Tokyo Night theme and remap new window to prefix+t

Unifies color palette with WezTerm. Changes prefix+c to prefix+t
for new window to match WezTerm keybinding convention."
```

---

### Task 8: Update fzf Colors in `.zshrc` to Tokyo Night

**Files:**
- Modify: `dot_zshrc.tmpl`

- [ ] **Step 1: Replace fzf color variables**

In `dot_zshrc.tmpl`, find the FZF theme settings block (lines 95-103):

```bash
# FZF theme settings
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"
```

Replace with:

```bash
# FZF theme settings (Tokyo Night)
fg="#c0caf5"
bg="#1a1b26"
bg_highlight="#292e42"
purple="#bb9af7"
blue="#7aa2f7"
cyan="#7dcfff"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"
```

- [ ] **Step 2: Commit**

```bash
git add dot_zshrc.tmpl
git commit -m "feat(fzf): update theme colors to Tokyo Night

Unifies fzf with WezTerm and tmux color palette."
```

---

### Task 9: Add `preview` Shell Function to `dot_aliases`

**Files:**
- Modify: `dot_aliases`

- [ ] **Step 1: Add the preview function at the end of dot_aliases**

Append to `dot_aliases`:

```bash
# =========================
# Content Preview
# =========================

preview() {
  if [ -z "$1" ]; then
    echo "Usage: preview <file>"
    return 1
  fi

  if [ ! -e "$1" ]; then
    echo "File not found: $1"
    return 1
  fi

  local mime
  mime=$(file --mime-type -b "$1")

  case "$mime" in
    image/*)
      if command -v wezterm &>/dev/null; then
        wezterm imgcat "$1"
      else
        echo "[preview] Install wezterm for image preview"
      fi
      ;;
    application/pdf)
      if command -v pdftotext &>/dev/null && command -v bat &>/dev/null; then
        pdftotext "$1" - | bat --language=md --paging=never
      elif command -v pdftotext &>/dev/null; then
        pdftotext "$1" -
      else
        echo "[preview] Install poppler for PDF preview: brew install poppler"
      fi
      ;;
    text/markdown)
      if command -v glow &>/dev/null; then
        glow "$1"
      elif command -v bat &>/dev/null; then
        bat "$1"
      else
        cat "$1"
      fi
      ;;
    text/html)
      if command -v w3m &>/dev/null; then
        w3m "$1"
      elif command -v bat &>/dev/null; then
        bat "$1"
      else
        cat "$1"
      fi
      ;;
    *)
      if command -v bat &>/dev/null; then
        bat "$1"
      else
        cat "$1"
      fi
      ;;
  esac
}
```

- [ ] **Step 2: Commit**

```bash
git add dot_aliases
git commit -m "feat(shell): add preview function for images, PDFs, markdown, HTML

Auto-detects file type via mime and dispatches to wezterm imgcat,
pdftotext+bat, glow, or w3m. Falls back to bat/cat if tools missing."
```

---

### Task 10: Update Brewfile with New Dependencies

**Files:**
- Modify: `Brewfile.tmpl`

- [ ] **Step 1: Add glow, w3m, and poppler to the Modern CLI tools section**

In `Brewfile.tmpl`, after the `brew "tldr"` line, add:

```ruby
brew "glow"       # Terminal markdown renderer
brew "w3m"        # Terminal web browser
brew "poppler"    # PDF tools (provides pdftotext)
```

- [ ] **Step 2: Commit**

```bash
git add Brewfile.tmpl
git commit -m "feat(brew): add glow, w3m, poppler for content preview

Required by the preview shell function for rendering markdown,
web pages, and PDFs in the terminal."
```

---

### Task 11: End-to-End Verification

**Files:** None (testing only)

- [ ] **Step 1: Open WezTerm and verify appearance**

Verify:
- Background is dark navy `#1a1b26` (not the old `#011423`)
- Tab bar at top with Tokyo Night colors
- Font is MesloLGS NF at size 13
- Status bar on right shows at least the time

- [ ] **Step 2: Test pane keybindings**

1. `Cmd+. |` — should split right
2. `Cmd+. -` — should split down
3. `Cmd+. h` — should move to left pane
4. `Cmd+. l` — should move to right pane
5. `Cmd+. z` — should zoom current pane
6. `Cmd+. z` — should unzoom
7. `Cmd+. x` — should close pane with confirmation

- [ ] **Step 3: Test tab keybindings**

1. `Cmd+. t` — should create new tab
2. `Cmd+. n` — should go to next tab
3. `Cmd+. p` — should go to previous tab
4. `Cmd+. 1` — should jump to first tab
5. `Cmd+. ,` — should prompt for tab name
6. `Cmd+. w` — should show tab navigator

- [ ] **Step 4: Test workspace keybindings**

1. `Cmd+. S` — should prompt for workspace name (type "test")
2. `Cmd+. s` — should show workspace picker (should see "main" and "test")
3. Select "main" to switch back

- [ ] **Step 5: Test utility keybindings**

1. `Cmd+. f` — should open search
2. `Cmd+. c` — should enter copy mode (vim keys, `q` to exit)
3. `Cmd+. Space` — should highlight clickable items
4. `Cmd+. e` — should open eza tree in a right split
5. `Cmd+. x` — should close the eza pane (with confirmation)
6. `Cmd+. r` — should reload config (no visible change if config is valid)

- [ ] **Step 6: Test status bar in a project directory**

```bash
cd /path/to/a/rails/project  # or any project with .ruby-version
```

Verify the status bar updates to show the ruby version within ~5 seconds.

- [ ] **Step 7: Test preview function**

```bash
source ~/.aliases
preview docs/terminal-cheatsheet.md   # should render with glow
preview docs/superpowers/specs/2026-03-19-wezterm-config-design.md  # markdown
```

- [ ] **Step 8: Verify fzf Tokyo Night colors**

```bash
source ~/.zshrc
echo $FZF_DEFAULT_OPTS
```

Verify the output contains `bg:#1a1b26` and `hl:#bb9af7` (Tokyo Night values, not the old `#011628`/`#B388FF`). Optionally run `fzf` and visually confirm the dark navy background with purple highlights.

- [ ] **Step 9: Install new Brew dependencies**

```bash
brew bundle install --file=Brewfile.tmpl
```

Verify `glow`, `w3m`, and `pdftotext` are available:

```bash
command -v glow && command -v w3m && command -v pdftotext && echo "All preview tools installed"
```

- [ ] **Step 10: Test tmux changes**

```bash
tmux new -s test
# Verify Tokyo Night colors in status bar
# Press Ctrl+a then t — should create new window
# Press Ctrl+a then d — should detach
tmux kill-session -t test
```

- [ ] **Step 11: Final commit (if any test-driven fixes were made)**

```bash
git add -A
git commit -m "fix(wezterm): address issues found during end-to-end testing"
```

Only commit if fixes were needed. If everything passed, skip this step.
