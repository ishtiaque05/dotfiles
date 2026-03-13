# CLI Tools Reference

Modern CLI tools that replace traditional Unix utilities. All installed automatically via chezmoi.

## Tool Overview

| Tool | Replaces | Install (macOS) | Install (Linux) |
|------|----------|-----------------|-----------------|
| eza | ls | `brew install eza` | apt repo + `apt install` |
| bat | cat | `brew install bat` | `apt install bat` (as `batcat`) |
| fd | find | `brew install fd` | `apt install fd-find` (as `fdfind`) |
| fzf | Ctrl-R / find | `brew install fzf` | git clone + install script |
| zoxide | cd | `brew install zoxide` | curl installer |
| lazygit | git CLI | `brew install lazygit` | GitHub release binary |
| git-delta | diff | `brew install git-delta` | GitHub release .deb |
| tldr | man | `brew install tldr` | `apt install tldr` |

---

## eza (modern `ls`)

Aliased as `ls` — you get icons and colors automatically.

```bash
ls                    # List with icons
ls -la                # Long format with hidden files
ls --tree             # Tree view
ls --tree --level=2   # Tree view, 2 levels deep
ls --git-ignore       # Respect .gitignore
ls -la --sort=mod     # Sort by modification time
```

---

## bat (modern `cat`)

Aliased as `cat` — syntax highlighting with Tokyo Night theme.

```bash
cat file.rb           # Syntax-highlighted output
cat -n file.rb        # With line numbers
bat file.rb           # Same thing (direct command)
bat -l ruby file      # Force language detection
bat --diff file.rb    # Show git diff for file
bat -A file.txt       # Show non-printable characters
```

**Theme:** `tokyonight_night` (auto-installed, set via `BAT_THEME` env var)

---

## fd (modern `find`)

Fast file finding. Also powers fzf's `Ctrl-T` and Neovim's Telescope.

```bash
fd                        # List all files recursively
fd "pattern"              # Find files matching pattern
fd -e rb                  # Find all .rb files
fd -e rb -e ts            # Find .rb and .ts files
fd "spec" --type f        # Find files containing "spec"
fd "spec" --type d        # Find directories containing "spec"
fd -H ".env"              # Include hidden files
fd -E node_modules        # Exclude directory
fd "test" app/            # Search only in app/ directory
```

**Integration with fzf:**

```bash
# FZF_DEFAULT_COMMAND uses fd for faster file listing:
export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"
```

On Linux, fd installs as `fdfind` — a symlink to `fd` is created at `~/.local/bin/fd`.

---

## fzf (fuzzy finder)

Interactive fuzzy search for files, history, and more.

### Keyboard Shortcuts

| Key | Action |
|-----|--------|
| `Ctrl-T` | Fuzzy find files (uses fd as backend) |
| `Ctrl-R` | Fuzzy search command history |
| `Alt-C` | Fuzzy cd into directory |

### Preview Features

- File preview uses `bat` with syntax highlighting
- Directory preview uses `eza --tree`
- Both activate automatically with `Ctrl-T`

### Usage in Other Commands

```bash
# Fuzzy open file in nvim
nvim $(fzf)

# Fuzzy git checkout branch
git checkout $(git branch | fzf)

# Kill a process
kill $(ps aux | fzf | awk '{print $2}')
```

### Tab Completion

```bash
cd **<TAB>            # Fuzzy directory completion
vim **<TAB>           # Fuzzy file completion
ssh **<TAB>           # Fuzzy host completion
kill -9 **<TAB>       # Fuzzy process completion
```

---

## zoxide (smart `cd`)

Aliased as `cd` — learns your most-used directories and jumps to them.

```bash
cd projects           # Jumps to most-visited "projects" directory
cd dot                # Jumps to your dotfiles (if visited before)
cd ~/exact/path       # Works like normal cd too
cdi                   # Interactive directory picker (with fzf)
```

**How it works:** zoxide tracks every directory you visit and ranks them by frequency + recency. When you type a partial name, it jumps to the highest-ranked match.

```bash
# First time: teach it your directories
cd ~/Thinkific/workspace/claude-orchestrator
cd ~/Thinkific/workspace/rails

# Later: just type fragments
cd claude             # → ~/Thinkific/workspace/claude-orchestrator
cd rails              # → ~/Thinkific/workspace/rails
```

---

## lazygit (terminal git UI)

Full git interface in the terminal. Alias: `lg`

```bash
lg                    # Open lazygit in current repo
```

### Key Areas

| Panel | Navigate | Purpose |
|-------|----------|---------|
| 1 | Status | Working directory status |
| 2 | Files | Stage/unstage individual files or hunks |
| 3 | Branches | Create, checkout, merge, rebase |
| 4 | Commits | Browse, cherry-pick, reword, squash |
| 5 | Stash | Stash/pop changes |

### Common Actions

| Key | Action |
|-----|--------|
| `Space` | Stage/unstage file |
| `a` | Stage all |
| `c` | Commit |
| `P` | Push |
| `p` | Pull |
| `Enter` | View file diff |
| `?` | Show all keybindings |
| `q` | Quit |

### Also Available in Neovim

Press `Space g g` inside Neovim to open lazygit in a floating terminal.

---

## git-delta (syntax-highlighted diffs)

Auto-configured as the git pager — every `git diff` and `git log` uses delta.

### What You Get Automatically

```bash
git diff              # Side-by-side diff with syntax highlighting
git log -p            # Commit log with highlighted diffs
git show HEAD         # Show commit with highlighting
git stash show -p     # Stash diff with highlighting
```

### Configuration (auto-applied)

| Setting | Value | Effect |
|---------|-------|--------|
| `core.pager` | `delta` | All git output goes through delta |
| `delta.side-by-side` | `true` | Two-column diff view |
| `delta.line-numbers` | `true` | Line numbers in diffs |
| `delta.navigate` | `true` | Use `n/N` to jump between diff sections |
| `delta.syntax-theme` | `tokyonight_night` | Matches editor theme |
| `merge.conflictstyle` | `diff3` | Shows base version in merge conflicts |

### Navigation

| Key | Action |
|-----|--------|
| `n` | Next diff section |
| `N` | Previous diff section |
| `q` | Quit pager |
| `/` | Search in output |

---

## tldr (simplified man pages)

Community-maintained command examples. Much more readable than `man` pages.

```bash
tldr tar              # How to use tar (common examples)
tldr docker           # Docker usage examples
tldr git-rebase       # Git rebase examples
tldr --update         # Update the tldr cache
```

---

## Zsh Plugins

### zsh-autosuggestions

Shows command suggestions as you type (gray text). Press `→` (right arrow) to accept.

### zsh-syntax-highlighting

Colors commands as you type:
- Green = valid command
- Red = invalid command
- Underline = valid file path
