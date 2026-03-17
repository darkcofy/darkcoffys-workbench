# darkcoffys-workbench

Portable dev environment for Python, dbt, and SQL projects. Clone on any Linux/macOS machine, run one command, and everything is configured — editor, terminal, shell tools, git, Python toolchain, and AI agent workflows.

Two modes: **full** (GUI machine with WezTerm + VS Code) and **low-power** (headless/SSH/Pi with tmux + neovim).

## Quick Start

```bash
git clone https://github.com/darkcofy/darkcoffys-workbench.git
cd darkcoffys-workbench

./setup              # Full mode
./setup --low-power  # Low-power mode (or --lp)
```

That's it. Open a new terminal and everything works.

---

## What Gets Installed

### Both Modes

| Component | What it does |
|-----------|-------------|
| **neovim** | Editor with LSP, fuzzy finder, file tree, autocomplete |
| **starship** | Fast, informative shell prompt (git branch, Python venv, etc.) |
| **zoxide** | Smart `cd` — learns your directories, `z proj` jumps to `~/code/project` |
| **fzf** | Fuzzy finder — `Ctrl+R` for history, `Ctrl+T` for files |
| **direnv** | Auto-loads `.env` files when you enter a directory |
| **bat** | `cat` with syntax highlighting |
| **uv** | Fast Python package manager (replaces pip/venv) |
| **ruff** | Python linter + formatter |
| **pre-commit** | Git hooks for code quality |
| **git config** | Aliases, sane defaults (rebase on pull, auto-prune, etc.) |
| **shell integration** | One `source` line wires up everything — prompt, aliases, PATH |
| **CLI tools** | `onboard`, `scaffold`, `sqlprism-init`, `ssh-setup` |

### Full Mode Only

| Component | What it does |
|-----------|-------------|
| **WezTerm** | GPU-accelerated terminal with built-in splits/tabs |
| **VS Code** | Extensions (Python, dbt Power User, sqlfluff, Ruff, GitLens) + settings |
| **JetBrains Mono** | Nerd Font with ligatures and icons |
| **Docker** | Container runtime |

### Low-Power Mode Only

| Component | What it does |
|-----------|-------------|
| **tmux** | Terminal multiplexer (splits, sessions, works over SSH) |

---

## Directory Structure

```
darkcoffys-workbench/
├── setup                    ← main entry point (./setup or ./setup --lp)
├── Makefile                 ← individual targets (make nvim, make git-config, etc.)
│
├── bin/                     ← CLI tools (symlinked to ~/.local/bin)
│   ├── onboard              ← clone + auto-setup any repo
│   ├── scaffold             ← add AI agent configs to any project
│   ├── sqlprism-init        ← install sqlprism + index SQL files
│   ├── ssh-setup            ← generate SSH key for GitHub/GitLab
│   └── install-fonts        ← JetBrains Mono Nerd Font
│
├── agents/                  ← AI agent instruction templates
│   ├── config.yaml          ← central config (tickets, DB, paths)
│   ├── research.md          ← Socratic first-principles research agent
│   ├── sdlc.md              ← full dev lifecycle agent
│   ├── artifacts.md         ← where agents store generated files
│   └── templates/           ← project scaffolding templates
│       ├── sqlfluff.cfg     ← SQL linter config
│       ├── env.template     ← .env skeleton
│       ├── envrc            ← direnv config
│       ├── profiles.yml     ← dbt profiles template
│       └── pyproject.toml   ← Python project template
│
├── shell/                   ← shell configuration
│   ├── rc.sh                ← sources everything (starship, zoxide, direnv, fzf)
│   └── aliases.sh           ← all shell aliases
│
├── nvim/                    ← neovim config (Lua, lazy.nvim)
│   ├── init.lua
│   └── lua/plugins/
│
├── tmux/tmux.conf           ← tmux config (low-power mode)
├── wezterm/wezterm.lua      ← WezTerm config (full mode)
├── starship/starship.toml   ← prompt config
├── git/gitconfig            ← git aliases + defaults
├── vscode/                  ← VS Code settings + extensions
└── CHEATSHEET.md            ← keybinding reference
```

---

## CLI Tools

### `onboard` — Set up any repo in one command

