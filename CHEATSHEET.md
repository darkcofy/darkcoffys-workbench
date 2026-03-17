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

---

## Shell Aliases

All aliases are loaded automatically via `shell/rc.sh`.

### Navigation & Files

| Alias | Expands to |
|-------|-----------|
| `..` / `...` / `....` | `cd ..` / `../..` / `../../..` |
| `ll` | `eza -la` (or `ls -lah`) |
| `lt` | tree view (2 levels) |
| `cat` | `bat` (syntax highlighted, if installed) |

### Python

| Alias | Expands to |
|-------|-----------|
| `py` | `python3` |
| `ipy` | `ipython` |
| `venv` | create + activate `.venv` |
| `activate` | `source .venv/bin/activate` |
| `uvs` | `uv sync` |
| `uvr` | `uv run` |

### Git

| Alias | Expands to |
|-------|-----------|
| `g` | `git` |
| `gs` | `git status -sb` |
| `gl` | `git log --oneline --graph` |
| `gd` / `gds` | `git diff` / `git diff --staged` |
| `ga` / `gap` | `git add` / `git add -p` |
| `gcm` | `git commit -m` |
| `gp` / `gpl` | `git push` / `git pull` |

### Git Config Aliases (via `git <alias>`)

| Alias | What it does |
|-------|-------------|
| `git s` | short status |
| `git l` | pretty log (20 lines) |
| `git la` | all branches log |
| `git cb <name>` | create + switch branch |
| `git br` | branches sorted by date |
| `git undo` | undo last commit (keep changes) |
| `git unstage` | unstage files |
| `git sync` | fetch + rebase on current branch |
| `git pf` | push force-with-lease (safe force push) |
| `git prune-gone` | delete local branches whose remote is gone |
| `git ds` | diff staged changes |
| `git dw` | word diff |
| `git whoami` | show current git identity |

### Docker

| Alias | Expands to |
|-------|-----------|
| `dc` | `docker compose` |
| `dcu` | `docker compose up -d` |
| `dcd` | `docker compose down` |
| `dcl` | `docker compose logs -f` |

### dbt

| Alias | Expands to |
|-------|-----------|
| `dbtb` | `dbt build` |
| `dbtr` | `dbt run` |
| `dbtt` | `dbt test` |
| `dbtc` | `dbt compile` |
| `dbtd` | `dbt deps` |

### Misc

| Alias | What it does |
|-------|-------------|
| `ports` | show listening ports |
| `myip` | show external IP |
| `reload` | re-source your shell rc |
| `path` | print PATH entries (one per line) |
