# WezTerm Productivity Terminal — Design Spec

**Date:** 2026-03-19
**Author:** Syed (staff software engineer)
**Status:** Draft

## Overview

A productivity-boosting WezTerm configuration for a staff engineer working across Ruby on Rails, TypeScript, React, Python, Node.js, AWS, Terraform, GraphQL, and Git. The config replaces the current minimal 22-line WezTerm setup with a modular, cross-platform (macOS + Linux), Tokyo Night-themed terminal that supports inline content rendering, a full status dashboard, and tmux-mirrored keybindings.

## Goals

1. **Unified dark theme** — Tokyo Night across WezTerm, tmux, fzf, bat
2. **Easy-to-remember keybindings** — `Cmd+.` leader with mnemonic action keys, mirroring tmux muscle memory
3. **Rich content preview** — Render PDFs, images, markdown, and web pages without leaving the terminal
4. **Status dashboard** — Git branch, runtime versions (ruby/node/python), AWS profile, Terraform workspace, battery, time
5. **Hybrid multiplexer** — WezTerm multiplexer for local work, tmux preserved for remote/SSH
6. **Cross-platform** — Works on macOS and Linux with graceful feature degradation

## Non-Goals

- Replacing tmux for remote sessions
- Full-fidelity web browsing in terminal (use a browser for that)
- Plugin manager or complex plugin ecosystem
- File manager TUI (just quick eza tree previews)

## File Structure

```
dot_config/wezterm/
├── wezterm.lua          # Entry point, requires all modules
├── appearance.lua       # Tokyo Night theme, font, window chrome
├── keybindings.lua      # Leader key + all bindings
├── status_bar.lua       # Tab bar + right-side status dashboard
├── multiplexer.lua      # Pane/tab/workspace config
└── helpers.lua          # WezTerm-side helper functions (eza split, etc.)
```

Additionally:
- `dot_aliases` — updated with `preview` shell function and content aliases
- `Brewfile.tmpl` — new dependencies (glow, w3m, poppler)
- `dot_zshrc.tmpl` — no changes needed (aliases file already sourced)
- `dot_config/tmux/tmux.conf` — remap `prefix + c` → `prefix + t`, update colors

Note: The `preview` command is a shell function defined in `dot_aliases`, not a Lua module. WezTerm Lua handles terminal-side concerns (appearance, keybindings, status bar). Shell-side concerns (content preview) live in shell config.

### Entry Point Pattern

`wezterm.lua` uses `config_builder()` (modern best practice — provides validation warnings for config key typos):

```lua
local wezterm = require("wezterm")
local config = wezterm.config_builder()

require("appearance").apply(config)
require("keybindings").apply(config)
require("status_bar").setup(wezterm)
require("multiplexer").apply(config)

return config
```

## Section 1: Tokyo Night Theme & Appearance

### Color Palette

| Role           | Hex       |
|----------------|-----------|
| Background     | `#1a1b26` |
| Foreground     | `#c0caf5` |
| Selection BG   | `#283457` |
| Selection FG   | `#c0caf5` |
| Cursor BG      | `#c0caf5` |
| Cursor FG      | `#1a1b26` |

### ANSI 16 Colors

| Color   | Normal    | Bright    |
|---------|-----------|-----------|
| Black   | `#15161e` | `#414868` |
| Red     | `#f7768e` | `#ff899d` |
| Green   | `#9ece6a` | `#9fe044` |
| Yellow  | `#e0af68` | `#faba4a` |
| Blue    | `#7aa2f7` | `#8db0ff` |
| Magenta | `#bb9af7` | `#c7a9ff` |
| Cyan    | `#7dcfff` | `#a4daff` |
| White   | `#a9b1d6` | `#c0caf5` |

### Additional Theme Colors

| Role              | Hex       | Usage                          |
|-------------------|-----------|--------------------------------|
| Split/pane border | `#7aa2f7` | Pane divider lines             |
| Compose cursor    | `#ff9e64` | IME composition cursor         |
| Scrollbar thumb   | `#292e42` | Scrollbar handle               |
| Tab bar BG        | `#16161e` | Tab bar background (retro)     |
| Active tab FG     | `#16161e` | Active tab text                |
| Active tab BG     | `#7aa2f7` | Active tab background          |
| Inactive tab FG   | `#545c7e` | Inactive tab text              |
| Inactive tab BG   | `#292e42` | Inactive tab background        |
| Inactive tab edge | `#16161e` | Border between inactive tabs   |

