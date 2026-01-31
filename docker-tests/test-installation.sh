#!/bin/bash

# Test script to verify dotfiles installation
# Run this inside the Docker container after installation

set -e

echo "========================================"
echo "Testing Dotfiles Installation"
echo "========================================"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test function
test_command() {
  local cmd=$1
  local name=$2

  if command -v "$cmd" &> /dev/null; then
    echo -e "${GREEN}✓${NC} $name is installed"
    return 0
  else
    echo -e "${RED}✗${NC} $name is NOT installed"
    return 1
  fi
}

# Test file existence
test_file() {
  local file=$1
  local name=$2

  if [ -f "$file" ] || [ -d "$file" ]; then
    echo -e "${GREEN}✓${NC} $name exists at $file"
    return 0
  else
    echo -e "${RED}✗${NC} $name NOT found at $file"
    return 1
  fi
}

echo ""
echo "1. Testing Shell Environment"
echo "----------------------------"
test_command "zsh" "Zsh"
test_file "$HOME/.zshrc" ".zshrc config"

echo ""
echo "2. Testing Terminal Tools"
echo "-------------------------"
test_command "git" "Git"
test_command "curl" "curl"

echo ""
echo "3. Testing Modern CLI Tools"
echo "---------------------------"
test_command "eza" "eza (ls replacement)"
test_command "bat" "bat (cat replacement)" || test_command "batcat" "bat (as batcat)"
# Check fzf in both PATH and ~/.fzf/bin
if command -v fzf &> /dev/null || [ -f "$HOME/.fzf/bin/fzf" ]; then
  echo -e "${GREEN}✓${NC} fzf (fuzzy finder) is installed"
else
  echo -e "${RED}✗${NC} fzf (fuzzy finder) is NOT installed"
fi
test_command "zoxide" "zoxide (cd replacement)" || test_file "$HOME/.local/bin/zoxide" "zoxide"
test_command "tldr" "tldr (man pages)"

echo ""
echo "4. Testing Zsh Plugins"
echo "----------------------"
test_file "$HOME/powerlevel10k" "Powerlevel10k theme"
test_file "$HOME/.zsh/zsh-autosuggestions" "zsh-autosuggestions"
test_file "$HOME/.zsh/zsh-syntax-highlighting" "zsh-syntax-highlighting"

echo ""
echo "5. Testing Fonts"
echo "----------------"
if [ -d "$HOME/.local/share/fonts" ]; then
  test_file "$HOME/.local/share/fonts/MesloLGS NF Regular.ttf" "MesloLGS Nerd Font"
elif [ -d "$HOME/Library/Fonts" ]; then
  test_file "$HOME/Library/Fonts/MesloLGS NF Regular.ttf" "MesloLGS Nerd Font"
fi

echo ""
echo "6. Testing WezTerm"
echo "------------------"
test_command "wezterm" "WezTerm terminal"
test_file "$HOME/.config/wezterm/wezterm.lua" "WezTerm config"

echo ""
echo "7. Testing Bat Theme"
echo "--------------------"
if command -v bat &> /dev/null; then
  BAT_CMD="bat"
elif command -v batcat &> /dev/null; then
  BAT_CMD="batcat"
fi

if [ -n "$BAT_CMD" ]; then
  BAT_THEME_DIR="$($BAT_CMD --config-dir)/themes"
  test_file "$BAT_THEME_DIR/tokyonight_night.tmTheme" "Tokyo Night theme"

  if grep -q "export BAT_THEME=" ~/.zshrc; then
    echo -e "${GREEN}✓${NC} BAT_THEME configured in .zshrc"
  else
    echo -e "${YELLOW}!${NC} BAT_THEME not configured in .zshrc"
  fi
fi

echo ""
echo "========================================"
echo "Installation Test Complete"
echo "========================================"
