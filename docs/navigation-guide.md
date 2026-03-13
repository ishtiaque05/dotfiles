# Terminal Productivity Stack — Quick Reference

Everything uses the **Tokyo Night** theme for visual consistency across all tools.

## Architecture

```
WezTerm (GPU-rendered terminal, xterm-256color)
  └── tmux (Ctrl-a prefix, session persistence)
       ├── Window 1: nvim (LazyVim, Space leader)
       ├── Window 2: services (devcontainers)
       ├── Window 3: terminal (lazygit, shell)
       └── ...
```

## Quick Start

```bash
tmux                       # Start a tmux session
mux start thinkific        # Or launch full dev environment
tmux a                     # Reattach after closing terminal
```

---

## Tool Cheat Sheet

| Tool | Command | Purpose |
|------|---------|---------|
| WezTerm | Opens automatically | GPU-rendered terminal emulator |
| tmux | `tmux` / `tmux a` | Session multiplexer with persistence |
| tmuxinator | `mux start <project>` | One-command dev environment |
| Neovim | `nvim` / `vim` / `vi` | IDE-grade terminal editor |
| lazygit | `lg` | Terminal git UI |
| delta | automatic via `git diff` | Syntax-highlighted side-by-side diffs |
| fd | automatic via `Ctrl-T` | Fast file finding (powers fzf) |
| fzf | `Ctrl-T` / `Ctrl-R` | Fuzzy finder for files and history |
| bat | `cat <file>` (aliased) | Syntax-highlighted file viewer |
| eza | `ls` (aliased) | Modern ls with icons |
| zoxide | `cd` (aliased) | Smart directory jumping |

---

## tmux — Prefix: `Ctrl+a`

Press `Ctrl+a`, release, then press the command key.

### Panes

| Action | Keys |
|--------|------|
| Split horizontal | `Ctrl-a -` |
| Split vertical | `Ctrl-a \|` |
| Navigate panes | `Ctrl-a h/j/k/l` |
| Resize panes | `Ctrl-a H/J/K/L` (hold for repeat) |
| Zoom pane | `Ctrl-a z` |
| Close pane | `Ctrl-a x` |

### Windows

| Action | Keys |
|--------|------|
| New window | `Ctrl-a c` |
| Next/prev window | `Shift-Right / Shift-Left` |
| Jump to window N | `Ctrl-a 1-9` |
| Rename window | `Ctrl-a ,` |
| List all windows | `Ctrl-a w` |

### Sessions

| Action | Keys / Command |
|--------|---------------|
| Detach | `Ctrl-a d` |
| Reattach | `tmux a` |
| List sessions | `tmux ls` |
| New named session | `tmux new -s name` |
| Kill session | `tmux kill-session -t name` |

### Copy Mode (Vim-style)

| Action | Keys |
|--------|------|
| Enter copy mode | `Ctrl-a [` |
| Navigate | `h/j/k/l`, `w/b`, `Ctrl-u/d` |
| Start selection | `v` |
| Copy to clipboard | `y` |
| Search | `/` (forward), `?` (backward) |
| Exit | `q` or `Esc` |

### tmux Plugins

| Plugin | Purpose | Key |
|--------|---------|-----|
| tmux-resurrect | Save/restore sessions | `Ctrl-a Ctrl-s` save, `Ctrl-a Ctrl-r` restore |
| tmux-continuum | Auto-save every 15 min | automatic |
| tmux-yank | System clipboard copy | automatic (macOS + Linux) |
| tokyo-night-tmux | Status bar theme | automatic |
| Install plugins | After adding to config | `Ctrl-a I` (capital I) |

---

## Neovim (LazyVim) — Leader: `Space`

Press `Space` and wait for the which-key popup showing all available bindings.

### File Navigation

| Action | Keys | VS Code Equivalent |
|--------|------|-------------------|
| Find file | `Space f f` | `Cmd-P` |
| Grep project | `Space s g` | `Cmd-Shift-F` |
| File explorer | `Space e` | Sidebar |
| Recent files | `Space f r` | Recent |
| Find buffers | `Space f b` | Open editors |
| Search keymaps | `Space s k` | Keyboard shortcuts |
| Command palette | `Space Space` | `Cmd-Shift-P` |

### Code Navigation (LSP)

| Action | Keys |
|--------|------|
| Go to definition | `g d` |
| Find references | `g r` |
| Go to implementation | `g I` |
| Hover docs | `K` |
| Code actions | `Space c a` |
| Rename symbol | `Space c r` |
| Format | `Space c f` |
| Next/prev diagnostic | `] d` / `[ d` |

### Windows and Buffers

| Action | Keys |
|--------|------|
| Navigate splits | `Ctrl-h/j/k/l` |
| Next/prev buffer | `Shift-l / Shift-h` |
| Close buffer | `Space b d` |
| Split vertical | `Space s v` (custom) |
| Split horizontal | `Space s h` (custom) |
| Save | `Space w` |
| Quit | `Space q` |
| Resize splits | `Ctrl-Up/Down/Left/Right` |

