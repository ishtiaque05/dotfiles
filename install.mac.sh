#!/bin/bash

# Function to print messages
print_message() {
  echo -e "\n[INFO]: $1"
}

# Function to detect OS
detect_os() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
  else
    print_message "Unsupported OS: $OSTYPE"
    exit 1
  fi
  print_message "Detected OS: $OS"
}

# Function to install Homebrew on macOS
install_homebrew() {
  if ! command -v brew &> /dev/null; then
    print_message "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
      eval "$(/opt/homebrew/bin/brew shellenv)"
    else
      echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
      eval "$(/usr/local/bin/brew shellenv)"
    fi
    print_message "Homebrew has been installed."
  else
    print_message "Homebrew is already installed."
  fi
}

install_git_and_curl() {
  # Check if Git is installed
  if ! command -v git &> /dev/null; then
    print_message "Git is not installed. Installing Git..."
    brew install git
    print_message "Git has been installed."
  else
    print_message "Git is already installed."
  fi

  # Check if curl is installed
  if ! command -v curl &> /dev/null; then
    print_message "curl is not installed. Installing curl..."
    brew install curl
    print_message "curl has been installed."
  else
    print_message "curl is already installed."
  fi
}

install_zsh() {
  # Check if the current shell is Zsh
  if [[ "$SHELL" != *"zsh"* ]]; then
    print_message "Default shell is not Zsh. Installing Zsh..."

    # Install Zsh
    brew install zsh

    # Change the default shell to Zsh
    print_message "Changing default shell to Zsh..."
    chsh -s $(which zsh)

    print_message "Zsh has been installed and set as the default shell. Restart your computer now..."
  else
    print_message "Zsh is already the default shell."
  fi

  # Backup and replace .zshrc
  if [ -f "$HOME/.zshrc" ]; then
    if [ ! -f "$HOME/.zshrc.old.bak" ]; then
      print_message "Backing up existing .zshrc to .zshrc.old.bak..."
      mv "$HOME/.zshrc" "$HOME/.zshrc.old.bak"
    else
      print_message "Backup .zshrc.old.bak already exists. Skipping backup."
    fi
  fi

  print_message "Copying new .zshrc from current directory to home directory..."
  cp ./.zshrc "$HOME/.zshrc"
}

setup_nerd_font() {
  # Install MesloLGS Nerd Fonts
  print_message "Installing MesloLGS Nerd Fonts..."
  FONT_DIR="$HOME/Library/Fonts"
  mkdir -p "$FONT_DIR"
  curl -fLo "$FONT_DIR/MesloLGS NF Regular.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
  curl -fLo "$FONT_DIR/MesloLGS NF Bold.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
  curl -fLo "$FONT_DIR/MesloLGS NF Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
  curl -fLo "$FONT_DIR/MesloLGS NF Bold Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

  print_message "MesloLGS Nerd Fonts installed successfully."
}

install_wezterm() {
  # Install WezTerm
  if ! command -v wezterm &> /dev/null; then
    print_message "WezTerm is not installed. Installing WezTerm..."
    brew install --cask wezterm
    print_message "WezTerm has been installed."
  else
    print_message "WezTerm is already installed."
  fi

  # Copy wezterm.lua configuration if not exists
  WEZTERM_CONFIG="$HOME/.wezterm.lua"
  if [ ! -f "$WEZTERM_CONFIG" ]; then
    print_message "WezTerm configuration not found. Copying from current directory..."
    cp ./wezterm.lua "$WEZTERM_CONFIG"
    print_message "WezTerm configuration copied to $WEZTERM_CONFIG."
  else
    print_message "WezTerm configuration already exists at $WEZTERM_CONFIG."
  fi
}

install_powerlvl10k() {
  # Install Powerlevel10k theme manually
  if [ ! -d "$HOME/powerlevel10k" ]; then
    print_message "Installing Powerlevel10k theme manually..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    if ! grep -q "source ~/powerlevel10k/powerlevel10k.zsh-theme" ~/.zshrc; then
      echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
      print_message "Powerlevel10k theme added to ~/.zshrc."
    else
      print_message "Powerlevel10k theme already sourced in ~/.zshrc."
    fi
  else
    print_message "Powerlevel10k is already installed."
  fi
}

