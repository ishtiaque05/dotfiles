# Quick Reference - Docker Testing

## Most Common Commands

```bash
# See all options
make help

# Get Zsh shell (auto-installs everything)
make zsh-linux-shell         # Linux (auto-install + Zsh)
make zsh-mac-shell           # Mac (auto-install + Zsh)

# Alternative names (same as above)
make apply-linux-config      # Same as zsh-linux-shell
make apply-mac-config        # Same as zsh-mac-shell

# Run automated tests
make test-linux              # Full test with validation
make test-mac                # Full test with validation

# Clean up everything
make clean
```

## Typical Workflow

### 1. Quick Start (Recommended)
```bash
make build              # Build images
make zsh-linux-shell    # Auto-install + interactive Zsh

# Inside container, test immediately:
cat ~/.aliases
ls -la
gs
```

### 2. Run Automated Tests
```bash
make test-linux     # Full test with validation
```

## Inside Container Commands

```bash
# Chezmoi is already initialized and applied!

# Check what's managed by Chezmoi
chezmoi managed

# See differences (if you make changes)
chezmoi diff

# Reapply dotfiles
chezmoi apply

# Verify installation
which zsh eza bat fzf zoxide
type cat          # Should be aliased to bat
alias | grep git  # See git aliases

# Check aliases file
cat ~/.aliases

# Run validation
bash ~/dotfiles-source/docker-tests/test-installation.sh

# Exit
exit
```

## Troubleshooting

```bash
# Clean and rebuild
make clean
make build

# Debug installation
make shell-linux
bash -x ./install.sh      # Verbose mode
```

## Container Details

**Credentials:**
- Username: `testuser`
- Password: `test` (if prompted)
- Sudo: Enabled (NOPASSWD)

**File Locations:**
- Dotfiles repo: `/home/testuser/dotfiles`
- User home: `/home/testuser`
- Installation script: `./install.sh` or `./install.mac.sh`
- Test script: `docker-tests/test-installation.sh`

## What Gets Tested

✓ Zsh installation and configuration
✓ Modern CLI tools (eza, bat, fzf, zoxide, tldr)
✓ Zsh plugins (powerlevel10k, autosuggestions, syntax-highlighting)
✓ Fonts (MesloLGS Nerd Font)
✓ WezTerm terminal
✓ Configuration files (.zshrc, .wezterm.lua)
