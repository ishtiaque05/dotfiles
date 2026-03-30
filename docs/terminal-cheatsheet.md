# Terminal Cheat Sheet — WezTerm + Tmux + Neovim

A unified reference for daily keyboard shortcuts with mnemonic notes
to build muscle memory. All three tools share the same movement language.

---

## The Mental Model

```
Think in LAYERS:

  WezTerm  →  Cmd+.  then key     (local terminal, outer shell)
  Tmux     →  Ctrl+a then key     (remote sessions, inner shell)
  Neovim   →  direct keys / <leader>  (editor, innermost)

Same ACTIONS everywhere:
  h/j/k/l  = move left/down/up/right    (vim directions)
  |        = split vertical              (it looks like a vertical line)
  -        = split horizontal            (it looks like a horizontal line)
  t        = new tab                     (t for tab)
  d        = close/delete                (d for delete)
  z        = zoom/maximize               (z for zoom)
```

---

## WezTerm — Leader: `Cmd+.`

Press `Cmd+.`, release, then press the action key within 1 second.

### Panes — "Where am I looking?"

| Keys             | Action            | Remember                        |
|------------------|-------------------|---------------------------------|
| `Cmd+.`  `\|`   | Split right       | `\|` looks like a vertical wall |
| `Cmd+.`  `-`    | Split down        | `-` looks like a floor          |
| `Cmd+.`  `h`    | Go left           | vim: **h**ome (leftmost)        |
| `Cmd+.`  `j`    | Go down           | vim: **j**ump down              |
| `Cmd+.`  `k`    | Go up             | vim: **k**ick up                |
| `Cmd+.`  `l`    | Go right          | vim: **l**ast (rightmost)       |
| `Cmd+.`  `H`    | Resize left       | SHIFT = resize (bigger motion)  |
| `Cmd+.`  `J`    | Resize down       | SHIFT = resize                  |
| `Cmd+.`  `K`    | Resize up         | SHIFT = resize                  |
| `Cmd+.`  `L`    | Resize right      | SHIFT = resize                  |
| `Cmd+.`  `z`    | Zoom pane         | **z**oom — toggle fullscreen pane |
| `Cmd+.`  `x`    | Close pane        | Same as tmux `prefix+x` — e**x**it |
| `Cmd+.`  `d`    | Swap pane (pick)  | **d**rag to swap — pick target visually |

### Tabs — "Which project am I on?"

| Keys             | Action            | Remember                        |
|------------------|-------------------|---------------------------------|
| `Cmd+.`  `t`    | New tab           | **t**ab — create a new one      |
| `Cmd+.`  `n`    | Next tab →        | **n**ext tab                    |
| `Cmd+.`  `p`    | Previous tab ←    | **p**revious tab                |
| `Cmd+.`  `1-9`  | Jump to tab #     | Direct — tab **1**, tab **2**.. |
| `Cmd+.`  `w`    | Tab picker        | **w**hich tab? (fuzzy search)   |
| `Cmd+.`  `,`    | Rename tab        | Comma = "add a label"           |

### Workspaces — "Which context am I in?"

| Keys             | Action              | Remember                      |
|------------------|---------------------|-------------------------------|
| `Cmd+.`  `s`    | Workspace picker    | **s**ession — pick one        |
| `Cmd+.`  `S`    | New workspace       | **S**ESSION — create new      |
| `Cmd+.`  `(`    | Prev workspace      | **(** look left               |
| `Cmd+.`  `)`    | Next workspace      | **)** look right              |

### Utility — "What else?"

| Keys               | Action            | Remember                      |
|---------------------|-------------------|-------------------------------|
| `Cmd+.`  `r`      | Reload config     | **r**eload — pick up changes  |
| `Cmd+.`  `f`      | Find/search       | **f**ind text in scrollback   |
| `Cmd+.`  `c`      | Copy mode         | **c**opy — vim keys to select |
| `Cmd+.`  `Space`  | Quick select      | Space = "go!" — click URLs/paths |
| `Cmd+.`  `e`      | File explorer     | **e**xplore — eza tree split  |

