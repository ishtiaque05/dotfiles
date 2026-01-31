# Docker Testing Environment for Dotfiles

This directory contains Docker configurations for testing dotfiles installation on Linux and macOS-style environments.

## Overview

- `Dockerfile.linux` - Ubuntu 22.04 environment for testing Linux installation
- `Dockerfile.mac` - Ubuntu with Homebrew for testing macOS installation script
- `docker-compose.yml` - Orchestrates both test environments
- `test-installation.sh` - Validates installation success
- `../Makefile` - Easy commands for building, testing, and exploring

## Testing Procedure

### Prerequisites

Ensure Docker is installed and running:
```bash
docker --version
docker compose version
```

### Quick Test (Automated)

Run the full test suite with automated validation:

```bash
# Test Linux installation
make test-linux

# Test Mac installation
make test-mac

# Test both
make test
```

This will:
1. Build the Docker image
2. Run the installation script
3. Execute validation tests
4. Show which components installed successfully

### Manual Testing (Recommended for Development)

For manual exploration and verification:

#### 1. Build the Test Environment

```bash
# Build both images
make build

# Or build individually
make build-linux
make build-mac
```

#### 2. Start Interactive Shell

```bash
# Start Linux container
make shell-linux

# Or start Mac container
make shell-mac
```

#### 3. Inside the Container - Explore Installation

The container automatically runs `chezmoi init --apply` on startup. Once inside:

```bash
# Check your environment
whoami          # Should be: testuser
pwd             # Should be: /home/testuser
ls -la          # See your home directory with dotfiles applied

# Check what Chezmoi managed
chezmoi managed

# See the source dotfiles
ls ~/dotfiles-source

# Reapply dotfiles if needed
chezmoi apply

# See what would change
chezmoi diff
```

**Note**: Chezmoi is already initialized and applied. You're exploring the result!

#### 4. Verify Installation

After installation completes, verify manually:

```bash
# Check if tools are installed
which zsh
which eza
which bat        # or batcat on Linux
which fzf
which zoxide
which wezterm

# Check configurations
ls -la ~/
cat ~/.zshrc
cat ~/.wezterm.lua

# Check Zsh plugins
ls -la ~/powerlevel10k
ls -la ~/.zsh/zsh-autosuggestions
ls -la ~/.zsh/zsh-syntax-highlighting

# Check fonts (Linux)
ls -la ~/.local/share/fonts/

# Check fonts (Mac)
ls -la ~/Library/Fonts/
```

#### 5. Run Validation Tests

Execute the automated test script:

```bash
bash docker-tests/test-installation.sh
```

This will check all components and show ✓ or ✗ for each.

#### 6. Exit Container

```bash
exit
```

### Alternative: Install and Explore

Run installation and automatically drop into shell for verification:

```bash
# Linux: installs and opens shell
make install-linux

# Mac: installs and opens shell
make install-mac
```

Inside the container, you can explore and run validation:
```bash
bash docker-tests/test-installation.sh
```

## What to Verify

When testing manually, check these key areas:

### Chezmoi Setup
- [ ] `chezmoi` command is available
- [ ] `chezmoi managed` shows all dotfiles
- [ ] Source directory at `~/dotfiles-source`

### Shell Environment
- [ ] Zsh is the default shell
- [ ] `.zshrc` file exists and is properly configured
- [ ] Powerlevel10k theme is installed
- [ ] Zsh plugins (autosuggestions, syntax-highlighting) are present

### Aliases
- [ ] `.aliases` file exists with all aliases
- [ ] Git aliases work (`gs`, `gco`, `gp`)
- [ ] Modern tool aliases work (`ls` = eza, `cat` = bat)
- [ ] Rails aliases present (if applicable)

### Modern CLI Tools
- [ ] `eza` (ls replacement)
- [ ] `bat` or `batcat` (cat replacement)
- [ ] `fzf` (fuzzy finder)
- [ ] `zoxide` (cd replacement)
- [ ] `tldr` (man pages)

### Terminal & Fonts
- [ ] WezTerm is installed
- [ ] `.wezterm.lua` configuration exists
- [ ] MesloLGS Nerd Fonts are installed

### Expected Installation Time
- **Linux**: ~3-6 minutes (Chezmoi + apt packages)
- **Mac**: ~8-15 minutes (Chezmoi + Homebrew overhead)

## Quick Start (Using Makefile - Recommended)