```bash
onboard https://github.com/org/repo.git           # clone + auto-setup
onboard https://github.com/org/repo.git mydir      # clone into specific dir
onboard .                                           # setup current directory
onboard https://github.com/org/repo.git --scaffold  # clone + setup + agent configs
```

Auto-detects and handles:
- **Python** — creates venv, installs deps (uv or pip), installs ruff/pre-commit
- **dbt** — runs `dbt deps`, suggests profiles.yml setup
- **SQL** — finds `.sql` files, runs `sqlprism reindex`
- **pre-commit** — installs hooks
- **Makefile/justfile** — lists available targets
- **Docker Compose** — shows services

### `scaffold` — Add AI agent configs to any project

```bash
scaffold .              # scaffold current directory
scaffold /path/to/repo  # scaffold specific repo
```

Creates in the target project:
- `agents/config.yaml` — edit to set ticket engine, DB connections, paths
- `agents/research.md` — research agent instructions
- `agents/sdlc.md` — SDLC agent instructions
- `agents/artifacts.md` — artifact storage rules
- `.artifacts/` — output directories
- `CLAUDE.md` — AI agent project instructions
- `.cursorrules` — Cursor agent instructions
- `Makefile` — standard targets (lint, fmt, test + dbt targets if applicable)
- `.sqlfluff` — SQL linter config (for SQL/dbt projects)
- `.envrc` + `.env.template` — environment management
- `.pre-commit-config.yaml` — git hooks
- `sqlprism.yml` — SQL indexing config (for SQL/dbt projects)

### `sqlprism-init` — Set up sqlprism in any SQL project

```bash
sqlprism-init .              # current directory
sqlprism-init /path/to/repo  # specific repo
```

Installs sqlprism (via uv), creates config, runs initial reindex. For dbt projects, uses `sqlprism reindex-dbt` automatically.

### `ssh-setup` — Generate SSH key

```bash
ssh-setup                    # uses git user.email
ssh-setup your@email.com     # specify email
```

Generates ed25519 key, adds to ssh-agent, copies public key to clipboard, offers to test GitHub connectivity.

---

## Make Targets

Run any of these individually:

```bash
make help            # show all targets
make deps-lowpower   # install minimal packages
make deps-full       # install full packages (including WezTerm)
make shell-tools     # install starship, zoxide
make shell-rc        # wire up shell rc file (one source line)
make python-tools    # install uv, ruff, pre-commit
make git-config      # link git aliases + defaults
make nvim            # symlink neovim config
make tmux            # symlink tmux config
make wezterm         # symlink WezTerm config
make vscode          # install VS Code extensions + settings
make fonts           # install JetBrains Mono Nerd Font
make ssh-setup       # generate SSH key
make docker          # install Docker
make onboard-link    # link CLI tools to ~/.local/bin
make uninstall       # remove all symlinks
```

---

## Keybindings

### WezTerm (full mode)

| Key | Action |
|-----|--------|
| `Ctrl+Shift+D` | Split horizontal |
| `Ctrl+Shift+E` | Split vertical |
| `Ctrl+Shift+W` | Close pane |
| `Alt+h/j/k/l` | Navigate panes |
| `Alt+Shift+H/J/K/L` | Resize panes |
| `Ctrl+Shift+T` | New tab |
| `Ctrl+1..9` | Switch to tab |
| `Ctrl+Shift+[/]` | Prev/next tab |

### tmux (low-power mode, prefix = `Ctrl+Space`)

| Key | Action |
|-----|--------|
| `prefix \|` | Split horizontal |
| `prefix -` | Split vertical |
| `prefix h/j/k/l` | Navigate panes |
| `prefix H/J/K/L` | Resize panes |
| `prefix c` | New window |
| `prefix 1-9` | Switch window |
| `prefix d` | Detach session |
| `prefix r` | Reload config |
| `prefix [` | Copy mode (vi keys) |

Reattach: `tmux attach` or `tmux a`

### neovim (leader = `Space`)

