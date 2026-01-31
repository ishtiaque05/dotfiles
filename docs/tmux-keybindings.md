# Tmux Keybindings

Prefix key: `Ctrl+a` (changed from default `Ctrl+b`)

## Basic Usage

| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl+a` | Prefix | Prefix key (press before other commands) |
| `Ctrl+a r` | Reload | Reload tmux configuration |
| `Ctrl+a ?` | Help | Show all keybindings |
| `Ctrl+a d` | Detach | Detach from session |

## Pane Management

### Creating Panes

| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl+a \|` | Split Vertical | Split pane vertically |
| `Ctrl+a -` | Split Horizontal | Split pane horizontally |
| `Ctrl+a x` | Close | Close current pane |

### Navigating Panes

| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl+a h` | Left | Move to left pane |
| `Ctrl+a j` | Down | Move to bottom pane |
| `Ctrl+a k` | Up | Move to top pane |
| `Ctrl+a l` | Right | Move to right pane |
| `Ctrl+a ;` | Last | Toggle to last pane |
| `Ctrl+a o` | Next | Cycle to next pane |

### Resizing Panes

| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl+a H` | Resize Left | Resize pane left (repeatable) |
| `Ctrl+a J` | Resize Down | Resize pane down (repeatable) |
| `Ctrl+a K` | Resize Up | Resize pane up (repeatable) |
| `Ctrl+a L` | Resize Right | Resize pane right (repeatable) |
| `Ctrl+a z` | Zoom | Toggle pane zoom (fullscreen) |

## Window Management

| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl+a c` | Create | Create new window |
| `Ctrl+a &` | Kill | Kill current window |
| `Ctrl+a ,` | Rename | Rename current window |
| `Shift+Left` | Previous | Go to previous window |
| `Shift+Right` | Next | Go to next window |
| `Ctrl+a 0-9` | Jump | Jump to window by number |
| `Ctrl+a w` | List | List all windows |

## Session Management

| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl+a s` | List | List all sessions |
| `Ctrl+a $` | Rename | Rename current session |
| `Ctrl+a (` | Previous | Switch to previous session |
| `Ctrl+a )` | Next | Switch to next session |

## Copy Mode (Vim-style)

| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl+a [` | Enter | Enter copy mode |
| `v` | Select | Start selection (in copy mode) |
| `y` | Copy | Copy selection and exit |
| `Esc` | Exit | Exit copy mode |
| `q` | Quit | Quit copy mode |

### Navigation in Copy Mode

| Key | Action | Description |
|-----|--------|-------------|
| `h/j/k/l` | Move | Vim-style movement |
| `w/b` | Word | Jump forward/backward by word |
| `0/$` | Line | Jump to start/end of line |
| `Ctrl+u/d` | Scroll | Scroll up/down half page |
| `/` | Search | Search forward |
| `?` | Search | Search backward |
| `n/N` | Next | Jump to next/previous match |

## Mouse Support

Mouse is enabled! You can:
- Click to select panes
- Click and drag to resize panes
- Scroll to navigate history
- Right-click for context menu
- Select text with mouse (copy mode)

## Common Workflows

### Split and Navigate
```
Ctrl+a |          # Split vertically
Ctrl+a -          # Split horizontally
Ctrl+a h/j/k/l    # Navigate between panes
```

### Create New Session
```bash
tmux new -s mysession    # Create session named 'mysession'
Ctrl+a d                 # Detach from session
tmux attach -t mysession # Reattach to session
tmux ls                  # List all sessions
```

### Copy Text
```
Ctrl+a [         # Enter copy mode
v                # Start selection
y                # Copy and exit
Ctrl+a ]         # Paste (default tmux)
```

## Tips

1. **Reload config**: After editing `~/.tmux.conf`, reload with `Ctrl+a r`
2. **Kill stuck pane**: `Ctrl+a x` then confirm with `y`
3. **Zoom pane**: `Ctrl+a z` to toggle fullscreen on current pane
4. **Detach session**: `Ctrl+a d` - session keeps running in background
5. **Help**: `Ctrl+a ?` shows all keybindings

## Tmux + Neovim Integration

Works seamlessly with Neovim:
- `Ctrl+h/j/k/l` navigates between both tmux panes and Neovim splits
- Terminal colors work correctly (256 colors + true color)
- Fast escape time (10ms) for better Neovim responsiveness
- Focus events enabled for Neovim autoread

## External Resources

- [Tmux Cheat Sheet](https://tmuxcheatsheet.com/)
- [Tmux Plugin Manager (TPM)](https://github.com/tmux-plugins/tpm)
- [Oh My Tmux!](https://github.com/gpakosz/.tmux) - Alternative config