```bash
# See all available commands
make help

# Build both images
make build

# Get an interactive shell in Linux container
make shell-linux

# Get an interactive shell in Mac container
make shell-mac

# Run installation and stay in container for verification
make install-linux
make install-mac

# Run full test suite (install + validate)
make test-linux
make test-mac
```

## Manual Workflow

### Build and Run Both Environments

```bash
# From the docker-tests directory
cd docker-tests

# Build both images
docker-compose build

# Run Linux test
docker-compose run --rm linux-test

# Run Mac test
docker-compose run --rm mac-test
```

### Build Individual Environments

```bash
# Build Linux test image
docker build -f docker-tests/Dockerfile.linux -t dotfiles-test:linux .

# Build Mac test image
docker build -f docker-tests/Dockerfile.mac -t dotfiles-test:mac .
```

### Run Tests Interactively

```bash
# Start Linux container with shell
docker-compose run --rm linux-test bash

# Start Mac container with shell
docker-compose run --rm mac-test bash

# Inside the container, run the installation
./install.sh  # for Linux
# or
./install.mac.sh  # for Mac
```

### Validate Installation

After installation completes, run the test script:

```bash
# Inside the container
bash docker-tests/test-installation.sh
```

## Performance Comparison

To compare installation performance between Linux and Mac:

```bash
# Time the Linux installation
docker-compose run --rm linux-test bash -c "time ./install.sh"

# Time the Mac installation
docker-compose run --rm mac-test bash -c "eval \"\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\" && time ./install.mac.sh"
```

## Test Workflow

1. **Build the images** - `docker-compose build`
2. **Run installation** - `docker-compose run --rm linux-test`
3. **Validate results** - Run `test-installation.sh` inside container
4. **Compare performance** - Use `time` command to measure execution
5. **Iterate** - Modify scripts and rebuild to test changes

## Notes

### Linux Testing
- Uses Ubuntu 22.04 (matches common Linux distributions)
- Tests `install.sh` script
- Uses `apt` package manager
- Native Docker performance

### Mac Testing
- Uses Ubuntu with Homebrew (Linuxbrew)
- Tests `install.mac.sh` script
- Uses `brew` package manager
- Simulates macOS environment on Linux

### Docker on Mac Performance
Remember: Docker on Mac runs inside a VM (HyperKit/QEMU), so there's inherent overhead:
- File I/O is slower (especially with volume mounts)
- Network operations may be slower
- CPU performance is generally good

For true Mac performance testing, test on actual macOS hardware.

## Common Test Scenarios

### Scenario 1: Testing a Script Change

After modifying `install.sh` or `install.mac.sh`:

```bash
# Rebuild the image to include your changes
make build-linux

# Test interactively
make shell-linux

# Inside container, run the modified script
./install.sh

# Verify the changes worked
bash docker-tests/test-installation.sh
```

### Scenario 2: Comparing Linux vs Mac Installation

```bash
# Run both in sequence
make test-linux
make test-mac

# Compare the output and timing
```

### Scenario 3: Debugging Installation Failures

```bash
# Start interactive shell
make shell-linux

# Run installation with verbose output
bash -x ./install.sh

# Check specific component
which eza
apt list --installed | grep eza
```

### Scenario 4: Testing Individual Components

```bash
# Start shell
make shell-linux

# Test only specific functions from install.sh
# Source the script first
source ./install.sh

# Then run individual functions
install_eza
install_fzf
```

## Troubleshooting

### Permission Issues
If you get permission errors, rebuild the images:
```bash
make clean
make build
```

### Docker Compose Command Not Found
If you see "docker-compose: not found", you have Docker Compose v2:
```bash
# This is already configured in the Makefile
# Just use: make build
```

### Slow Builds
The Mac image takes longer because it installs Homebrew. This is normal.
- Linux build: ~1-2 minutes
- Mac build: ~5-8 minutes (includes Homebrew installation)

### Volume Mount Issues
If changes aren't reflected, rebuild without cache:
```bash
make clean
make build
```

### Installation Script Fails
If the installation script fails inside the container:

1. Check the error message
2. Run interactively to debug: `make shell-linux`
3. Run script step-by-step or with `bash -x ./install.sh`
4. Verify prerequisites are met

### Container Won't Start
```bash
# Clean everything and start fresh
make clean
docker system prune -a  # WARNING: removes all unused Docker data
make build
```

## Cleanup

Remove test containers and images:

```bash
# Stop and remove containers
docker-compose down

# Remove images
docker rmi dotfiles-test:linux dotfiles-test:mac

# Clean up everything
docker system prune -a
```
