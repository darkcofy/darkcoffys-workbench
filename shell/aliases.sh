# ──────────────────────────────────────────────
# darkcoffys-workbench :: shell aliases
# ──────────────────────────────────────────────
# Sourced automatically by rc.sh

# ── Navigation ──
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# ── Listing ──
if command -v eza &>/dev/null; then
    alias ls="eza --icons"
    alias ll="eza -la --icons --git"
    alias lt="eza -laT --icons --git --level=2"
elif command -v exa &>/dev/null; then
    alias ls="exa --icons"
    alias ll="exa -la --icons --git"
    alias lt="exa -laT --icons --git --level=2"
else
    alias ll="ls -lah"
    alias lt="ls -lahR"
fi

# ── Cat → bat (if installed) ──
if command -v bat &>/dev/null; then
    alias cat="bat --paging=never --style=plain"
    alias catn="bat --paging=never"
fi

# ── Python ──
alias py="python3"
alias ipy="ipython"
alias venv="python3 -m venv .venv && source .venv/bin/activate"
alias activate="source .venv/bin/activate"
alias deactivate_="deactivate 2>/dev/null; echo 'deactivated'"

# ── uv shortcuts ──
if command -v uv &>/dev/null; then
    alias uvs="uv sync"
    alias uvr="uv run"
    alias uvp="uv pip"
fi

# ── Docker ──
alias dc="docker compose"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dcl="docker compose logs -f"
alias dcp="docker compose ps"

# ── Git (supplement the gitconfig aliases) ──
alias g="git"
alias gs="git status -sb"
alias gl="git log --oneline --graph --decorate -20"
alias gd="git diff"
alias gds="git diff --staged"
alias ga="git add"
alias gap="git add -p"
alias gcm="git commit -m"
alias gp="git push"
alias gpl="git pull"

# ── dbt ──
alias dbtb="dbt build"
alias dbtr="dbt run"
alias dbtt="dbt test"
alias dbtc="dbt compile"
alias dbtd="dbt deps"

# ── Misc ──
alias ports="ss -tlnp"
alias myip="curl -s ifconfig.me"
alias reload="source ~/.$(basename $SHELL)rc"
alias path='echo -e "${PATH//:/\\n}"'

# ── Quick edit ──
alias zshrc="${EDITOR:-nvim} ~/.zshrc"
alias bashrc="${EDITOR:-nvim} ~/.bashrc"
