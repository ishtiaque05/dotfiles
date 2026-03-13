# Chezmoi Guide

[Chezmoi](https://www.chezmoi.io/) manages dotfiles by storing them in a source directory and applying them to your home directory. Files are renamed with prefixes that chezmoi interprets.

## How It Works

```
Source (this repo)              → Target ($HOME)
dot_zshrc.tmpl                  → ~/.zshrc
dot_aliases                     → ~/.aliases
dot_config/nvim/init.lua        → ~/.config/nvim/init.lua
dot_config/tmux/tmux.conf       → ~/.config/tmux/tmux.conf
```

**Naming rules:**
- `dot_` prefix → becomes `.` (dot_zshrc → .zshrc)
- `.tmpl` suffix → processed as Go template before applying
- `run_once_` prefix → script runs once (tracked by content hash)
- `run_before_` prefix → script runs before every `chezmoi apply`
- Files without `.tmpl` are copied as-is

## Common Commands

```bash
# Apply all configs
chezmoi apply

# Preview what would change
chezmoi diff

# Pull latest from git and apply
chezmoi update

# Add a new file to chezmoi management
chezmoi add ~/.config/newapp/config.yaml

# Edit a managed file (opens in chezmoi source dir)
chezmoi edit ~/.zshrc

# See which files chezmoi manages
chezmoi managed

# Run in verbose mode to see what's happening
chezmoi apply -v

# Force re-run of all scripts
chezmoi apply --force
```

## Script Execution Order

Scripts in `.chezmoiscripts/` run in alphabetical order within their type:

### `run_before_` — Runs Before Every Apply

| Script | Purpose |
|--------|---------|
| `run_before_backup-dotfiles.sh.tmpl` | Backs up existing configs to `~/.dotfiles-backup/` |

### `run_once_` — Runs Once (On Content Change)

These run in alphabetical order on first apply. If you modify the script content, chezmoi re-runs it.

| Script | Platform | Purpose |
|--------|----------|---------|
| `run_once_configure-git-delta.sh.tmpl` | Both | Configures delta as git pager |
| `run_once_install-fonts.sh.tmpl` | Both | Installs MesloLGS Nerd Font |
| `run_once_install-packages-linux.sh.tmpl` | Linux | Installs apt packages + custom tools |
| `run_once_install-packages-macos.sh.tmpl` | macOS | Installs Homebrew + Brewfile packages |
| `run_once_install-tpm.sh.tmpl` | Both | Clones Tmux Plugin Manager |
| `run_once_install-zsh-plugins.sh.tmpl` | Both | Installs p10k, autosuggestions, syntax highlighting |
| `run_once_z-install-bat-theme.sh.tmpl` | Both | Installs Tokyo Night theme for bat |

The `z-` prefix on the bat theme script ensures it runs last (after bat is installed).

## Go Templates

Files ending in `.tmpl` are processed as Go templates. This enables OS-conditional configs.

### OS Detection

```
{{- if eq .chezmoi.os "darwin" }}
# This only appears on macOS
{{- else if eq .chezmoi.os "linux" }}
# This only appears on Linux
{{- end }}
```

### Available Variables

| Variable | Example | Description |
|----------|---------|-------------|
| `.chezmoi.os` | `darwin`, `linux` | Operating system |
| `.chezmoi.arch` | `amd64`, `arm64` | CPU architecture |
| `.chezmoi.hostname` | `macbook-pro` | Machine hostname |
| `.chezmoi.username` | `syed` | Current user |

### Config Variables

Custom variables can be defined in `.chezmoi.toml.tmpl`:

```toml
[data]
    email = "you@example.com"
```

Then used in templates:

```
git config --global user.email "{{ .email }}"
```

## Idempotency

All scripts are idempotent — safe to run multiple times:

- Package installers check `command -v <tool>` before installing
- Git clones check if the directory exists first
- `run_once_` scripts only re-run when their content hash changes
- `run_before_` backup script skips if no files need backing up

To apply only new changes on an existing machine:

```bash
chezmoi apply
```

This will:
1. Back up existing configs (run_before)
2. Skip already-installed packages (run_once checks)
3. Only update files that differ from the source

## Backup and Rollback

Every `chezmoi apply` creates a timestamped backup:

```
~/.dotfiles-backup/
├── 2026-03-10_091500/     # oldest
├── 2026-03-11_143000/
├── 2026-03-12_091500/
├── 2026-03-12_143000/
└── 2026-03-12_170000/     # newest (keeps last 5)
```

Each backup contains copies of your config files at the time of apply.

### Restore a backup

```bash
# See available backups
ls -la ~/.dotfiles-backup/

# Restore specific files
cp ~/.dotfiles-backup/2026-03-12_143000/.zshrc ~/
cp ~/.dotfiles-backup/2026-03-12_143000/.aliases ~/
cp -r ~/.dotfiles-backup/2026-03-12_143000/nvim ~/.config/

# Or restore everything from a backup
cp ~/.dotfiles-backup/2026-03-12_143000/.* ~/
cp -r ~/.dotfiles-backup/2026-03-12_143000/nvim ~/.config/
cp -r ~/.dotfiles-backup/2026-03-12_143000/tmux ~/.config/
cp -r ~/.dotfiles-backup/2026-03-12_143000/wezterm ~/.config/
```

## .chezmoiignore

Files listed in `.chezmoiignore` exist in the repo but are NOT copied to `$HOME`:

```
README.md         # Documentation
*.md              # All markdown files
.git/             # Git directory
install.sh        # Legacy scripts
docker-tests/     # Testing infrastructure
```

## Adding New Configs

### Add a single file

```bash
# Add a file to chezmoi management
chezmoi add ~/.config/starship.toml

# This creates dot_config/starship.toml in the source directory
```

### Add with OS-specific template

```bash
# Add as template
chezmoi add --template ~/.config/app/config.toml

# Edit the template to add OS conditionals
chezmoi edit ~/.config/app/config.toml
```

### Add a new installation script

Create a file in `.chezmoiscripts/`:

```bash
# run_once_ = runs once per content change
# .sh.tmpl  = shell script with template support
touch .chezmoiscripts/run_once_install-newtool.sh.tmpl
```

Template structure:

```bash
#!/bin/bash
{{- if eq .chezmoi.os "linux" }}

if command -v newtool &> /dev/null; then
  echo "[INFO]: newtool already installed"
  exit 0
fi

echo "[INFO]: Installing newtool..."
# installation commands here

{{- end }}
```

## Adding New Packages

### macOS (Homebrew)

Edit `Brewfile.tmpl`:

```ruby
brew "ripgrep"     # Add a CLI tool
cask "firefox"     # Add a GUI application
```

### Linux

Edit `.chezmoiscripts/run_once_install-packages-linux.sh.tmpl`:

1. For apt packages: add to the `packages=()` array in `install_apt_packages()`
2. For custom installers: add a new `install_newtool()` function and call it in the main block