install_zsh_autosuggestions() {
  # Install Zsh Autosuggestions plugin manually
  if [ ! -d "$HOME/.zsh/zsh-autosuggestions" ]; then
    print_message "Installing Zsh Autosuggestions plugin manually..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
    if ! grep -q "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ~/.zshrc; then
      echo 'source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh' >>~/.zshrc
      print_message "Zsh Autosuggestions plugin added to ~/.zshrc."
    fi
  else
    print_message "Zsh Autosuggestions is already installed."
  fi
}

install_zsh_syntax_highlighting() {
  # Install Zsh Syntax Highlighting plugin manually
  if [ ! -d "$HOME/.zsh/zsh-syntax-highlighting" ]; then
    print_message "Installing Zsh Syntax Highlighting plugin manually..."
    git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
    if ! grep -q "source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ~/.zshrc; then
      echo 'source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >>~/.zshrc
      print_message "Zsh Syntax Highlighting plugin added to ~/.zshrc."
    fi
  else
    print_message "Zsh Syntax Highlighting is already installed."
  fi
}

install_eza() {
  if ! command -v eza &> /dev/null; then
    print_message "Installing eza (modern replacement for ls)..."
    brew install eza
    print_message "eza has been installed."
  else
    print_message "eza is already installed."
  fi
}

# Function to install zoxide
install_zoxide() {
  if ! command -v zoxide &> /dev/null; then
    print_message "Installing zoxide (modern replacement for cd)..."
    brew install zoxide
    print_message "zoxide has been installed."
  else
    print_message "zoxide is already installed."
  fi

  if ! grep -q "eval \"\$(zoxide init zsh)\"" ~/.zshrc; then
    echo 'eval "$(zoxide init zsh)"' >>~/.zshrc
    print_message "zoxide initialization added to ~/.zshrc."
  else
    print_message "zoxide initialization already present in ~/.zshrc."
  fi

  if ! grep -q "alias cd=\"z\"" ~/.zshrc; then
    echo 'alias cd="z"' >>~/.zshrc
    print_message "Alias for zoxide added to ~/.zshrc."
  else
    print_message "Alias for zoxide already present in ~/.zshrc."
  fi
}

# Function to install fzf
install_fzf() {
  if ! command -v fzf &> /dev/null; then
    print_message "Installing fzf (fuzzy finder)..."
    brew install fzf

    # Setup shell integration
    $(brew --prefix)/opt/fzf/install --all
    print_message "fzf has been installed."
  else
    print_message "fzf is already installed."
  fi
}

# Function to install bat
install_bat() {
  if ! command -v bat &> /dev/null; then
    print_message "Installing bat (modern replacement for cat)..."
    brew install bat
    print_message "bat has been installed."
  else
    print_message "bat is already installed."
  fi
}

# Function to install tldr
install_tldr() {
  if ! command -v tldr &> /dev/null; then
    print_message "Installing tldr (simplified man pages)..."
    brew install tldr
    print_message "tldr has been installed."
  else
    print_message "tldr is already installed."
  fi
}

# Detect OS and run appropriate functions
detect_os

# Only run for macOS
if [[ "$OS" != "macos" ]]; then
  print_message "This script is designed for macOS. Exiting..."
  exit 1
fi

# Install Homebrew first
install_homebrew

# Run all installations
install_git_and_curl
install_zsh
setup_nerd_font
install_wezterm
install_zsh_syntax_highlighting
install_zsh_autosuggestions
install_powerlvl10k
install_eza
install_bat
install_tldr
install_fzf
install_zoxide

print_message "Installation and configuration complete! Please restart your terminal if Zsh is not already active."
print_message "Make sure NERD FONT is selected is download correctly and selected in wezterm.lua"

# Prompt for manual Powerlevel10k configuration
if command -v zsh &> /dev/null && [ -d "$HOME/powerlevel10k" ]; then
  print_message "Launching Powerlevel10k configuration wizard..."
  zsh -ic "p10k configure"
else
  print_message "Powerlevel10k is not properly installed. Skipping configuration wizard."
fi

print_message "Don't forget to add tokyo-night bat theme. See here: https://www.josean.com/posts/7-amazing-cli-tools"