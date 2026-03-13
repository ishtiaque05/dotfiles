# Terminal Productivity Stack — Navigation Guide

Your complete terminal productivity environment. Everything uses the **tokyonight** theme for visual consistency.

## Architecture

```
Wezterm (terminal emulator)
  └── tmux (session multiplexer)
       ├── Window 1: nvim (editor)
       ├── Window 2: services
       ├── Window 3: terminal
       └── ...
```

## Quick Start

```bash
# Start tmux
tmux

# Or launch full dev environment (if tmuxinator configured)
mux start thinkific

# Reattach after closing terminal
tmux a
```

---

## Tool Overview

| Tool | Command | Purpose |
|------|---------|---------|
| Wezterm | Opens automatically | GPU-rendered terminal emulator |
| tmux | `tmux` / `tmux a` | Session multiplexer with persistence |
| tmuxinator | `mux start <project>` | One-command dev environment |
| Neovim | `nvim` / `vim` / `vi` | IDE-grade terminal editor |
| lazygit | `lg` | Terminal git UI |
| delta | automatic via `git diff` | Syntax-highlighted diffs |
| fd | automatic via `Ctrl-T` | Fast file finding |
| fzf | `Ctrl-T` / `Ctrl-R` | Fuzzy finder |
| bat | `cat <file>` (aliased) | Syntax-highlighted file viewer |
| eza | `ls` (aliased) | Modern ls with icons |
| zoxide | `cd` (aliased) | Smart directory jumping |

---

## tmux

**Prefix key: `Ctrl+a`** (press, release, then press the command key)

### Pane Management

| Action | Keys |
|--------|------|
| Split horizontal | `Ctrl-a -` |
| Split vertical | `Ctrl-a \|` |
| Navigate panes | `Ctrl-a h/j/k/l` |
| Resize panes | `Ctrl-a H/J/K/L` (repeatable) |
| Zoom pane (fullscreen) | `Ctrl-a z` |
| Close pane | `Ctrl-a x` |

### Window Management

| Action | Keys |
|--------|------|
| New window | `Ctrl-a c` |
| Next/prev window | `Shift-Right / Shift-Left` |
| Jump to window N | `Ctrl-a 1-9` |
| Rename window | `Ctrl-a ,` |
| List windows | `Ctrl-a w` |

### Session Management

| Action | Keys / Command |
|--------|---------------|
| Detach | `Ctrl-a d` |
| Reattach | `tmux a` |
| List sessions | `tmux ls` |
| New named session | `tmux new -s name` |

### Copy Mode (Vim-style)

| Action | Keys |
|--------|------|
| Enter copy mode | `Ctrl-a [` |
| Navigate | `h/j/k/l`, `w/b`, `Ctrl-u/d` |
| Start selection | `v` |
| Copy to clipboard | `y` |
| Search forward | `/` |
| Exit copy mode | `q` or `Esc` |

### Plugins

| Plugin | What it does |
|--------|-------------|
| tmux-sensible | Community sane defaults |
| tmux-resurrect | Save/restore sessions across reboots (`Ctrl-a Ctrl-s` save, `Ctrl-a Ctrl-r` restore) |
| tmux-continuum | Auto-save every 15 minutes |
| tmux-yank | Copy to system clipboard (macOS + Linux) |
| tokyo-night-tmux | Status bar theme |

---

## Neovim (LazyVim)

**Leader key: `Space`** — press and wait for which-key popup

### File Navigation

| Action | Keys | VS Code |
|--------|------|---------|
| Find file | `Space f f` | `Cmd-P` |
| Grep project | `Space s g` | `Cmd-Shift-F` |
| File explorer | `Space e` | Sidebar |
| Recent files | `Space f r` | Recent |
| Find buffers | `Space f b` | Open editors |

### Code Navigation (LSP)

| Action | Keys | VS Code |
|--------|------|---------|
| Go to definition | `g d` | `F12` |
| Find references | `g r` | `Shift-F12` |
| Go to implementation | `g I` | |
| Hover docs | `K` | Hover |
| Code actions | `Space c a` | `Cmd-.` |
| Rename symbol | `Space c r` | `F2` |
| Format | `Space c f` | `Shift-Alt-F` |
| Next diagnostic | `] d` | |
| Prev diagnostic | `[ d` | |