### Window Chrome

- **Font:** MesloLGS NF, size 13
- **Window padding:** 12px all sides
- **Tab bar:** Retro style (`use_fancy_tab_bar = false`) — required for full Tokyo Night `colors.tab_bar` theming. The `window_frame` font is set to MesloLGS NF to keep it consistent.
- **Inactive pane dimming:** 85% brightness
- **macOS:** `macos_window_background_blur = 20`
- **Linux:** `window_background_opacity = 0.95` (blur depends on compositor)

### Platform Detection

```lua
local is_macos = wezterm.target_triple:find("darwin") ~= nil
local is_linux = wezterm.target_triple:find("linux") ~= nil
```

### Theme Unification

Update these to Tokyo Night palette:
- tmux status bar: `#1a1b26` base, `#7aa2f7` accents
- fzf in `.zshrc`: match Tokyo Night colors
- bat: already `tokyonight_night` (no change)

## Section 2: Keybindings

### Leader Key

`Cmd+.` with 1-second timeout on macOS. On Linux, `Super+.` (WezTerm maps `Cmd` to `Super`). If `Super` is unavailable on the Linux desktop environment, fall back to `Ctrl+.`. After timeout, keypress passes through to the application.

```lua
local leader_key = is_macos and "." or "."
local leader_mod = is_macos and "CMD" or "SUPER"
-- Fallback for Linux without Super key can be configured by the user
```

### Pane Management

| Binding        | Action             | Mnemonic                     |
|----------------|--------------------|------------------------------|
| `Leader → \|`  | Split right        | Visual: vertical line        |
| `Leader → -`   | Split down         | Visual: horizontal line      |
| `Leader → h`   | Focus pane left    | Vim left                     |
| `Leader → j`   | Focus pane down    | Vim down                     |
| `Leader → k`   | Focus pane up      | Vim up                       |
| `Leader → l`   | Focus pane right   | Vim right                    |
| `Leader → H`   | Resize pane left   | Shift = resize               |
| `Leader → J`   | Resize pane down   | Shift = resize               |
| `Leader → K`   | Resize pane up     | Shift = resize               |
| `Leader → L`   | Resize pane right  | Shift = resize               |
| `Leader → z`   | Toggle zoom        | **z**oom                     |
| `Leader → x`   | Close pane (with confirm) | Matches tmux `prefix+x`. Uses `CloseCurrentPane { confirm = true }` |
| `Leader → d`   | Swap pane (interactive)   | Uses `PaneSelect { mode = 'SwapWithActive' }` — pick target pane visually |

### Tab Management

| Binding        | Action             | Mnemonic                     |
|----------------|--------------------|------------------------------|
| `Leader → t`   | New tab            | **t**ab                      |
| `Leader → n`   | Next tab           | **n**ext                     |
| `Leader → p`   | Previous tab       | **p**rev                     |
| `Leader → 1-9` | Jump to tab N      | Direct number                |
| `Leader → w`   | Tab picker (fuzzy) | **w**indow list              |
| `Leader → ,`   | Rename tab         | Matches tmux convention. Uses `PromptInputLine` with `action_callback` that calls `window:active_tab():set_title(line)` |

### Workspace (Session) Management

| Binding        | Action              | Mnemonic                    |
|----------------|---------------------|-----------------------------|
| `Leader → s`   | Workspace picker    | **s**ession                  |
| `Leader → S`   | Create new workspace| **S**ession new (capital)    |
| `Leader → (`   | Previous workspace  | Matches tmux                 |
| `Leader → )`   | Next workspace      | Matches tmux                 |

### Utility

| Binding          | Action             | Mnemonic                   |
|------------------|--------------------|-----------------------------|
| `Leader → r`     | Reload config      | **r**eload                  |
| `Leader → f`     | Search in pane     | **f**ind                    |
| `Leader → c`     | Copy mode (vim)    | **c**opy                    |
| `Leader → Space` | Quick select mode  | Space = action              |
| `Leader → e`     | Eza tree in split  | **e**xplore                 |

### No-Leader Shortcuts (High-Frequency)

| Binding          | Action          | Platform |
|------------------|-----------------|----------|
| `Cmd+Shift+c`   | Copy            | macOS    |
| `Cmd+Shift+v`   | Paste           | macOS    |
| `Ctrl+Shift+c`  | Copy            | Linux    |
| `Ctrl+Shift+v`  | Paste           | Linux    |
| `Cmd+Enter`     | Toggle fullscreen| macOS   |