### Direct Shortcuts (No Leader)

| Keys             | Action            | Platform |
|------------------|-------------------|----------|
| `Cmd+Shift+c`   | Copy              | macOS    |
| `Cmd+Shift+v`   | Paste             | macOS    |
| `Ctrl+Shift+c`  | Copy              | Linux    |
| `Ctrl+Shift+v`  | Paste             | Linux    |
| `Cmd+Enter`     | Fullscreen        | macOS    |

---

## Tmux — Prefix: `Ctrl+a`

Press `Ctrl+a`, release, then press the action key.
Almost identical to WezTerm — same muscle memory, different leader.

### Panes

| Keys              | Action            | Remember                       |
|-------------------|-------------------|--------------------------------|
| `C-a`  `\|`      | Split right       | Same as WezTerm                |
| `C-a`  `-`       | Split down        | Same as WezTerm                |
| `C-a`  `h`       | Go left           | Same vim nav                   |
| `C-a`  `j`       | Go down           | Same vim nav                   |
| `C-a`  `k`       | Go up             | Same vim nav                   |
| `C-a`  `l`       | Go right          | Same vim nav                   |
| `C-a`  `H`       | Resize left       | Same SHIFT = resize            |
| `C-a`  `J`       | Resize down       | Same SHIFT = resize            |
| `C-a`  `K`       | Resize up         | Same SHIFT = resize            |
| `C-a`  `L`       | Resize right      | Same SHIFT = resize            |
| `C-a`  `z`       | Zoom pane         | **z**oom — same everywhere     |

### Windows (Tmux calls tabs "windows")

| Keys              | Action            | Remember                       |
|-------------------|-------------------|--------------------------------|
| `C-a`  `t`       | New window        | **t**ab — unified with WezTerm |
| `Shift+←`        | Previous window   | Arrow = direction (no prefix!) |
| `Shift+→`        | Next window       | Arrow = direction (no prefix!) |

### Sessions

| Keys              | Action            | Remember                       |
|-------------------|-------------------|--------------------------------|
| `C-a`  `d`       | Detach session    | **d**etach — leave it running  |
| `tmux ls`         | List sessions     | **l**i**s**t                   |
| `tmux a -t name`  | Attach session    | **a**ttach **t**o name         |
| `tmux new -s name`| New session       | **new** **s**ession            |

### Copy Mode (Vim Keys)

| Keys              | Action            | Remember                       |
|-------------------|-------------------|--------------------------------|
| `C-a`  `[`       | Enter copy mode   | `[` = "step back into history" |
| `v`              | Start selection   | Same as vim visual mode        |
| `y`              | Yank (copy)       | Same as vim yank               |
| `q`              | Quit copy mode    | **q**uit                       |

### Utility

| Keys              | Action            | Remember                       |
|-------------------|-------------------|--------------------------------|
| `C-a`  `r`       | Reload config     | **r**eload — same as WezTerm   |

---

## Neovim — Daily Essentials

**Leader key: `Space`** — press Space then the action key.
Neovim uses `fzf-lua` for fuzzy finding (via LazyVim).

### Fuzzy Finding — "Where is that file?"

| Keys              | Action                  | Remember                       |
|-------------------|-------------------------|--------------------------------|
| `Space Space`     | Find files              | Double-tap = "find anything"   |
| `Space /`         | Grep project            | `/` = search (same as vim)     |
| `Space fg`        | Live grep               | **f**ind by **g**rep           |
| `Space fb`        | Find buffers            | **f**ind **b**uffers           |
| `Space fr`        | Recent files            | **f**ind **r**ecent            |
| `Space fc`        | Find in config          | **f**ind **c**onfig            |
| `Space fR`        | Resume last search      | **f**ind **R**esume            |

**Inside fzf popup:**

