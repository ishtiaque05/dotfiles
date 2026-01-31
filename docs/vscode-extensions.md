# VSCode Recommended Extensions

## ⚠️ IMPORTANT: Install Extensions First

**Before opening VSCode with the dotfiles settings**, install the required extensions to avoid formatter errors.

The dotfiles include `settings.json` with pre-configured formatters. VSCode will show errors like:
```
Value is not accepted. Valid values: "esbenp.prettier-vscode"...
```

These errors occur because the formatter extensions aren't installed yet.

### Quick Fix - Install Essential Extensions First

Run this **BEFORE** applying dotfiles or opening VSCode:

```bash
# Essential formatters (fixes all defaultFormatter errors)
code --install-extension esbenp.prettier-vscode \
  --install-extension Shopify.ruby-lsp \
  --install-extension ms-python.black-formatter \
  --install-extension rust-lang.rust-analyzer \
  --install-extension foxundermoon.shell-format \
  --install-extension ms-azuretools.vscode-docker
```

Then restart VSCode - no more errors!

---

## Full Installation

### Install All Extensions (Recommended)

Install all recommended extensions at once:
```bash
# Copy and paste this entire block into your terminal
code --install-extension enkia.tokyo-night \
  --install-extension PKief.material-icon-theme \
  --install-extension esbenp.prettier-vscode \
  --install-extension dbaeumer.vscode-eslint \
  --install-extension Shopify.ruby-lsp \
  --install-extension ms-python.python \
  --install-extension ms-python.vscode-pylance \
  --install-extension ms-python.black-formatter \
  --install-extension ms-python.isort \
  --install-extension rust-lang.rust-analyzer \
  --install-extension ms-azuretools.vscode-docker \
  --install-extension foxundermoon.shell-format \
  --install-extension EditorConfig.EditorConfig \
  --install-extension eamodio.gitlens \
  --install-extension mhutchie.git-graph \
  --install-extension GitHub.copilot \
  --install-extension GitHub.copilot-chat \
  --install-extension formulahendry.auto-rename-tag \
  --install-extension naumovs.color-highlight \
  --install-extension usernamehw.errorlens \
  --install-extension oderwat.indent-rainbow \
  --install-extension aaron-bond.better-comments \
  --install-extension bradlc.vscode-tailwindcss \
  --install-extension christian-kohler.path-intellisense \
  --install-extension streetsidesoftware.code-spell-checker \
  --install-extension wayou.vscode-todo-highlight \
  --install-extension yzhang.markdown-all-in-one
```

## Essential Extensions

### Theme & Icons
- **Tokyo Night** - Beautiful dark theme
- **Material Icon Theme** - File icons

### Code Formatting & Linting
- **Prettier** - Code formatter (JS/TS/JSON/CSS/HTML)
- **ESLint** - JavaScript/TypeScript linter
- **EditorConfig** - Maintain consistent coding styles

### Language Support

#### Ruby/Rails
- **Ruby LSP** - Ruby language server (Shopify)
  - Autocomplete, go to definition, formatting
  - Uses Rubocop for formatting

#### Python
- **Python** - Python language support
- **Pylance** - Fast Python language server
- **Black Formatter** - Python code formatter
- **isort** - Python import organizer

#### Rust
- **rust-analyzer** - Rust language server
  - Autocomplete, type hints, refactoring

#### TypeScript/React
- **ESLint** - Already listed above
- **Prettier** - Already listed above

#### Docker
- **Docker** - Dockerfile and docker-compose support
  - Syntax highlighting, linting, autocomplete

#### Shell
- **shell-format** - Format shell scripts

### Git
- **GitLens** - Supercharged Git capabilities
  - Blame annotations, code lens, history
- **Git Graph** - View git graph/history

### AI Assistance
- **GitHub Copilot** - AI pair programmer
- **GitHub Copilot Chat** - Chat interface for Copilot

### Productivity
- **Auto Rename Tag** - Rename paired HTML/JSX tags
- **Color Highlight** - Highlight colors in code
- **Error Lens** - Show errors inline
- **Indent Rainbow** - Colorize indentation
- **Better Comments** - Styled comments (TODO, FIXME, etc.)
- **Path Intellisense** - Autocomplete file paths
- **Code Spell Checker** - Spell checking in code
- **TODO Highlight** - Highlight TODO, FIXME in code
- **Markdown All in One** - Markdown shortcuts & preview

### Framework-Specific

#### Tailwind CSS
- **Tailwind CSS IntelliSense** - Autocomplete for Tailwind

## Optional Extensions

### Database
```bash
code --install-extension mtxr.sqltools \
  --install-extension mtxr.sqltools-driver-pg
```

### REST Client
```bash
code --install-extension humao.rest-client
```

### Live Server (HTML)
```bash
code --install-extension ritwickdey.LiveServer
```

### Rails-Specific
```bash
code --install-extension Vense.rails-snippets \
  --install-extension bung87.rails
```

## Keybindings Tips

After installing, useful shortcuts:
- `Cmd/Ctrl + Shift + P` - Command palette
- `Cmd/Ctrl + P` - Quick file open
- `Cmd/Ctrl + Shift + F` - Search in files
- `Cmd/Ctrl + B` - Toggle sidebar
- `Cmd/Ctrl + J` - Toggle terminal
- `Cmd/Ctrl + /` - Toggle comment
- `Alt + Up/Down` - Move line up/down
- `Alt + Shift + Up/Down` - Copy line up/down
- `Cmd/Ctrl + D` - Select next occurrence
- `Cmd/Ctrl + Shift + L` - Select all occurrences

## Settings Sync

VSCode settings are managed by Chezmoi and located at:
- Linux: `~/.config/Code/User/settings.json`
- macOS: `~/Library/Application Support/Code/User/settings.json`

Extensions are user-specific and not synced via Chezmoi.
Use the commands above to install on new machines.