### Editing

| Action | Keys |
|--------|------|
| Scroll down (centered) | `Ctrl-d` |
| Scroll up (centered) | `Ctrl-u` |
| Toggle comment | `gcc` (line) / `gc` (visual) |
| Indent/dedent (visual) | `>` / `<` (stays in visual mode) |
| Surround word | `ysiw)` (wrap with parens) |

### Git

| Action | Keys |
|--------|------|
| Open lazygit | `Space g g` |
| Blame line | `Space g b` |
| Blame file | `Space g B` |
| Next/prev hunk | `] h / [ h` |
| Git commits | `Space g c` |
| Git status | `Space g s` |

### Rails Shortcuts

| Action | Keys |
|--------|------|
| Open routes.rb | `Space r c` |
| Open Gemfile | `Space r g` |
| Open schema.rb | `Space r s` |

### Language Support (LSP via Mason)

Ruby, TypeScript/JavaScript, Python, Rust, GraphQL, JSON, YAML, Docker, Shell, ESLint, Prettier

### Useful Toggles

| Action | Keys |
|--------|------|
| Toggle auto-format | `Space u f` |
| Toggle spelling | `Space u s` |
| Toggle word wrap | `Space u w` |
| Toggle line numbers | `Space u l` |
| Open Lazy manager | `Space l` |

---

## Shell (Zsh)

### Key Bindings

| Action | Keys |
|--------|------|
| Fuzzy find files | `Ctrl-T` |
| Fuzzy search history | `Ctrl-R` |
| Smart cd | `cd <partial>` (zoxide) |
| Accept suggestion | `→` (right arrow) |

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
| `gco` | `git checkout` |
| `gcb` | `git checkout -b` |
| `gp` | `git push` |
| `gpl` | `git pull` |
| `glog` | `git log --oneline --graph --decorate --all` |
| `be` | `bundle exec` |
| `ber` | `bundle exec rspec` |
| `rc` | `rails console` |
| `rs` | `rails server` |

See `~/.aliases` for the full list.

---

## Daily Workflow

```
Morning:
  $ mux start thinkific      ← one command, full dev environment
  $ tmux                      ← or plain tmux session

During the day:
  Ctrl-a 1                    ← jump to editor window
  Ctrl-a 2                    ← check service logs
  Ctrl-a 5                    ← free terminal
  Space f f                   ← find file in nvim
  Space s g                   ← grep project in nvim
  Space g g                   ← open lazygit in nvim
  lg                          ← lazygit from any shell
  git diff                    ← auto-uses delta for pretty diffs
  Ctrl-a d                    ← detach (session persists!)
  tmux a                      ← reattach from anywhere

End of day:
  Close terminal              ← tmux sessions survive
  Next morning: tmux a        ← everything still there
```

---

## Installation

### macOS

```bash
chezmoi init --apply ishtiaque05/dotfiles
# Homebrew installs all tools via Brewfile
# Then: tmux → Ctrl-a I (install tmux plugins)
# Then: nvim (LazyVim auto-bootstraps on first open)
```

### Linux (Ubuntu/Debian)

```bash
chezmoi init --apply ishtiaque05/dotfiles
# apt + custom installers handle all tools
# Then: tmux → Ctrl-a I (install tmux plugins)
# Then: nvim (LazyVim auto-bootstraps on first open)
```

---

## Backup and Rollback

Every `chezmoi apply` automatically backs up configs to `~/.dotfiles-backup/` (keeps last 5).

```bash
# List backups
ls ~/.dotfiles-backup/

# Restore from a backup
cp ~/.dotfiles-backup/2026-03-12_143000/.zshrc ~/
cp -r ~/.dotfiles-backup/2026-03-12_143000/nvim ~/.config/
```

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Colors wrong in tmux | Ensure `$TERM` is `xterm-256color` in WezTerm |
| Neovim plugins broken | `rm -rf ~/.local/share/nvim/lazy ~/.cache/nvim` then reopen nvim |
| tmux plugins not loading | `Ctrl-a I` to install, or re-clone TPM |
| Copy not working in tmux | `Ctrl-a I` to install tmux-yank |
| fzf slow | Install `fd` — replaces the default `find` backend |
| LSP not working | `:Mason` in nvim to check/install language servers |
| tmux split not working | Two-step: press `Ctrl-a`, release, THEN press `-` or `\|` |

---

## File Locations

| Config | Path |
|--------|------|
| tmux | `~/.config/tmux/tmux.conf` |
| Neovim | `~/.config/nvim/` |
| WezTerm | `~/.config/wezterm/wezterm.lua` |
| Zsh | `~/.zshrc` |
| Aliases | `~/.aliases` |
| tmuxinator | `~/.config/tmuxinator/*.yml` |
| Git delta | `~/.gitconfig` (pager section) |
| Backups | `~/.dotfiles-backup/` |