| Keys              | Action                  | Remember                       |
|-------------------|-------------------------|--------------------------------|
| `Ctrl+j` / `Ctrl+k` | Navigate results     | Same vim up/down               |
| `Enter`           | Open file               | Confirm                        |
| `Ctrl+v`          | Open in vertical split  | **v**ertical                   |
| `Ctrl+x`          | Open in horizontal split| Like vim's `<C-w>s`           |
| `Esc`             | Close                   | Cancel                         |

### Movement — "The Vim Language"

```
        k
        ↑
   h ←     → l         h/j/k/l = character movement
        ↓               w/b    = word forward/back
        j                0/$   = line start/end
                        gg/G   = file start/end
```

| Keys    | Action                  | Remember                           |
|---------|-------------------------|------------------------------------|
| `w`     | Next word start         | **w**ord forward                   |
| `b`     | Previous word start     | **b**ack a word                    |
| `e`     | End of word             | **e**nd of this word               |
| `0`     | Start of line           | Column **0**                       |
| `$`     | End of line             | Regex: `$` = end                   |
| `^`     | First non-blank         | Regex: `^` = start                 |
| `gg`    | Top of file             | **g**o **g**o to the top           |
| `G`     | Bottom of file          | **G**o to the end                  |
| `{` `}` | Prev/next paragraph    | Curly braces = block boundaries    |
| `%`     | Matching bracket        | `%` = "the other half"             |
| `Ctrl+d`| Half page down          | **d**own                           |
| `Ctrl+u`| Half page up            | **u**p                             |
| `f{c}`  | Find char forward       | **f**ind the character             |
| `t{c}`  | Till char forward       | **t**ill (stop before) the char    |

### Editing — "Verb + Object"

```
The grammar: {verb}{motion or text object}

  d = delete    dw = delete word     dd = delete line
  c = change    ci" = change inside " cc = change line
  y = yank      yy = yank line       y$ = yank to end
  v = visual    viw = select word    V  = select line
```