| Key | Action |
|-----|--------|
| `Space e` | Toggle file tree |
| `Space ff` | Find files (fuzzy) |
| `Space fg` | Live grep across project |
| `Space fb` | Switch buffers |
| `Space /` | Search current buffer |
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Hover docs |
| `Space ca` | Code action |
| `Space rn` | Rename symbol |
| `Space d` | Line diagnostics |
| `gcc` | Toggle comment (line) |
| `gc` (visual) | Toggle comment (selection) |
| `Ctrl+h/j/k/l` | Navigate splits |

### Shell

| Key/Command | Action |
|-------------|--------|
| `Ctrl+R` | Fuzzy search command history (fzf) |
| `Ctrl+T` | Fuzzy find file in current dir (fzf) |
| `z <dir>` | Jump to directory (zoxide — learns your habits) |

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

---

## AI Agent System

When you run `scaffold .` in a project, it sets up three agents:

### Research Agent (`agents/research.md`)

Uses Socratic questioning grounded in first principles:

1. What problem are we actually solving?
2. What do we already know?
3. What are we assuming? (mark as verified/unverified)
4. What are the constraints?
5. What's the simplest version?
6. What would make this fail?
7. What don't we know that we need to?

Outputs go to `.artifacts/research/YYYY-MM-DD_<slug>.md` in a structured format with recommendations ranked by confidence.

### SDLC Agent (`agents/sdlc.md`)

Full development lifecycle:

```
1. INGEST    Read issue from ticket engine (GitHub/Jira/Linear)
2. PLAN      Break into tasks → save as .artifacts/tasks/<id>/tasks.json
3. EXECUTE   Work tasks by parallel group, commit after each
4. VERIFY    Full lint + test suite
5. DELIVER   Push branch, create PR, update ticket
```

Task list format (`.artifacts/tasks/<issue-id>/tasks.json`):
```json
{
  "issue_id": "GH-42",
  "tasks": [
    {
      "id": "T1",
      "title": "Add CSV serializer",
      "status": "pending",
      "depends_on": [],
      "parallel_group": "A",
      "acceptance": "Unit test passes"
    }
  ]
}
```

### Artifacts Agent (`agents/artifacts.md`)

Controls where everything is saved:

```
.artifacts/
├── research/     ← research outputs (persisted, committed)
├── tasks/        ← task lists and progress (persisted, committed)
├── reports/      ← summaries (persisted, committed)
└── scratch/      ← temporary files (gitignored)
```

### Config (`agents/config.yaml`)

Edit this per-project to configure:
- **Ticket engine** — `github`, `jira`, or `linear`
- **Repo settings** — default branch, branch prefix, commit style
- **MCP connections** — database servers
- **GitHub** — auto-PR, reviewers
- **Research** — max depth, first-principles questions

---

## Typical Workflows

### Day 1 at a new job

```bash
# 1. Set up your machine
git clone https://github.com/darkcofy/darkcoffys-workbench.git
cd darkcoffys-workbench
./setup                    # or ./setup --lp for SSH-only machines

# 2. Set up SSH for GitHub/GitLab
ssh-setup

# 3. Clone and onboard the team's repo
onboard git@github.com:company/their-repo.git --scaffold

# 4. Configure project connections
cd their-repo
nvim agents/config.yaml    # set ticket engine, DB, etc.
cp .env.template .env      # fill in credentials
direnv allow               # auto-load env vars
```

### Starting work on an issue

```bash
# Agent reads issue, creates task list, works through it
# Or manually:
cd project
git cb feat-my-feature     # create branch
# ... write code ...
make lint                  # ruff check
make test                  # pytest
make lint-sql              # sqlfluff (if SQL project)
gs                         # git status
ga .                       # git add
gcm "feat: add thing"      # commit
gp                         # push
```

### Exploring a new codebase

```bash
# In neovim:
Space ff    # find any file by name
Space fg    # grep across entire project
Space e     # browse file tree
gd          # jump to definition
gr          # find all references
K           # read docs for symbol under cursor
```

---

## Updating

```bash
cd darkcoffys-workbench
gpl              # git pull
./setup          # re-run to pick up new tools/configs
```

Configs are symlinked, so most changes take effect immediately without re-running setup.

## Uninstalling

```bash
cd darkcoffys-workbench
./setup --uninstall    # or: make uninstall
```

Removes all symlinks. Does not uninstall packages.
