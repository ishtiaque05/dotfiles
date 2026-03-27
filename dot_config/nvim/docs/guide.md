# Neovim Developer Guide

Your setup: **LazyVim** + custom config | Leader: **Space** | Theme: **TokyoNight Night**

---

## Quick Reference Card

| Action | Keys | Mode |
|---|---|---|
| Save | `Space w` | Normal |
| Quit | `Space q` | Normal |
| Find files | `Space Space` | Normal |
| Grep text | `Space /` | Normal |
| File explorer | `Space e` | Normal |
| Command palette | `:` | Normal |
| Which-key help | `Space` (wait) | Normal |

---

## Modes

| Mode | Enter with | Exit with | Purpose |
|---|---|---|---|
| **Normal** | `Esc` | -- | Navigate, delete, copy, run commands |
| **Insert** | `i`, `a`, `o` | `Esc` | Type text |
| **Visual** | `v`, `V`, `Ctrl+v` | `Esc` | Select text |
| **Command** | `:` | `Enter` / `Esc` | Run ex commands |
| **Terminal** | (auto on terminal open) | `Ctrl+\ Ctrl+n` | Shell inside nvim |

---

## Normal Mode

### Navigation

| Keys | Action |
|---|---|
| `h j k l` | Left, down, up, right |
| `w` / `b` | Next / previous word |
| `e` | End of word |
| `0` / `$` | Start / end of line |
| `^` | First non-blank character |
| `gg` / `G` | Top / bottom of file |
| `{` / `}` | Previous / next paragraph |
| `Ctrl+d` | Half page down (cursor stays centered) |
| `Ctrl+u` | Half page up (cursor stays centered) |
| `%` | Jump to matching bracket |
| `f{char}` | Jump to next {char} on line |
| `t{char}` | Jump to before next {char} on line |
| `5j` / `12k` | Jump 5 lines down / 12 lines up (relative numbers help here) |

### Editing

| Keys | Action |
|---|---|
| `i` / `a` | Insert before / after cursor |
| `I` / `A` | Insert at start / end of line |
| `o` / `O` | New line below / above |
| `x` | Delete character |
| `dd` | Delete line |
| `dw` | Delete word |
| `d$` or `D` | Delete to end of line |
| `cc` | Change entire line |
| `cw` | Change word |
| `ciw` | Change inner word |
| `ci"` | Change inside quotes |
| `ci(` | Change inside parentheses |
| `yy` | Yank (copy) line |
| `yw` | Yank word |
| `p` / `P` | Paste after / before cursor |
| `u` | Undo |
| `Ctrl+r` | Redo |
| `.` | Repeat last action |
| `~` | Toggle case |
| `>>` / `<<` | Indent / dedent line |

### Search

