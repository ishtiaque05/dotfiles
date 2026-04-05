# devc — devcontainer detection hook and completions

# Hint when cd-ing into a devcontainer project
_devc_chpwd_hook() {
  [[ -f .devcontainer/devcontainer.json ]] || return
  local name
  name=$(jq -r '.name // "devcontainer"' .devcontainer/devcontainer.json 2>/dev/null) || return
  echo -e "\033[0;34m[devc]\033[0m $name detected.  \033[2mdevc up · devc session · devc status\033[0m"
}
autoload -Uz add-zsh-hook
add-zsh-hook chpwd _devc_chpwd_hook

# Tab completion
_devc() {
  local -a commands=(
    'up:Start devcontainer'
    'down:Stop containers'
    'attach:Shell into container'
    'exec:Run command in container'
    'logs:Tail container logs'
    'status:Show container status'
    'session:Create tmux session'
    'help:Show help'
  )
  _describe 'command' commands
}
compdef _devc devc
