export PATH="/usr/local/bin:$PATH"

export AM_THEME=soft
export USE_NERD_FONT=1
export AM_SHOW_PROCESS_TIME=0
export AM_UPDATE_L_PROMPT=1
# export AM_INITIAL_LINE_FEED=2

export ZSH_COMMAND_TIME_MSG="\nExecution time: %s sec"
export ZSH_COMMAND_TIME_COLOR="229"

if [ -d ~/.zplug ]; then
  source ~/.zplug/init.zsh
  
  zplug "zsh-users/zsh-syntax-highlighting"
  zplug "zsh-users/zsh-completions"
  zplug "zsh-users/zsh-autosuggestions"
  zplug "zpm-zsh/autoenv"
  zplug "popstas/zsh-command-time"
  zplug 'wfxr/forgit', defer:1

  zplug "eendroroy/zsh-autoenv-templates-installer"
  zplug "eendroroy/zshPlugins"
  zplug "eendroroy/awesome-git"
  zplug "eendroroy/alien-minimal"

  # Plugins for mac only
  if [ "`uname`" = "Darwin" ]; then
    zplug "zsh-users/zsh-apple-touchbar"
  fi

  # Install plugins if there are plugins that have not been installed
  if ! zplug check --verbose; then
    zplug install
  fi
  zplug load
fi

export TMUX_POWERLINE_FLAG=on
export TMUX_POWERLINE_COMPACT_OTHER=on

export AUTOENV_IN_FILE='.env.in'
export AUTOENV_OUT_FILE='.env.out'


if [ -d ~/bin ]; then
  export PATH="$HOME/bin:$PATH"
fi

export HISTFILE=~/.zsh_history
export HISTSIZE=10000000
export SAVEHIST=10000000
which nvim > /dev/null && export EDITOR='nvim'

# rbenv
if [ -d $HOME/.rbenv ]; then
  export RBENV_ROOT="$HOME/.rbenv"
  export PATH="$RBENV_ROOT/bin:$PATH"
  eval "$(rbenv init -)"
fi

# pyenv
if [ -d $HOME/.pyenv ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

# nodenv
if [ -d $HOME/.nodenv ]; then
  export NODENV_ROOT="$HOME/.nodenv"
  export PATH="$NODENV_ROOT/bin:$PATH"
  eval "$(nodenv init -)"
fi

# goenv
if [ -d $HOME/.goenv ]; then
  export GOENV_ROOT="$HOME/.goenv"
  export PATH="$GOENV_ROOT/bin:$PATH"
  eval "$(goenv init -)"
fi

# go
export GOPATH="$HOME/gopath"
export PATH="$GOPATH/bin:$PATH"

# exenv
if [ -d $HOME/.exenv ]; then
  export EXENV_ROOT="$HOME/.exenv"
  export PATH="$EXENV_ROOT/bin:$PATH"
  eval "$(exenv init -)"
fi

# crenv
if [ -d $HOME/.crenv ]; then
  export CRENV_ROOT="$HOME/.crenv"
  export PATH="$CRENV_ROOT/bin:$PATH"
  eval "$(crenv init -)"
fi

# swiftenv
if [ -d $HOME/.swiftenv ]; then
    export SWIFTENV_ROOT="$HOME/.swiftenv"
    export PATH="$SWIFTENV_ROOT/bin:$PATH"
    eval "$(swiftenv init -)"
fi

# fasd
which fasd > /dev/null && eval "$(fasd --init auto)"

# thefuck
which thefuck > /dev/null && eval $(thefuck --alias)

# fzf:: fzf has go as dependency
export FZF_DEFAULT_OPTS='--height=40% --reverse --preview="head {}" --preview-window=up:30%'
export FZF_CTRL_R_OPTS='--height=40% --reverse --preview="head {}" --preview-window=up:30%'
export FZF_CTRL_T_OPTS='--height=40% --reverse --preview="head {}" --preview-window=up:30%'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Make zsh know about hosts already accessed by SSH
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

setopt sharehistory
setopt extendedhistory
setopt histreduceblanks
setopt histsavebycopy
setopt hist_ignore_all_dups
setopt appendhistory
# setopt login
setopt beep
setopt autocd
setopt autopushd
setopt pushdtohome
setopt pushdignoredups
setopt pushdsilent
setopt autolist
setopt aliases
# setopt printexitvalue
setopt notify

# sdkman
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

[ -f ~/.zshrc_local ] && source ~/.zshrc_local
[ -f ~/.zsh_keybinds ] && source ~/.zsh_keybinds
[ -f ~/.zsh_alias ] && source ~/.zsh_alias
[ -f ~/.zsh_function ] && source ~/.zsh_function

export PATH="/usr/local/sbin:$PATH"

# zsh-completion
export fpath=(/usr/local/share/zsh-completions $fpath)
export fpath=($HOME/.config/zsh/completions $fpath)
compinit