| Keys    | Action                  | Remember                           |
|---------|-------------------------|------------------------------------|
| `i`     | Insert before cursor    | **i**nsert here                    |
| `a`     | Insert after cursor     | **a**ppend after                   |
| `o`     | New line below + insert | **o**pen a line below              |
| `O`     | New line above + insert | **O**pen a line above              |
| `x`     | Delete character        | **x** marks it for deletion        |
| `dd`    | Delete line             | **d**elete **d**ouble = whole line |
| `yy`    | Yank (copy) line        | **y**ank **y**ank = whole line     |
| `p`     | Paste after             | **p**ut it down                    |
| `P`     | Paste before            | **P**ut it up                      |
| `u`     | Undo                    | **u**ndo                           |
| `Ctrl+r`| Redo                    | **r**edo                           |
| `.`     | Repeat last action      | "Do **that** again"                |
| `ciw`   | Change inner word       | **c**hange **i**nside **w**ord     |
| `ci"`   | Change inside quotes    | **c**hange **i**nside **"**quotes  |
| `di(`   | Delete inside parens    | **d**elete **i**nside **(**parens  |
| `da{`   | Delete around braces    | **d**elete **a**round **{**braces  |
| `vi[`   | Select inside brackets  | **v**isual **i**nside **[**brackets|

### Search & Replace

| Keys          | Action                 | Remember                        |
|---------------|------------------------|---------------------------------|
| `/pattern`    | Search forward         | `/` = "look ahead"             |
| `?pattern`    | Search backward        | `?` = "look behind"            |
| `n`           | Next match             | **n**ext match                  |
| `N`           | Previous match         | **N** = reverse **n**ext        |
| `*`           | Search word under cursor| `*` = "this word everywhere"   |
| `:%s/old/new/g` | Replace all in file | **s**ubstitute globally         |

### Windows & Buffers

| Keys          | Action                  | Remember                       |
|---------------|-------------------------|--------------------------------|
| `:sp`         | Split horizontal        | **sp**lit                      |
| `:vsp`        | Split vertical          | **v**ertical **sp**lit         |
| `Ctrl+w h`    | Go to left split        | **w**indow + vim direction     |
| `Ctrl+w j`    | Go to split below       | **w**indow + vim direction     |
| `Ctrl+w k`    | Go to split above       | **w**indow + vim direction     |
| `Ctrl+w l`    | Go to right split       | **w**indow + vim direction     |
| `Ctrl+w =`    | Equalize split sizes    | `=` means "make equal"         |
| `:bn`         | Next buffer             | **b**uffer **n**ext            |
| `:bp`         | Previous buffer         | **b**uffer **p**revious        |
| `:bd`         | Close buffer            | **b**uffer **d**elete          |

### Practical Daily Commands

| Keys          | Action                  | Remember                       |
|---------------|-------------------------|--------------------------------|
| `:w`          | Save                    | **w**rite to disk              |
| `:q`          | Quit                    | **q**uit                       |
| `:wq` / `ZZ`  | Save and quit          | **w**rite + **q**uit           |
| `:q!`         | Quit without saving     | `!` = "I mean it!"            |
| `gd`          | Go to definition        | **g**o to **d**efinition       |
| `gr`          | Go to references        | **g**o to **r**eferences       |
| `K`           | Hover docs              | **K** = "look up"              |
| `gcc`         | Toggle comment line     | **g**o **c**omment **c**urrent |
| `gc`+motion   | Comment region          | **g**o **c**omment {motion}    |
| `>>`          | Indent line             | `>>` push right                |
| `<<`          | Unindent line           | `<<` pull left                 |
| `=`+motion    | Auto-indent             | `=` means "fix formatting"     |
| `:!cmd`       | Run shell command       | `!` = "shell out"              |

---

## Content Preview — `preview` Command

```bash
preview photo.png       # renders image inline
preview report.pdf      # extracts text with syntax highlighting
preview README.md       # beautiful markdown rendering
preview index.html      # text-based web rendering
preview data.json       # syntax-highlighted code
preview anything        # auto-detects via mime type
```

---

## Muscle Memory Drills

### Week 1: Navigation
Practice these 10 times each session until automatic:
1. `h/j/k/l` in Neovim — stop using arrow keys
2. `Cmd+. |` and `Cmd+. -` — split WezTerm panes
3. `Cmd+. h/j/k/l` — navigate WezTerm panes
4. `Cmd+. t` — new tab, `Cmd+. 1-3` — jump to tabs

### Week 2: Editing
5. `ciw` — change a word (most useful vim command)
6. `dd` then `p` — move a line
7. `v` + motion + `y` — visual select and copy
8. `/pattern` then `n` — search and jump through matches

### Week 3: Multiplexing
9. `Cmd+. s` — switch WezTerm workspaces
10. `C-a d` / `tmux a` — detach and reattach tmux sessions
11. `Cmd+. z` — zoom a pane, do focused work, zoom back
12. `Cmd+. e` — quick file tree exploration

### Week 4: Power Moves
13. `Cmd+. Space` — quick select URLs/paths/hashes
14. `ci"` / `ci(` / `ci{` — change inside any delimiter
15. `.` — repeat last edit (combine with `n` for search-replace)
16. `*` then `cgn` then `.` — replace word under cursor, one at a time

---

## Quick Reference Card

```
┌──────────────────────────────────────────────────────────┐
│  WezTerm: Cmd+.    Tmux: Ctrl+a    Neovim: Space (leader)│
├──────────────────────────────────────────────────────────┤
│  SPLIT    |  -       MOVE    h j k l    RESIZE  H J K L  │
│  TAB      t n p 1-9  ZOOM    z          CLOSE   x        │
│  SESSION  s S ( )    FIND    f          COPY    c        │
│  RELOAD   r          EXPLORE e          SWAP    d        │
│  Neovim:  Space Space = find files   Space / = grep      │
└──────────────────────────────────────────────────────────┘
```
