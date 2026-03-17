# darkcoffys-workbench cheatsheet

## Setup

```bash
./setup                # Full mode:  WezTerm + VS Code + neovim + shell tools
./setup --low-power    # Low-power:  tmux + neovim + shell tools
./setup --lp           # Same as --low-power
```

---

## WezTerm (full mode)

| Key                | Action              |
|--------------------|---------------------|
| `Ctrl+Shift+D`     | Split horizontal    |
| `Ctrl+Shift+E`     | Split vertical      |
| `Ctrl+Shift+W`     | Close pane          |
| `Alt+h/j/k/l`      | Navigate panes      |
| `Alt+Shift+H/J/K/L`| Resize panes        |
| `Ctrl+Shift+T`     | New tab             |
| `Ctrl+1..9`        | Switch to tab       |
| `Ctrl+Shift+[/]`   | Prev/next tab       |

## tmux (low-power mode, prefix = Ctrl-Space)

| Key              | Action                |
|------------------|-----------------------|
| `prefix \|`      | Split horizontal      |
| `prefix -`       | Split vertical        |
| `prefix h/j/k/l` | Navigate panes       |
| `prefix H/J/K/L` | Resize panes         |
| `prefix c`       | New window            |
| `prefix 1-9`     | Switch window         |
| `prefix d`       | Detach session        |
| `prefix r`       | Reload config         |
| `prefix [`       | Copy mode (vi keys)   |

Reattach: `tmux attach` or `tmux a`

---

## neovim (both modes, leader = Space)

| Key              | Action                     |
|------------------|----------------------------|
| `Space e`        | Toggle file tree           |
| `Space ff`       | Find files (fuzzy)         |
| `Space fg`       | Live grep across project   |
| `Space fb`       | Switch buffers             |
| `Space /`        | Search current buffer      |
| `gd`             | Go to definition           |
| `gr`             | Find references            |
| `K`              | Hover docs                 |
| `Space ca`       | Code action                |
| `Space rn`       | Rename symbol              |
| `Space d`        | Line diagnostics           |
| `gcc`            | Toggle comment (line)      |
| `gc` (visual)    | Toggle comment (selection) |
| `Ctrl+h/j/k/l`  | Navigate splits            |

---

## Shell tools (both modes)

| Command         | Action                               |
|-----------------|--------------------------------------|
| `z <dir>`       | Jump to directory (zoxide, learns)   |
| `Ctrl+R`        | Fuzzy search command history (fzf)   |
| `Ctrl+T`        | Fuzzy find file in current dir (fzf) |
