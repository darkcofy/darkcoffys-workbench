# Quickstart

## New machine? Set up in 2 minutes:

```bash
git clone https://github.com/darkcofy/darkcoffys-workbench.git
cd darkcoffys-workbench
./setup         # full mode (GUI)
./setup --lp    # low-power mode (terminal only)
```

## Joining a project? Onboard in 1 minute:

```bash
onboard https://github.com/org/repo.git --scaffold
```

## Not a manager? Here's what matters for you:

1. **`./setup`** sets up your editor, terminal, shell tools, git config, and Python toolchain
2. **`onboard <repo-url>`** clones a repo and installs all dependencies automatically
3. **`scaffold .`** adds AI agent configs — so Claude/Cursor/Copilot follow team conventions
4. **Ignore the `team/` directory** — that's for managers tracking engagements and people

## Day-to-day commands:

```bash
z myproject       # jump to any directory (learns your habits)
nvim .            # open editor (Space+ff to find files, Space+fg to grep)
gs                # git status
gl                # git log
activate          # source .venv/bin/activate
make lint         # run linter
make test         # run tests
```

## Full docs:

- [README.md](README.md) — everything in detail
- [CHEATSHEET.md](CHEATSHEET.md) — all keybindings and aliases
- [team/README.md](team/README.md) — management system (managers only)
