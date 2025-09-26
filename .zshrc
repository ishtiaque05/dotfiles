# =========================
# Zsh Configuration
# =========================

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Initialize Zsh prompt

autoload -Uz promptinit
promptinit
prompt adam1

# =========================
# Prompt and Theme Settings (override above prompt to stop flickering)
# =========================

# powerlevel10k Theme
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Load Powerlevel10k overrides (custom settings)
[[ -f ~/.p10k-overrides.zsh ]] && source ~/.p10k-overrides.zsh

# =========================
# Command Line History
# =========================

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=$HOME/.zhistory

setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify
setopt histignorealldups

# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# =========================
# Zsh Completion System
# =========================

autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# =========================
# Plugins and Enhancements
# =========================

# Zsh Syntax Highlighting
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Zsh Autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# =========================
# Aliases and Tools: https://www.josean.com/posts/7-amazing-cli-tools
# =========================

# Eza (better ls)

alias ls="eza --icons=always"

# =========================
# Fuzzy Finder (FZF)
# =========================

# FZF theme settings
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"
export PATH="$HOME/.local/bin:$PATH"

# FZF keybindings and preview settings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# =========================
# Bat (Better `cat`)
# =========================

export BAT_THEME=tokyonight_night

# Zoxide (better cd)
eval "$(zoxide init zsh)"
alias cd="z"

# =========================
# Miscellaneous Settings
# =========================

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Modern directory colors
eval "$(dircolors -b)"