## Section 3: Status Bar Dashboard

### Tab Format (Left)

```
 ❯ 1: dotfiles  master ±  │  2: myapp  main  │  3: infra  feat/vpc
```

- Active tab: `#7aa2f7` blue background, bold white text
- Inactive tabs: `#1a1b26` background, `#565f89` muted text
- Git dirty: `±` in yellow `#e0af68`

### Status Dashboard (Right)

```
  ruby 3.3.0  │   node 20.11  │  󰸏 us-east-1  │  85%  │  14:32
```

| Segment    | Icon | Source                              | Visibility              |
|------------|------|-------------------------------------|--------------------------|
| Ruby       | ``  | `.ruby-version` file                | When file exists in cwd  |
| Node       | ``  | `.node-version` or `.nvmrc` file    | When file exists in cwd  |
| Python     | ``  | `.python-version` file              | When file exists in cwd  |
| AWS        | `󰸏`  | `$AWS_PROFILE` env var              | When env var is set      |
| Terraform  | `󱁢`  | `.terraform/` dir presence          | When dir exists in cwd   |
| Battery    | ``  | `pmset` (mac) / sysfs (linux)       | Always (hidden on desktop)|
| Time       | —    | Clock                               | Always                   |

### Implementation

- Uses WezTerm `update-status` event with `config.status_update_interval = 5000` (5 seconds — balances responsiveness with I/O; default is 1s which is excessive for file reads)
- Runtime detection is file-based (reads `.ruby-version` etc.), not subprocess-based
- Git info (branch + dirty status) is cached in a module-level table by `update-status`, then read by `format-tab-title` synchronously to avoid blocking the GUI thread with `git` subprocess calls
- Battery: `pmset -g batt` on macOS, reads `/sys/class/power_supply/BAT0/capacity` on Linux (hidden if `/sys/class/power_supply/BAT0` does not exist — i.e., desktops/servers)

## Section 4: Content Rendering Tools

### `preview` Command

Auto-detects file type via `file --mime-type` and dispatches. Each tool is checked with `command -v` before use — if not installed, falls back to `bat` (or `cat` as last resort):

| File Type   | Tool                          | Command                                    |
|-------------|-------------------------------|--------------------------------------------|
| Image       | `wezterm imgcat`              | `wezterm imgcat <file>`                    |
| PDF         | `pdftotext` + `bat`           | `pdftotext <file> - \| bat --language=md`  |
| Markdown    | `glow`                        | `glow <file>`                              |
| HTML        | `w3m`                         | `w3m <file>`                               |
| Everything  | `bat`                         | `bat <file>` (fallback)                    |

### Directory Explorer

`Leader → e` spawns a right-split pane with:
```bash
eza --tree --level=3 --icons=always --git-ignore
```

Dismiss with `Leader → x` (close pane).

### New Brew Dependencies

| Tool      | Formula          | Purpose            |
|-----------|------------------|--------------------|
| `glow`    | `brew install glow`    | Markdown rendering |
| `w3m`     | `brew install w3m`     | Web page rendering |
| `poppler` | `brew install poppler` | Provides pdftotext |

## Section 5: Tmux Updates

Minimal changes to keep tmux in sync:

1. Remap `prefix + c` → `prefix + t` for new window (match WezTerm)
2. Update status bar colors to Tokyo Night palette
3. All other tmux keybindings remain unchanged

## Section 6: Cross-Platform Strategy

| Feature              | macOS                           | Linux                          |
|----------------------|---------------------------------|--------------------------------|
| Leader key           | `Cmd+.`                         | `Super+.` (fallback: `Ctrl+.`)|
| Background blur      | `macos_window_background_blur`  | `window_background_opacity`    |
| Tab bar style        | Retro (full theme control)      | Retro (full theme control)     |
| Battery              | `pmset -g batt`                 | sysfs `/sys/class/power_supply`|
| Copy shortcut        | `Cmd+Shift+c`                   | `Ctrl+Shift+c`                 |
| Paste shortcut       | `Cmd+Shift+v`                   | `Ctrl+Shift+v`                 |
| Fullscreen           | `Cmd+Enter`                     | (window manager dependent)     |
| Font install         | Brew Cask                       | Manual / distro package        |

Platform detection via `wezterm.target_triple` throughout all modules.
