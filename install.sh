#!/bin/bash

# Function to print messages
print_message() {
  echo -e "\n[INFO]: $1"
}

install_git_and_curl() {
  # Install essential packages
  print_message "Installing essential packages..."
  sudo apt update -y
  sudo apt install -y git curl wget gpg gnupg ca-certificates fontconfig

  if command -v git &> /dev/null && command -v curl &> /dev/null; then
    print_message "Essential packages installed."
  else
    print_message "Warning: Some packages may have failed to install."
  fi
}

install_zsh() {
  # Check if the current shell is Zsh
  if [[ "$SHELL" != *"zsh"* ]]; then
    print_message "Default shell is not Zsh. Installing Zsh..."

    # Update package list
    sudo apt update -y

    # Install Zsh
    sudo apt install zsh -y

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
  FONT_DIR="$HOME/.local/share/fonts"
  mkdir -p "$FONT_DIR"
  curl -fLo "$FONT_DIR/MesloLGS NF Regular.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
  curl -fLo "$FONT_DIR/MesloLGS NF Bold.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
  curl -fLo "$FONT_DIR/MesloLGS NF Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
  curl -fLo "$FONT_DIR/MesloLGS NF Bold Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

  # Refresh font cache
  fc-cache -fv
  print_message "MesloLGS Nerd Fonts installed successfully."
}

install_wezterm() {
    # Install WezTerm
  if ! command -v wezterm &> /dev/null; then
    print_message "WezTerm is not installed. Installing WezTerm..."
    print_message "Adding WezTerm repository and GPG key..."
    
    curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /etc/apt/keyrings/wezterm-fury.gpg
    echo 'deb [signed-by=/etc/apt/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list

    sudo apt update -y
    sudo apt install wezterm -y
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


print_message "Installation and configuration complete! Please restart your terminal if Zsh is not already active."

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
    sudo mkdir -p /etc/apt/keyrings

    # Add GPG key with proper error handling
    if wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg 2>/dev/null; then
      echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list > /dev/null
      sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
      sudo apt update 2>/dev/null
      sudo apt install -y eza
      print_message "eza has been installed."
    else
      print_message "Warning: Could not install eza from repository. Trying alternative method..."
      # Fallback: install from GitHub releases
      EZA_VERSION=$(curl -s "https://api.github.com/repos/eza-community/eza/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
      wget -q "https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz" -O /tmp/eza.tar.gz
      sudo tar -xzf /tmp/eza.tar.gz -C /usr/local/bin eza
      sudo chmod +x /usr/local/bin/eza
      rm /tmp/eza.tar.gz
      print_message "eza has been installed from GitHub releases."
    fi
  else
    print_message "eza is already installed."
  fi
}
  
# Function to install zoxide
install_zoxide() {
  if ! command -v zoxide &> /dev/null; then
    print_message "Installing zoxide (modern replacement for cd)..."
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
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
  if [ ! -d "$HOME/.fzf" ]; then
    print_message "Installing fzf (fuzzy finder)..."

    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
    print_message "fzf has been installed."
  else
    print_message "fzf is already installed."
  fi
}

# Function to install bat
install_bat() {
  if ! command -v bat &> /dev/null; then
    print_message "Installing bat (modern replacement for cat)..."
    sudo apt update -y
    sudo apt install -y bat
  else
    print_message "bat is already installed."
  fi

  # Check if the symlink exists before creating it
  if [ ! -L "$HOME/.local/bin/bat" ]; then
    mkdir -p ~/.local/bin
    ln -sf /usr/bin/batcat ~/.local/bin/bat
    print_message "Symlink for bat created: ~/.local/bin/bat -> /usr/bin/batcat"
  else
    print_message "Symlink for bat already exists."
  fi
}

# Function to install Tokyo Night theme for bat
install_bat_tokyo_night_theme() {
  BAT_THEME_DIR="$(batcat --config-dir)/themes"

  if [ ! -f "$BAT_THEME_DIR/tokyonight_night.tmTheme" ]; then
    print_message "Installing Tokyo Night theme for bat..."
    mkdir -p "$BAT_THEME_DIR"

    # Download Tokyo Night theme
    wget -q "https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/tokyonight_night.tmTheme" \
      -O "$BAT_THEME_DIR/tokyonight_night.tmTheme"

    # Rebuild bat cache
    batcat cache --build > /dev/null 2>&1

    # Add theme configuration to .zshrc if not already present
    if ! grep -q "export BAT_THEME=" ~/.zshrc; then
      echo 'export BAT_THEME="tokyonight_night"' >> ~/.zshrc
      print_message "Tokyo Night theme installed and set as default for bat."
    fi
  else
    print_message "Tokyo Night theme for bat is already installed."
  fi
}

# Function to install tldr
install_tldr() {
  if ! command -v tldr &> /dev/null; then
    print_message "Installing tldr (simplified man pages)..."
    sudo apt update -y
    sudo apt install -y tldr
    print_message "tldr has been installed."
  else
    print_message "tldr is already installed."
  fi
}


install_git_and_curl
install_zsh
setup_nerd_font
install_wezterm
install_zsh_syntax_highlighting
install_zsh_autosuggestions
install_powerlvl10k
install_eza
install_bat
install_bat_tokyo_night_theme
install_tldr
install_fzf
install_zoxide

print_message "Make sure NERD FONT is selected is download correctly and selected in wezterm.lua"
# Prompt for manual Powerlevel10k configuration
if command -v zsh &> /dev/null && [ -d "$HOME/powerlevel10k" ]; then
  print_message "Launching Powerlevel10k configuration wizard..."
  zsh -ic "p10k configure"
else
  print_message "Powerlevel10k is not properly installed. Skipping configuration wizard."
fi

print_message "Installation complete! Tokyo Night theme has been configured for bat."