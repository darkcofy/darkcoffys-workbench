#!/usr/bin/env bash
# ──────────────────────────────────────────────
# darkcoffys-workbench :: shared helpers
# ──────────────────────────────────────────────
# Source this from any bin/ script. Provides:
#   resolve_path, sed_inplace, info, warn, step, err, skip
# ──────────────────────────────────────────────

# ── Colors ──
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
DIM='\033[2m'
RED='\033[0;31m'
BOLD='\033[1m'
RESET='\033[0m'

# ── Output helpers ──
info()  { echo -e "${GREEN}  ✓ $*${RESET}"; }
warn()  { echo -e "${YELLOW}  → $*${RESET}"; }
step()  { echo -e "${CYAN}  ▸ $*${RESET}"; }
err()   { echo -e "${RED}  ✗ $*${RESET}"; }
skip()  { echo -e "${DIM}  - $* (already exists, skipping)${RESET}"; }

# ── Resolve symlinks portably (works on both Linux and macOS) ──
resolve_path() {
    local target="$1"
    while [ -L "$target" ]; do
        local dir="$(cd "$(dirname "$target")" && pwd)"
        target="$(readlink "$target")"
        [[ "$target" != /* ]] && target="$dir/$target"
    done
    echo "$(cd "$(dirname "$target")" && pwd)/$(basename "$target")"
}

# ── Portable sed in-place (macOS requires '' after -i, GNU does not) ──
sed_inplace() {
    if [[ "$(uname -s)" == "Darwin" ]]; then
        sed -i '' "$@"
    else
        sed -i "$@"
    fi
}
