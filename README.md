# Dotfiles

Cross-platform terminal productivity environment managed with [chezmoi](https://www.chezmoi.io/). One command sets up everything on macOS or Linux.

```
Wezterm (GPU-rendered terminal)
  └── tmux (session multiplexer, persists across reboots)
       ├── Window 1: Neovim (IDE-grade editor with LSP)
       ├── Window 2: services (devcontainers, servers)
       ├── Window 3: terminal (lazygit, shell)
       └── ...
```

**Theme:** Tokyo Night everywhere — Wezterm, tmux, Neovim, bat, delta.

## Quick Start

### One-Command Install

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ishtiaque05/dotfiles
```

This auto-detects your OS, installs all packages, applies configs, and sets up the full stack.

### Manual Install

```bash
# Install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)"

# Preview changes first
chezmoi init ishtiaque05/dotfiles
chezmoi diff

# Apply when ready
chezmoi apply
```

### Post-Install (both platforms)

```bash
# 1. Install tmux plugins
tmux                    # start tmux
# Press Ctrl-a I        # installs TPM plugins

# 2. Launch Neovim (plugins auto-install on first open)
nvim

# 3. Configure your prompt
p10k configure
```

## What's Included

### Terminal & Shell

| Tool | Purpose | Config |
|------|---------|--------|
| [WezTerm](https://wezfurlong.org/wezterm/) | GPU-rendered terminal emulator | `~/.config/wezterm/wezterm.lua` |
| [Zsh](https://www.zsh.org/) | Shell with completions and history | `~/.zshrc` |
| [Powerlevel10k](https://github.com/romkatv/powerlevel10k) | Fast, customizable prompt | `~/.p10k.zsh` |
| [MesloLGS NF](https://github.com/romkatv/powerlevel10k#fonts) | Nerd Font with icons | Auto-installed |

### Editor

| Tool | Purpose | Config |
|------|---------|--------|
| [Neovim](https://neovim.io/) + [LazyVim](https://www.lazyvim.org/) | IDE-grade terminal editor | `~/.config/nvim/` |
| [VSCode](https://code.visualstudio.com/) | GUI editor settings | `~/.config/Code/User/settings.json` |
| [EditorConfig](https://editorconfig.org/) | Cross-editor formatting | `~/.editorconfig` |

**Neovim LSP support:** Ruby, TypeScript, Python, Rust, GraphQL, JSON, YAML, Docker, Shell

### Multiplexer

| Tool | Purpose | Config |
|------|---------|--------|
| [tmux](https://github.com/tmux/tmux) | Terminal multiplexer with session persistence | `~/.config/tmux/tmux.conf` |
| [tmuxinator](https://github.com/tmuxinator/tmuxinator) | Declarative tmux session launcher | `~/.config/tmuxinator/*.yml` |

### Modern CLI Replacements

| Tool | Replaces | How it activates |
|------|----------|-----------------|
| [eza](https://github.com/eza-community/eza) | `ls` | Aliased: `ls` runs `eza --icons=always` |
| [bat](https://github.com/sharkdp/bat) | `cat` | Aliased: `cat` runs `bat --paging=never` |
| [fd](https://github.com/sharkdp/fd) | `find` | Auto-used by fzf and Telescope as backend |
| [fzf](https://github.com/junegunn/fzf) | history search | `Ctrl-R` (history), `Ctrl-T` (files) |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | `cd` | Aliased: `cd` uses smart directory jumping |
| [lazygit](https://github.com/jesseduffield/lazygit) | `git` CLI | Alias: `lg` opens terminal git UI |
| [git-delta](https://github.com/dandavison/delta) | `diff` | Auto-configured as `git diff` pager |
| [tldr](https://github.com/tldr-pages/tldr) | `man` | `tldr <command>` for simplified help |

### Shell Aliases

```bash
# Git
gs, ga, gco, gcb, gp, gpl, gd, glog, gst, gstp, gundo

# Rails
rc, rs, rr, rdm, rdr, be, ber, berc

# Tools
vim/vi → nvim    lg → lazygit    mux → tmuxinator
ls → eza         cat → bat       cd → zoxide
```

See [`~/.aliases`](dot_aliases) for the full list.

## Updating

```bash
# Pull latest and apply
chezmoi update

# Or apply changes only (no git pull)
chezmoi apply
```

Every `chezmoi apply` automatically backs up your existing configs to `~/.dotfiles-backup/` (keeps last 5).

## Rollback

```bash
# List available backups
ls ~/.dotfiles-backup/

# Restore a specific backup
cp ~/.dotfiles-backup/2026-03-12_143000/.zshrc ~/
cp -r ~/.dotfiles-backup/2026-03-12_143000/nvim ~/.config/
```

## Project Structure

```
dotfiles/
├── .chezmoi.toml.tmpl              # Chezmoi config (variables, diff, merge tools)
├── .chezmoiignore                  # Files excluded from $HOME (docs, scripts)
├── .chezmoiscripts/
│   ├── run_before_backup-dotfiles.sh.tmpl  # Backup before every apply
│   ├── run_once_install-packages-macos.sh.tmpl  # Homebrew + Brewfile
│   ├── run_once_install-packages-linux.sh.tmpl  # apt + custom installers
│   ├── run_once_install-fonts.sh.tmpl           # MesloLGS Nerd Font
│   ├── run_once_install-zsh-plugins.sh.tmpl     # p10k, autosuggestions, highlighting
│   ├── run_once_install-tpm.sh.tmpl             # Tmux Plugin Manager
│   ├── run_once_configure-git-delta.sh.tmpl     # Delta as git pager
│   └── run_once_z-install-bat-theme.sh.tmpl     # Tokyo Night for bat
├── Brewfile.tmpl                   # macOS Homebrew packages
├── dot_zshrc.tmpl                  # Zsh config (OS-conditional)
├── dot_aliases                     # Shell aliases
├── dot_editorconfig                # Cross-editor formatting rules
├── dot_p10k-overrides.zsh          # Powerlevel10k custom overrides
├── dot_config/
│   ├── nvim/                       # Neovim/LazyVim configuration
│   │   ├── init.lua                # Plugin bootstrap + LazyVim extras
│   │   └── lua/
│   │       ├── config/
│   │       │   ├── options.lua     # Editor options (tabs, search, scroll)
│   │       │   ├── keymaps.lua     # Custom keybindings
│   │       │   └── autocmds.lua    # Auto-commands (yank highlight, etc.)
│   │       └── plugins/
│   │           └── example.lua     # Tokyo Night theme + GraphQL LSP
│   ├── tmux/
│   │   └── tmux.conf               # tmux config (prefix, splits, plugins)
│   ├── wezterm/
│   │   └── wezterm.lua             # WezTerm config (font, colors, term)
│   └── Code/User/
│       └── settings.json           # VSCode settings
├── docs/                           # Documentation
│   ├── chezmoi-guide.md            # How chezmoi works in this project
│   ├── cli-tools.md                # All CLI tools with usage examples
│   ├── navigation-guide.md         # Daily workflow quick reference
│   ├── neovim-keybindings.md       # Complete Neovim/LazyVim shortcuts
│   ├── tmux-keybindings.md         # Tmux commands and workflows
│   └── vscode-extensions.md        # VSCode extensions guide
└── docker-tests/                   # Docker-based testing
    ├── Dockerfile.linux
    ├── Dockerfile.mac
    └── test-installation.sh
```

## Platform Differences

| Feature | macOS | Linux (Ubuntu/Debian) |
|---------|-------|----------------------|
| Package manager | Homebrew (Brewfile) | apt + manual installers |
| Fonts directory | `~/Library/Fonts/` | `~/.local/share/fonts/` |
| bat binary | `bat` | `batcat` (symlinked to `bat`) |
| fd binary | `fd` | `fdfind` (symlinked to `fd`) |
| Directory colors | `LSCOLORS` / `CLICOLOR` | `dircolors` |
| Homebrew path | `/opt/homebrew` (ARM) or `/usr/local` (Intel) | N/A |

Chezmoi handles all of this automatically using Go templates:

```
{{- if eq .chezmoi.os "darwin" }}
# macOS-specific config
{{- else if eq .chezmoi.os "linux" }}
# Linux-specific config
{{- end }}
```

## Documentation

| Guide | What it covers |
|-------|---------------|
| [Chezmoi Guide](docs/chezmoi-guide.md) | How chezmoi works, adding files, scripts, templates |
| [CLI Tools](docs/cli-tools.md) | All CLI tools with usage examples |
| [Navigation Guide](docs/navigation-guide.md) | Daily workflow quick reference |
| [Neovim Keybindings](docs/neovim-keybindings.md) | Complete Neovim/LazyVim shortcuts |
| [Tmux Keybindings](docs/tmux-keybindings.md) | Tmux commands and workflows |
| [VSCode Extensions](docs/vscode-extensions.md) | Recommended VSCode extensions |

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Colors wrong in tmux | Ensure Wezterm `term = "xterm-256color"` and tmux has `set -g default-terminal "tmux-256color"` |
| Neovim plugins broken | `rm -rf ~/.local/share/nvim/lazy ~/.cache/nvim` then reopen nvim |
| tmux plugins not loading | Press `Ctrl-a I` to install, or `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm` |
| Copy not working in tmux | Install tmux-yank: `Ctrl-a I` |
| fzf is slow | Install `fd` — it replaces the default `find` backend |
| Neovim LSP not working | Open nvim, run `:Mason` to check/install language servers |
| `chezmoi` command not found | Add `export PATH="$HOME/.local/bin:$PATH"` to your shell |
| Scripts not executing | `chezmoi apply --force` to re-run |

## Testing with Docker

```bash
make test-linux    # Automated test in Linux container
make test-mac      # Automated test in macOS container
make shell-linux   # Interactive Linux shell
make shell-mac     # Interactive macOS shell
```

See [docker-tests/README.md](docker-tests/README.md) for details.

## License

MIT
