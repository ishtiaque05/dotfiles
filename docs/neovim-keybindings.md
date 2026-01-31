# Neovim (LazyVim) Keybindings

Leader key: `<Space>`

## General

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>w` | Save | Write current file |
| `<leader>q` | Quit | Quit current window |
| `<leader>nh` | No Highlight | Clear search highlights |
| `<Esc>` | Clear | Clear search (LazyVim default) |

## File Explorer (Neo-tree)

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>e` | Toggle | Toggle file explorer |
| `<leader>E` | Focus | Focus file explorer |
| `a` | Add | Create new file/folder |
| `d` | Delete | Delete file/folder |
| `r` | Rename | Rename file/folder |
| `x` | Cut | Cut file/folder |
| `c` | Copy | Copy file/folder |
| `p` | Paste | Paste file/folder |

## Fuzzy Finding (Telescope)

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>ff` | Find Files | Search files in project |
| `<leader>fg` | Live Grep | Search text in project |
| `<leader>fb` | Find Buffers | Search open buffers |
| `<leader>fh` | Find Help | Search help tags |
| `<leader>fr` | Recent Files | Search recent files |
| `<leader>fw` | Find Word | Search word under cursor |
| `<leader>gc` | Git Commits | Browse git commits |
| `<leader>gs` | Git Status | Git status |

## Window Management

| Key | Action | Description |
|-----|--------|-------------|
| `<C-h>` | Left | Move to left window |
| `<C-j>` | Down | Move to bottom window |
| `<C-k>` | Up | Move to top window |
| `<C-l>` | Right | Move to right window |
| `<C-Up>` | Resize | Increase window height |
| `<C-Down>` | Resize | Decrease window height |
| `<C-Left>` | Resize | Decrease window width |
| `<C-Right>` | Resize | Increase window width |
| `<leader>sv` | Split V | Split window vertically |
| `<leader>sh` | Split H | Split window horizontally |
| `<leader>sx` | Close | Close current split |

## Buffer Navigation

| Key | Action | Description |
|-----|--------|-------------|
| `<S-h>` | Previous | Go to previous buffer |
| `<S-l>` | Next | Go to next buffer |
| `<leader>bd` | Delete | Close current buffer |
| `<leader>bp` | Pin | Pin/unpin buffer |

## Tab Management

| Key | Action | Description |
|-----|--------|-------------|
| `<leader><tab>l` | Last | Go to last tab |
| `<leader><tab>f` | First | Go to first tab |
| `<leader><tab><tab>` | New | Create new tab |
| `<leader><tab>]` | Next | Go to next tab |
| `<leader><tab>[` | Previous | Go to previous tab |
| `<leader><tab>d` | Close | Close current tab |

## Code Actions (LSP)

| Key | Action | Description |
|-----|--------|-------------|
| `gd` | Definition | Go to definition |
| `gr` | References | Show references |
| `gI` | Implementation | Go to implementation |
| `gy` | Type Def | Go to type definition |
| `K` | Hover | Show hover documentation |
| `gK` | Signature | Show signature help |
| `<leader>ca` | Code Action | Show code actions |
| `<leader>cr` | Rename | Rename symbol |
| `<leader>cf` | Format | Format document |
| `[d` | Prev Diagnostic | Previous diagnostic |
| `]d` | Next Diagnostic | Next diagnostic |
| `<leader>cd` | Diagnostics | Show diagnostics |

## Editing

| Key | Action | Description |
|-----|--------|-------------|
| `<C-d>` | Scroll Down | Scroll down (centered) |
| `<C-u>` | Scroll Up | Scroll up (centered) |
| `J` | Join Lines | Join line below to current |
| `<` | Indent Left | Decrease indent (visual) |
| `>` | Indent Right | Increase indent (visual) |
| `gcc` | Comment | Toggle comment line |
| `gc` | Comment | Toggle comment (visual) |
| `<leader>/` | Comment | Toggle comment (LazyVim) |

## Git (LazyGit)

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>gg` | LazyGit | Open LazyGit |
| `<leader>gb` | Blame Line | Git blame current line |
| `<leader>gB` | Blame File | Git blame file |
| `]h` | Next Hunk | Next git hunk |
| `[h` | Prev Hunk | Previous git hunk |

## Terminal

| Key | Action | Description |
|-----|--------|-------------|
| `<C-/>` | Terminal | Toggle terminal |
| `<leader>ft` | Terminal | Open terminal in cwd |
| `<leader>fT` | Terminal Root | Open terminal in root |
| `<Esc><Esc>` | Exit | Exit terminal mode |

## Ruby on Rails Specific

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>rc` | Routes | Open config/routes.rb |
| `<leader>rg` | Gemfile | Open Gemfile |
| `<leader>rs` | Schema | Open db/schema.rb |

## Search & Replace

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>sr` | Search Replace | Search and replace |
| `<leader>sR` | Spectre | Open spectre (advanced S&R) |

## Miscellaneous

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>l` | Lazy | Open Lazy plugin manager |
| `<leader>xl` | Location List | Open location list |
| `<leader>xq` | Quickfix | Open quickfix list |
| `<leader>uf` | Format Toggle | Toggle auto-format on save |
| `<leader>us` | Spelling | Toggle spelling |
| `<leader>uw` | Word Wrap | Toggle word wrap |
| `<leader>ul` | Line Numbers | Toggle line numbers |

## Tips

1. **Which-key**: Press `<leader>` and wait - a popup shows all available keybindings
2. **Search keymaps**: `<leader>sk` - Search all keymaps
3. **Help**: `:help` or `<leader>fh` to search help
4. **Command palette**: `<leader><leader>` - Search and execute commands

## Language Support

LazyVim includes LSP support for:
- ✅ Ruby (solargraph)
- ✅ Rust (rust-analyzer)
- ✅ TypeScript/JavaScript (tsserver)
- ✅ Python (pyright)
- ✅ Shell scripts (bash-language-server)
- ✅ React/JSX
- ✅ JSON, YAML, TOML, Markdown

Formatters:
- Prettier (JS/TS/JSON/CSS/HTML)
- Rubocop (Ruby)
- Black (Python)
- rustfmt (Rust)
