# Dotfiles

Cross-platform dotfiles managed with [Chezmoi](https://www.chezmoi.io/) for automated setup on Linux and macOS.

## Quick Installation

### First Time Setup

Install dotfiles with a single command:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ishtiaque05/dotfiles
```

This will:
- Install Chezmoi
- Clone this repository
- Auto-detect your OS (Linux or macOS)
- Apply the appropriate configurations
- Run installation scripts

### Manual Installation

If you prefer to do it step by step:

```bash
# Install Chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)"

# Initialize with this repo
chezmoi init ishtiaque05/dotfiles

# Preview what will be changed
chezmoi diff

# Apply the dotfiles
chezmoi apply
```

## What's Included

### Terminal Setup
- **Shell**: Zsh with Powerlevel10k theme
- **Terminal**: WezTerm
- **Font**: MesloLGS Nerd Font

### Zsh Plugins
- zsh-autosuggestions
- zsh-syntax-highlighting

### Modern CLI Tools
- **eza**: Modern replacement for `ls`
- **bat**: Modern replacement for `cat`
- **fzf**: Fuzzy finder
- **zoxide**: Smarter `cd` command
- **tldr**: Simplified man pages

## Updating Dotfiles

Pull and apply the latest changes:

```bash
chezmoi update
```

## Managing Dotfiles

### Add a new dotfile

```bash
chezmoi add ~/.config/newfile
```

### Edit a dotfile

```bash
chezmoi edit ~/.zshrc
```

### See what would change

```bash
chezmoi diff
```

### Apply changes

```bash
chezmoi apply
```

## Structure

- `.chezmoi.toml.tmpl` - Chezmoi configuration
- `.chezmoiignore` - Files to ignore when applying
- `run_once_*.sh.tmpl` - Installation scripts (run once)
- `dot_*` - Dotfiles (renamed from `.filename`)

## Platform-Specific Configs

Chezmoi automatically detects your OS and applies the correct configuration:
- Linux: Uses `apt` package manager
- macOS: Uses Homebrew

Configuration files use Go templates with OS conditionals:
```
{{ if eq .chezmoi.os "darwin" }}
# macOS-specific config
{{ else if eq .chezmoi.os "linux" }}
# Linux-specific config
{{ end }}
```

## Manual Steps

Some configurations require manual setup after installation:

1. **Powerlevel10k Configuration**: Run `p10k configure` to customize your prompt
2. **WezTerm Font**: Verify MesloLGS NF is selected in WezTerm settings
3. **Bat Theme**: Optionally install Tokyo Night theme (see [this guide](https://www.josean.com/posts/7-amazing-cli-tools))

## Troubleshooting

### Chezmoi commands not working
Ensure `~/.local/bin` is in your PATH:
```bash
export PATH="$HOME/.local/bin:$PATH"
```

### Scripts not executing
Make sure scripts have executable permissions:
```bash
chezmoi apply --force
```

### See what Chezmoi is doing
Run commands in verbose mode:
```bash
chezmoi apply -v
```

## Development

### Current Status
🚧 Migration to Chezmoi in progress. See `.claude/plan.md` for details.

### Legacy Scripts
The old `install.sh` and `install.mac.sh` scripts are being phased out in favor of Chezmoi-managed installation.

## License

MIT
