# =========================
# fzf - fuzzy finder
# =========================
# Sourced from ~/.zshrc. Requires fzf >= 0.53 for `fzf --zsh` and `--tmux`.
# Enhanced by fd (fast walk), bat and eza (previews). All are optional.

# Guard on the binary, not on a generated file. The previous config keyed off
# `[ -f ~/.fzf.zsh ]`, which silently no-opped when that artifact was missing
# and left every setting below looking healthy while doing nothing.
command -v fzf >/dev/null || return 0

# =========================
# Search backend
# =========================
# fd honours .gitignore and skips .git, so it is far faster than find in large
# repos. Debian/Ubuntu ship the binary as `fdfind`; the installer symlinks it
# into ~/.local/bin as `fd`.

if command -v fd >/dev/null; then
  _fzf_files='fd --type=f --hidden --follow --exclude .git'
  _fzf_dirs='fd --type=d --hidden --follow --exclude .git'
else
  _fzf_files='find . -type f -not -path "*/.git/*" -printf "%P\n"'
  _fzf_dirs='find . -type d -not -path "*/.git/*" -printf "%P\n"'
fi

export FZF_DEFAULT_COMMAND=$_fzf_files
export FZF_CTRL_T_COMMAND=$_fzf_files
export FZF_ALT_C_COMMAND=$_fzf_dirs

# =========================
# Appearance (Tokyo Night)
# =========================
# The anonymous function scopes these locals. `fg` and `bg` are reserved by
# zsh's colors module as associative arrays, so they must not leak globally.

() {
  local fg='#c0caf5' bg_hl='#292e42' dim='#565f89'
  local purple='#bb9af7' blue='#7aa2f7' cyan='#7dcfff'

  export FZF_DEFAULT_OPTS="
    --height=60% --layout=reverse --border=rounded --info=inline-right
    --multi --cycle --scroll-off=3
    --prompt='  ' --pointer='▶' --marker='✓'
    --color=fg:${fg},bg:-1,hl:${purple}
    --color=fg+:${fg},bg+:${bg_hl},hl+:${purple}
    --color=info:${blue},prompt:${cyan},pointer:${cyan}
    --color=marker:${cyan},spinner:${cyan},header:${cyan},border:${dim}
    --bind='ctrl-/:toggle-preview'
    --bind='alt-a:toggle-all'
    --bind='alt-w:toggle-preview-wrap'
  "
}

# Render inside a tmux popup when in tmux; the flag is a no-op elsewhere.
[[ -n $TMUX ]] && FZF_DEFAULT_OPTS+=" --tmux center,80%,70%"

# =========================
# Previews
# =========================

_fzf_preview='if [ -d {} ]; then eza --tree --level=2 --color=always --icons=always {} | head -200;
              else bat --style=numbers --color=always --line-range=:500 {}; fi'

export FZF_CTRL_T_OPTS="--preview '$_fzf_preview' --preview-window 'right,60%,border-left'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always --icons=always {} | head -200'"

# Field 1 of a history line is the entry number, so {2..} is the command text.
# Long commands are truncated in the list; the preview shows them in full.
export FZF_CTRL_R_OPTS="--preview 'echo {2..}' --preview-window 'down,3,wrap,border-top' --header 'ctrl-/: toggle preview'"

# =========================
# Completion (**<TAB>)
# =========================
# The first argument is the command being completed; the rest go to fzf.

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --level=2 --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview 'eval "echo \$"{}'                                   "$@" ;;
    ssh)          fzf --preview 'dig +short {}'                                      "$@" ;;
    *)            fzf --preview "$_fzf_preview"                                      "$@" ;;
  esac
}

# =========================
# Shell integration
# =========================
# Generates key bindings and completion from the binary itself, so they cannot
# drift out of sync with the installed version. Replaces the old ~/.fzf.zsh.
# Must run after compinit, which ~/.zshrc does earlier.

source <(fzf --zsh)

# =========================
# Widgets
# =========================

# fgb - fuzzy-checkout a branch, most recently committed first, local + remote.
fgb() {
  git rev-parse --git-dir >/dev/null 2>&1 || { print -u2 'fgb: not a git repository'; return 1 }

  local picked
  picked=$(
    git for-each-ref --sort=-committerdate refs/heads refs/remotes \
        --format='%(refname:short)|%(committerdate:relative)|%(contents:subject)' |
      awk -F'|' '$1 != "origin/HEAD" {
        printf "%-42s \033[32m%-15s\033[0m \033[90m%s\033[0m\n", $1, $2, $3 }' |
      fzf --ansi --no-multi --header 'checkout branch' \
          --preview 'git log --color=always --oneline --graph -n 40 {1}' \
          --preview-window 'down,60%,border-top'
  ) || return

  # Strip the column padding, then any origin/ prefix so a remote branch checks
  # out as a local tracking branch.
  git checkout "${${picked%% *}#origin/}"
}

# fgl - browse history; enter opens the full patch in a pager.
fgl() {
  git rev-parse --git-dir >/dev/null 2>&1 || { print -u2 'fgl: not a git repository'; return 1 }

  git log --color=always --date=short \
      --format='%C(auto)%h %C(blue)%ad %C(green)%an%C(reset) %s' "$@" |
    fzf --ansi --no-sort --no-multi --header 'enter: show full commit' \
        --preview 'git show --color=always --stat --patch {1}' \
        --preview-window 'right,60%,border-left' \
        --bind 'enter:execute(git show --color=always {1} | less -R)'
}

# fkill - pick one or more processes and signal them. Pass a signal name to
# override the default, e.g. `fkill KILL`.
fkill() {
  local -a pids
  pids=(${(f)"$(
    ps -eo pid,user,pcpu,pmem,etime,args --sort=-pcpu |
      fzf --multi --header-lines=1 --header 'tab: select · enter: kill' \
          --preview 'ps -o pid,ppid,user,pcpu,pmem,etime,args -p {1}' \
          --preview-window 'down,6,wrap,border-top' |
      awk '{print $1}'
  )"})

  (( $#pids )) || return
  print "sending SIG${1:-TERM} to: $pids"
  kill "-${1:-TERM}" $pids
}