### Window & Buffer

| Action | Keys |
|--------|------|
| Navigate splits | `Ctrl-h/j/k/l` |
| Next/prev buffer | `Shift-l / Shift-h` |
| Close buffer | `Space b d` |
| Save | `Space w` |
| Quit | `Space q` |

### Git

| Action | Keys |
|--------|------|
| Open lazygit | `Space g g` |
| Blame line | `Space g b` |
| Next/prev hunk | `] h / [ h` |
| Git commits | `Space g c` |

### Rails Shortcuts

| Action | Keys |
|--------|------|
| Open routes | `Space r c` |
| Open Gemfile | `Space r g` |
| Open schema | `Space r s` |

### Language Support

LSP servers auto-install via Mason for:
- Ruby (Solargraph/Ruby LSP)
- TypeScript/JavaScript (ts_ls)
- Python (pyright)
- Rust (rust-analyzer)
- GraphQL
- JSON, YAML, Docker
- ESLint, Prettier

### Tips

1. **Which-key**: Press `Space` and wait — shows all available keybindings
2. **Search keymaps**: `Space s k`
3. **Command palette**: `Space Space`
4. **Lazy plugin manager**: `Space l`
5. **Toggle features**: `Space u` prefix (format, spelling, line numbers, etc.)

---

## Shell (Zsh)

### Key Bindings

| Action | Keys |
|--------|------|
| Fuzzy find files | `Ctrl-T` |
| Fuzzy search history | `Ctrl-R` |
| Smart cd | `cd <partial>` (zoxide) |

### Aliases

| Alias | Command |
|-------|---------|
| `vim` / `vi` | `nvim` |
| `lg` | `lazygit` |
| `mux` | `tmuxinator` |
| `ls` | `eza --icons=always` |
| `cat` | `bat --paging=never` |
| `gs` | `git status` |
| `gd` | `git diff` |
| `glog` | `git log --oneline --graph --decorate --all` |

See `~/.aliases` for the full list.

---

## Daily Workflow

```
Morning:
  $ mux start thinkific     <- one command, full dev environment
  $ tmux                     <- or just a plain tmux session

During the day:
  Ctrl-a 1                   <- jump to editor window
  Ctrl-a 2                   <- check service logs
  Ctrl-a 5                   <- free terminal
  Space f f                  <- find file in nvim
  Space s g                  <- grep project in nvim
  Space g g                  <- open lazygit
  lg                         <- or lazygit from any shell
  Ctrl-a d                   <- detach (session persists)
  tmux a                     <- reattach from anywhere

End of day:
  Close terminal             <- tmux sessions persist
  Next morning: tmux a       <- everything still there
```

---

## Installation

### macOS
```bash
chezmoi init --apply <repo-url>
# Homebrew installs all tools via Brewfile
# Then open tmux and press Ctrl-a I to install tmux plugins
# Then open nvim to bootstrap LazyVim plugins
```

### Linux (Ubuntu/Debian)
```bash
chezmoi init --apply <repo-url>
# apt + custom installers handle all tools
# Then open tmux and press Ctrl-a I to install tmux plugins
# Then open nvim to bootstrap LazyVim plugins
```

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Colors look wrong in tmux | Ensure `$TERM` is `xterm-256color` outside tmux |
| Neovim plugins broken | `rm -rf ~/.local/share/nvim/lazy ~/.cache/nvim` then reopen nvim |
| tmux plugins not loading | Run `Ctrl-a I` to install, or re-clone TPM: `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm` |
| Copy not working in tmux | Ensure `tmux-yank` plugin is installed (`Ctrl-a I`) |
| fzf slow | Install `fd` — it replaces the default `find` backend |
| Neovim LSP not working | Open nvim, run `:Mason` to check/install language servers |

---

## File Locations

| Config | Path |
|--------|------|
| tmux | `~/.config/tmux/tmux.conf` (or `~/.tmux.conf`) |
| Neovim | `~/.config/nvim/` |
| Wezterm | `~/.config/wezterm/wezterm.lua` (or `~/.wezterm.lua`) |
| Zsh | `~/.zshrc` |
| Aliases | `~/.aliases` |
| tmuxinator projects | `~/.config/tmuxinator/*.yml` |
| Git delta | `~/.gitconfig` (pager section) |