| Keys | Action |
|---|---|
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` / `N` | Next / previous match |
| `*` | Search word under cursor |
| `Space nh` | Clear search highlights |

### Windows

| Keys | Action |
|---|---|
| `Ctrl+h/j/k/l` | Move to left/down/up/right window |
| `Ctrl+Up/Down` | Resize height +/- 2 |
| `Ctrl+Left/Right` | Resize width +/- 2 |
| `Space -` | Split horizontal |
| `Space \|` | Split vertical |

### Buffers (tabs at top)

| Keys | Action |
|---|---|
| `Shift+l` | Next buffer |
| `Shift+h` | Previous buffer |
| `Space bd` | Delete buffer |
| `Space fb` | Find buffer (fuzzy) |

---

## Visual Mode

Enter with `v` (character), `V` (line), or `Ctrl+v` (block).

| Keys | Action |
|---|---|
| `d` | Delete selection |
| `y` | Yank selection |
| `c` | Change selection |
| `>` | Indent (stays in visual mode) |
| `<` | Dedent (stays in visual mode) |
| `U` / `u` | Uppercase / lowercase |
| `gq` | Format/wrap selection |
| `I` (block mode) | Insert at start of each line |
| `A` (block mode) | Append at end of each line |

---

## Command Mode

Type `:` then the command. Press `Tab` for autocomplete.

| Command | Action |
|---|---|
| `:w` | Save |
| `:q` | Quit |
| `:wq` | Save and quit |
| `:q!` | Quit without saving |
| `:e path/to/file` | Open file |
| `:%s/old/new/g` | Replace all in file |
| `:s/old/new/g` | Replace all in selection |
| `:nohl` | Clear search highlight |
| `:Lazy` | Open plugin manager |
| `:Mason` | Open LSP/tool installer |
| `:LspInfo` | Show active LSP servers |
| `:checkhealth` | Diagnose issues |

---

## Plugins & Workflows

### File Explorer (neo-tree)

Shows hidden files and gitignored files by default.

| Keys | Action |
|---|---|
| `Space e` | Toggle file explorer |
| `Ctrl+w h` | Focus explorer panel |
| `j` / `k` | Navigate up/down in tree |
| `Enter` | Open file / expand folder |
| `a` | Create new file/directory |
| `d` | Delete |
| `r` | Rename |
| `c` / `m` / `p` | Copy / cut / paste |
| `H` | Toggle hidden files |
| `.` | Set root to current directory |
| `Backspace` | Go up one directory |

### Fuzzy Finder (fzf-lua)

| Keys | Action |
|---|---|
| `Space Space` | Find files |
| `Space /` | Grep across project |
| `Space fb` | Find open buffers |
| `Space fr` | Recent files |
| `Space fg` | Live grep |
| `Space fc` | Find in config files |
| `Space fR` | Resume last search |

Inside fzf popup:
| Keys | Action |
|---|---|
| `Ctrl+j/k` | Navigate results |
| `Enter` | Open file |
| `Ctrl+v` | Open in vertical split |
| `Ctrl+x` | Open in horizontal split |
| `Esc` | Close |

### LSP (Language Server)

Works out of the box for Ruby, Rust, TypeScript, Python.

| Keys | Action |
|---|---|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `gy` | Go to type definition |
| `K` | Hover documentation |
| `Space ca` | Code actions (fix/refactor) |
| `Space cr` | Rename symbol |
| `Space cd` | Line diagnostics |
| `[d` / `]d` | Previous / next diagnostic |
| `Space cf` | Format file |

### Git (gitsigns)

| Keys | Action |
|---|---|
| `]h` / `[h` | Next / previous hunk |
| `Space ghs` | Stage hunk |
| `Space ghr` | Reset hunk |
| `Space ghp` | Preview hunk |
| `Space ghb` | Blame line |
| `Space gg` | Open lazygit (if installed) |

### Flash (fast navigation)

| Keys | Action |
|---|---|
| `s` | Flash jump - type 2 chars, then label to jump |
| `S` | Flash treesitter - select by syntax node |

### Search & Replace (grug-far)

| Keys | Action |
|---|---|
| `Space sr` | Open search & replace |

In grug-far window: type search pattern, replacement, and flags. Results update live.

### Trouble (diagnostics panel)

| Keys | Action |
|---|---|
| `Space xx` | Toggle diagnostics |
| `Space xX` | Buffer diagnostics |
| `Space xL` | Location list |
| `Space xQ` | Quickfix list |

### TODO Comments

| Keys | Action |
|---|---|
| `Space st` | Search TODOs |
| `]t` / `[t` | Next / previous TODO |

Recognized tags: `TODO`, `FIXME`, `HACK`, `WARN`, `PERF`, `NOTE`

### Which-key (keybinding discovery)

Press `Space` and wait ~300ms. A popup shows all available keybindings grouped by category. Keep typing to filter.

Key groups under `Space`:
| Prefix | Category |
|---|---|
| `Space f` | Find/files |
| `Space g` | Git |
| `Space c` | Code/LSP |
| `Space b` | Buffers |
| `Space s` | Search |
| `Space u` | UI toggles |
| `Space x` | Diagnostics |
| `Space r` | Rails shortcuts |

### Autocompletion (blink.cmp)

Completion popup appears automatically as you type.

| Keys | Action |
|---|---|
| `Ctrl+Space` | Trigger completion manually |
| `Ctrl+n` / `Ctrl+p` | Next / previous item |
| `Enter` | Accept completion |
| `Ctrl+e` | Dismiss |
| `Tab` / `Shift+Tab` | Navigate snippet fields |

### Mini Surround

| Keys | Action |
|---|---|
| `gsa{motion}{char}` | Add surround (`gsaiw"` = surround word with `"`) |
| `gsd{char}` | Delete surround (`gsd"` = delete surrounding `"`) |
| `gsr{old}{new}` | Replace surround (`gsr"'` = change `"` to `'`) |

---

## Custom Shortcuts

### Rails Development

| Keys | Action |
|---|---|
| `Space rc` | Open `config/routes.rb` |
| `Space rg` | Open `Gemfile` |
| `Space rs` | Open `db/schema.rb` |

### Claude Code

| Keys | Action |
|---|---|
| `Space cc` | Open Claude Code in vertical split terminal |

### Devcontainer (auto-detected)

When opening a project with `.devcontainer/devcontainer.json`, you'll be prompted to:
1. **Start devcontainer** - runs `devcontainer up`
2. **Exec into running devcontainer** - attaches to existing container
3. **Ignore** - skip

---

## Editor Settings

| Setting | Value | Why |
|---|---|---|
| Relative line numbers | On | Makes `5j`, `12k` jumps easy to count |
| Tab width | 2 spaces | Matches Ruby/JS/TS conventions |
| Line wrap | Off | Code doesn't wrap mid-line |
| Smart case search | On | `/foo` matches `Foo`, `/Foo` only matches `Foo` |
| System clipboard | On | Yank in nvim, paste anywhere |
| Swap files | Off | No `.swp` clutter |
| Cursor line | Highlighted | Easy to spot cursor position |
| Split direction | Right/below | New splits open where you expect |
| Scroll offset | 8 lines | Cursor never hits edge of screen |
| Auto-comment | Disabled | New lines after comments stay plain |

---

## Daily Developer Workflow

### Opening a project
```bash
cd ~/code/my-project
nvim .
```
Neo-tree opens on the left. Use `Space e` to toggle it.

### Finding and opening files
1. `Space Space` - fuzzy find by filename
2. Type partial name, press `Enter`
3. Use `Space fr` for recently opened files

### Editing code
1. Navigate to the right spot with `/search`, `gd`, or line numbers
2. `ciw` to change a word, `cc` to change a line
3. `Space cf` to format, `:w` or `Space w` to save

### Searching across the project
1. `Space /` or `Space fg` - live grep
2. Type your search, navigate results, `Enter` to jump
3. `Space sr` for search-and-replace across files

### Working with LSP
1. `K` on any symbol for docs
2. `gd` to jump to definition, `Ctrl+o` to jump back
3. `Space ca` for quick fixes and refactors
4. `Space cr` to rename a symbol everywhere
5. `[d` / `]d` to hop between errors

### Git workflow
1. `Space gg` to open lazygit (full git TUI)
2. `]h` / `[h` to navigate changed hunks
3. `Space ghs` to stage hunks individually
4. `Space ghp` to preview what changed

### Managing plugins
```vim
:Lazy          " Open plugin manager
:Lazy sync     " Update all plugins
:Lazy health   " Check plugin health
:Mason         " Install/update LSP servers
```

### Terminal inside nvim
```vim
:terminal      " Open terminal in current buffer
Ctrl+\ Ctrl+n  " Exit terminal mode back to normal
```

---

## Tips

- **Undo tree**: `u` undoes, `Ctrl+r` redoes. Nvim remembers undo history across sessions.
- **Repeat anything**: `.` repeats your last edit. Combine with `n` to repeat across search matches.
- **Macros**: `qa` starts recording into register `a`. Do your edits. `q` stops. `@a` replays. `10@a` replays 10 times.
- **Marks**: `ma` sets mark `a`. `'a` jumps back to it. Uppercase marks (`mA`) work across files.
- **Registers**: `"ayy` yanks into register `a`. `"ap` pastes from it. `"+y` uses system clipboard (already default in your config).
- **Text objects**: `ci"` (change inside quotes), `da(` (delete around parens), `vi{` (select inside braces). Works with any bracket/quote pair.
- **Jump back**: `Ctrl+o` goes back, `Ctrl+i` goes forward through jump history.

---
---

# Tmux Guide

Your setup: **Prefix = Ctrl+a** | Vim-style navigation | Tokyo Night theme

---

## Core Concepts

Tmux has three levels: **sessions** > **windows** > **panes**.

- **Session**: A workspace (e.g., one per project). Persists even if you disconnect.
- **Window**: A tab within a session. Shown in the status bar at the bottom.
- **Pane**: A split within a window. Multiple panes show side by side.

All tmux commands start with the **prefix key**: `Ctrl+a` (press both, release, then press the next key).

---

## Starting & Attaching

```bash
tmux                        # Start new session
tmux new -s myproject       # Start named session
tmux ls                     # List sessions
tmux attach -t myproject    # Reattach to session
tmux kill-session -t name   # Kill a session
```

---

## Sessions

| Keys | Action |
|---|---|
| `Ctrl+a d` | Detach from session (it keeps running) |
| `Ctrl+a s` | List/switch sessions |
| `Ctrl+a $` | Rename current session |
| `Ctrl+a (` / `)` | Previous / next session |

---

## Windows (tabs)

| Keys | Action |
|---|---|
| `Ctrl+a t` | New window (in current path) |
| `Shift+Left` | Previous window (no prefix needed) |
| `Shift+Right` | Next window (no prefix needed) |
| `Ctrl+a 1-9` | Jump to window by number |
| `Ctrl+a ,` | Rename window |
| `Ctrl+a &` | Close window (confirms) |
| `Ctrl+a w` | List all windows (interactive picker) |

Windows are numbered starting at 1 and auto-renumber when one is closed.

---

## Panes (splits)

### Creating

| Keys | Action |
|---|---|
| `Ctrl+a \|` | Split vertically (side by side) |
| `Ctrl+a -` | Split horizontally (top/bottom) |

Both open in the current directory.

### Navigating

| Keys | Action |
|---|---|
| `Ctrl+a h` | Move to left pane |
| `Ctrl+a j` | Move to pane below |
| `Ctrl+a k` | Move to pane above |
| `Ctrl+a l` | Move to right pane |
| `Ctrl+a q` | Show pane numbers, type number to jump |

### Resizing (repeatable - hold prefix)

| Keys | Action |
|---|---|
| `Ctrl+a H` | Resize left by 5 |
| `Ctrl+a J` | Resize down by 5 |
| `Ctrl+a K` | Resize up by 5 |
| `Ctrl+a L` | Resize right by 5 |

### Managing

| Keys | Action |
|---|---|
| `Ctrl+a x` | Close pane (confirms) |
| `Ctrl+a z` | Zoom pane (toggle fullscreen) |
| `Ctrl+a !` | Break pane into its own window |
| `Ctrl+a {` / `}` | Swap pane left / right |
| `Ctrl+a Space` | Cycle through pane layouts |

---

## Copy Mode (vim-style)

Tmux uses vim keybindings for scrolling and selecting.

| Keys | Action |
|---|---|
| `Ctrl+a [` | Enter copy mode (scrollback) |
| `q` | Exit copy mode |
| `j` / `k` | Scroll down / up |
| `Ctrl+d` / `Ctrl+u` | Half page down / up |
| `g` / `G` | Top / bottom of scrollback |
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` / `N` | Next / previous match |
| `v` | Start selection |
| `y` | Yank selection (copies to system clipboard) |

Mouse drag also auto-copies to clipboard and clears selection.

---

## Claude Code in Tmux

| Keys | Action |
|---|---|
| `Ctrl+a C` | Open Claude Code in a 40% right split |

This opens Claude in a pane alongside your editor - great for AI-assisted development.

---

## Config Management

| Keys | Action |
|---|---|
| `Ctrl+a r` | Reload tmux config |

Config location: `~/.config/tmux/tmux.conf`

---

## Mouse Support

Mouse is enabled. You can:
- **Click** a pane to focus it
- **Drag** pane borders to resize
- **Scroll** to enter copy mode and browse scrollback
- **Drag to select** text (auto-copies to clipboard)
- **Click** window names in status bar to switch

---

## Settings

| Setting | Value | Why |
|---|---|---|
| Prefix | `Ctrl+a` | Easier to reach than default `Ctrl+b` |
| Mouse | Enabled | Click panes, scroll, select text |
| Base index | 1 | Windows/panes start at 1, not 0 |
| Scrollback | 50,000 lines | Generous history |
| Escape time | 10ms | No delay when pressing Esc in nvim |
| Focus events | On | Nvim detects when you switch panes |
| Mode keys | vi | Vim bindings in copy mode |

---

## Daily Developer Workflow with Tmux + Neovim

### Project setup
```bash
tmux new -s myproject           # Create session for project
nvim .                          # Open editor in main pane
Ctrl+a |                        # Split right for terminal
Ctrl+a h                        # Go back to nvim pane
```

### Typical layout
```
┌──────────────────────┬─────────────┐
│                      │             │
│       Neovim         │  Terminal   │
│                      │  (tests,   │
│                      │   server)  │
│                      │             │
└──────────────────────┴─────────────┘
  Window 1: Code         Pane 2
```

### Multi-window workflow
- **Window 1**: Neovim (editor)
- **Window 2**: Server/logs (`rails s`, `npm run dev`)
- **Window 3**: Git / misc terminal work

Switch between them with `Shift+Left/Right` or `Ctrl+a 1/2/3`.

### End of day
```
Ctrl+a d                        # Detach - everything keeps running
```

### Next day
```bash
tmux attach -t myproject        # Pick up where you left off
```

---

## Tips

- **Zoom in**: `Ctrl+a z` makes a pane fullscreen. Press again to restore. Great for focusing on one thing.
- **Quick terminal**: `Ctrl+a |` to split, run a command, `Ctrl+a x` to close when done.
- **Swap layouts**: `Ctrl+a Space` cycles through even-horizontal, even-vertical, main-horizontal, etc.
- **Copy from scrollback**: `Ctrl+a [`, navigate to text, `v` to select, `y` to copy. Paste anywhere with `Cmd+v`.
- **Multiple sessions**: Use separate tmux sessions for different projects. `Ctrl+a s` to switch between them.
- **Pane to window**: `Ctrl+a !` promotes a pane to its own window if it needs more space.
