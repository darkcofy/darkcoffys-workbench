#!/usr/bin/env bash
set -euo pipefail

# ──────────────────────────────────────────────
# darkcoffys-workbench :: test suite
# ──────────────────────────────────────────────
# Run: ./tests/run-tests.sh
# Or:  make test
# ──────────────────────────────────────────────

WORKBENCH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_SKIPPED=0

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
DIM='\033[2m'
RESET='\033[0m'

pass() { echo -e "  ${GREEN}✓${RESET} $1"; TESTS_PASSED=$((TESTS_PASSED + 1)); }
fail() { echo -e "  ${RED}✗${RESET} $1"; TESTS_FAILED=$((TESTS_FAILED + 1)); }
skp()  { echo -e "  ${YELLOW}○${RESET} $1 ${DIM}(skipped)${RESET}"; TESTS_SKIPPED=$((TESTS_SKIPPED + 1)); }

echo ""
echo "  darkcoffys-workbench tests"
echo "  ══════════════════════════"
echo ""

# ══════════════════════════════════════════════
# 1. File structure tests
# ══════════════════════════════════════════════
echo "  File structure"
echo "  ──────────────"

REQUIRED_FILES=(
    "setup"
    "Makefile"
    "LICENSE"
    ".gitignore"
    "README.md"
    "CHEATSHEET.md"
    "lib/common.sh"
    "shell/rc.sh"
    "shell/aliases.sh"
    "git/gitconfig"
    "tmux/tmux.conf"
    "wezterm/wezterm.lua"
    "starship/starship.toml"
    "nvim/init.lua"
    "nvim/lua/plugins/colorscheme.lua"
    "nvim/lua/plugins/editor.lua"
    "nvim/lua/plugins/lsp.lua"
    "vscode/settings.json"
    "vscode/keybindings.json"
    "vscode/extensions.txt"
    "agents/config.yaml"
    "agents/research.md"
    "agents/sdlc.md"
    "agents/artifacts.md"
    "agents/impact-analysis.md"
    "agents/templates/sqlfluff.cfg"
    "agents/templates/env.template"
    "agents/templates/envrc"
    "agents/templates/profiles.yml"
    "agents/templates/pyproject.toml"
    "agents/templates/design-review.md"
    "agents/templates/modeling-conventions.md"
    "agents/templates/data-quality.yml"
    "agents/templates/domain-ownership.yml"
    "agents/templates/adrs/000-template.md"
    "agents/templates/runbooks/data-incident.md"
    "agents/templates/diagrams/erd.mmd"
    "agents/templates/diagrams/data-lineage.mmd"
    "agents/templates/diagrams/data-flow.mmd"
    "agents/templates/diagrams/sdlc-flow.mmd"
    "team/TEMPLATE-promotion-tracker.yml"
    "team/TEMPLATE-roster.yml"
    "team/README.md"
    "team/engagements/TEMPLATE.yml"
    "team/one-on-ones/TEMPLATE.md"
    "team/weekly-status/TEMPLATE.md"
    "team/personal/TEMPLATE-first-90-days.md"
)

for f in "${REQUIRED_FILES[@]}"; do
    if [[ -f "$WORKBENCH_DIR/$f" ]]; then
        pass "$f exists"
    else
        fail "$f MISSING"
    fi
done

REQUIRED_SCRIPTS=(
    "bin/onboard"
    "bin/scaffold"
    "bin/sqlprism-init"
    "bin/ssh-setup"
    "bin/install-fonts"
    "bin/team-status"
)

echo ""
echo "  Executables"
echo "  ──────────────"

for s in "${REQUIRED_SCRIPTS[@]}"; do
    if [[ -x "$WORKBENCH_DIR/$s" ]]; then
        pass "$s is executable"
    else
        fail "$s NOT executable"
    fi
done

# ══════════════════════════════════════════════
# 2. Shell script syntax checks
# ══════════════════════════════════════════════
echo ""
echo "  Syntax checks"
echo "  ──────────────"

SHELL_FILES=(
    "setup"
    "lib/common.sh"
    "shell/rc.sh"
    "shell/aliases.sh"
    "bin/onboard"
    "bin/scaffold"
    "bin/sqlprism-init"
    "bin/ssh-setup"
    "bin/install-fonts"
    "bin/team-status"
)

for f in "${SHELL_FILES[@]}"; do
    if bash -n "$WORKBENCH_DIR/$f" 2>/dev/null; then
        pass "$f syntax ok"
    else
        fail "$f has syntax errors"
    fi
done

# ══════════════════════════════════════════════
# 3. Makefile syntax check
# ══════════════════════════════════════════════
echo ""
echo "  Makefile"
echo "  ──────────────"

if make -C "$WORKBENCH_DIR" -n help &>/dev/null; then
    pass "Makefile parses correctly"
else
    fail "Makefile has errors"
fi

# Check all expected targets exist
EXPECTED_TARGETS=(
    help deps-lowpower deps-full shell-tools shell-rc
    python-tools git-config onboard-link tmux nvim
    wezterm vscode fonts ssh-setup docker mermaid
    uninstall clean
)

for target in "${EXPECTED_TARGETS[@]}"; do
    if make -C "$WORKBENCH_DIR" -n "$target" &>/dev/null; then
        pass "make $target exists"
    else
        fail "make $target MISSING"
    fi
done

# ══════════════════════════════════════════════
# 4. lib/common.sh tests
# ══════════════════════════════════════════════
echo ""
echo "  lib/common.sh"
echo "  ──────────────"

# Test that sourcing common.sh works and provides expected functions
COMMON_TEST=$(bash -c "
source '$WORKBENCH_DIR/lib/common.sh'
type info &>/dev/null && echo 'info:ok' || echo 'info:fail'
type warn &>/dev/null && echo 'warn:ok' || echo 'warn:fail'
type step &>/dev/null && echo 'step:ok' || echo 'step:fail'
type err &>/dev/null && echo 'err:ok' || echo 'err:fail'
type skip &>/dev/null && echo 'skip:ok' || echo 'skip:fail'
type resolve_path &>/dev/null && echo 'resolve_path:ok' || echo 'resolve_path:fail'
type sed_inplace &>/dev/null && echo 'sed_inplace:ok' || echo 'sed_inplace:fail'
" 2>&1)

for func in info warn step err skip resolve_path sed_inplace; do
    if echo "$COMMON_TEST" | grep -q "$func:ok"; then
        pass "$func() is defined"
    else
        fail "$func() NOT defined"
    fi
done

# Test resolve_path with a real symlink
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT
echo "test" > "$TMPDIR/real_file.sh"
ln -sf "$TMPDIR/real_file.sh" "$TMPDIR/link.sh"

RESOLVED=$(bash -c "source '$WORKBENCH_DIR/lib/common.sh'; resolve_path '$TMPDIR/link.sh'")
if [[ "$RESOLVED" == "$TMPDIR/real_file.sh" ]]; then
    pass "resolve_path resolves symlinks correctly"
else
    fail "resolve_path returned '$RESOLVED', expected '$TMPDIR/real_file.sh'"
fi

# Test sed_inplace
echo "hello world" > "$TMPDIR/sed_test.txt"
bash -c "source '$WORKBENCH_DIR/lib/common.sh'; sed_inplace 's/hello/goodbye/' '$TMPDIR/sed_test.txt'"
if grep -q "goodbye world" "$TMPDIR/sed_test.txt"; then
    pass "sed_inplace works on this OS"
else
    fail "sed_inplace did not modify file"
fi

# ══════════════════════════════════════════════
# 5. Scaffold test (in temp dir)
# ══════════════════════════════════════════════
echo ""
echo "  scaffold (integration)"
echo "  ──────────────"

SCAFFOLD_DIR="$TMPDIR/test-project"
mkdir -p "$SCAFFOLD_DIR"
cd "$SCAFFOLD_DIR"
git init -q
mkdir -p models
echo "SELECT 1" > models/test.sql
echo "name: test_project" > dbt_project.yml
touch pyproject.toml

# Run scaffold
"$WORKBENCH_DIR/bin/scaffold" . &>/dev/null

# Check what was created
SCAFFOLD_EXPECTED=(
    "agents/config.yaml"
    "agents/research.md"
    "agents/sdlc.md"
    "agents/artifacts.md"
    "agents/impact-analysis.md"
    "CLAUDE.md"
    ".cursorrules"
    ".windsurfrules"
    ".clinerules"
    "AGENTS.md"
    ".github/copilot-instructions.md"
    ".artifacts/research"
    ".artifacts/tasks"
    ".artifacts/scratch"
    "Makefile"
    ".envrc"
    ".env.template"
    ".sqlfluff"
    "domain-ownership.yml"
    "modeling-conventions.md"
)

for f in "${SCAFFOLD_EXPECTED[@]}"; do
    if [[ -e "$SCAFFOLD_DIR/$f" ]]; then
        pass "scaffold created $f"
    else
        fail "scaffold MISSING $f"
    fi
done

# Verify .sqlfluff has raw templater (not dbt, since we faked a dbt project but this tests the real case)
# Actually the dbt_project.yml exists so it should be dbt
if grep -q "templater = dbt" "$SCAFFOLD_DIR/.sqlfluff" 2>/dev/null; then
    pass ".sqlfluff has dbt templater (detected dbt project)"
else
    fail ".sqlfluff should have dbt templater"
fi

# Verify Makefile has dbt targets
if grep -q "dbt-build" "$SCAFFOLD_DIR/Makefile" 2>/dev/null; then
    pass "Makefile has dbt targets"
else
    fail "Makefile missing dbt targets"
fi

# Verify Makefile has sql targets
if grep -q "lint-sql" "$SCAFFOLD_DIR/Makefile" 2>/dev/null; then
    pass "Makefile has lint-sql target"
else
    fail "Makefile missing lint-sql target"
fi

# Verify CLAUDE.md has dbt instructions
if grep -q "sqlprism" "$SCAFFOLD_DIR/CLAUDE.md" 2>/dev/null; then
    pass "CLAUDE.md references sqlprism"
else
    fail "CLAUDE.md missing sqlprism reference"
fi

# Verify .env is in .gitignore
if grep -q "^\.env$" "$SCAFFOLD_DIR/.gitignore" 2>/dev/null; then
    pass ".gitignore includes .env"
else
    fail ".gitignore missing .env"
fi

# Verify all AI instruction files have the same core content
AI_FILES=(".cursorrules" ".windsurfrules" ".clinerules" "AGENTS.md" ".github/copilot-instructions.md")
REFERENCE_CONTENT=$(grep "agents/research.md" "$SCAFFOLD_DIR/.cursorrules" 2>/dev/null || echo "")
if [[ -n "$REFERENCE_CONTENT" ]]; then
    ALL_MATCH=true
    for aif in "${AI_FILES[@]}"; do
        if ! grep -q "agents/research.md" "$SCAFFOLD_DIR/$aif" 2>/dev/null; then
            ALL_MATCH=false
            fail "AI instruction file $aif missing agent references"
        fi
    done
    $ALL_MATCH && pass "All AI instruction files reference agents/"
else
    fail "AI instruction files have no agent references"
fi

# ══════════════════════════════════════════════
# 6. Scaffold idempotency test
# ══════════════════════════════════════════════
echo ""
echo "  scaffold (idempotency)"
echo "  ──────────────"

# Run scaffold again — should skip everything, not error
SCAFFOLD_OUTPUT=$("$WORKBENCH_DIR/bin/scaffold" "$SCAFFOLD_DIR" 2>&1)

if [[ $? -eq 0 ]]; then
    pass "scaffold runs twice without errors"
else
    fail "scaffold failed on second run"
fi

if echo "$SCAFFOLD_OUTPUT" | grep -q "already exists"; then
    pass "scaffold skips existing files on re-run"
else
    fail "scaffold should report skipped files"
fi

# ══════════════════════════════════════════════
# 7. Git config test
# ══════════════════════════════════════════════
echo ""
echo "  git/gitconfig"
echo "  ──────────────"

# Check gitconfig is valid
if git config --file "$WORKBENCH_DIR/git/gitconfig" --list &>/dev/null; then
    pass "gitconfig is valid"
else
    fail "gitconfig has parse errors"
fi

# Check expected aliases exist
for alias in s l co cb undo unstage sync pf whoami; do
    if git config --file "$WORKBENCH_DIR/git/gitconfig" "alias.$alias" &>/dev/null; then
        pass "git alias '$alias' defined"
    else
        fail "git alias '$alias' MISSING"
    fi
done

# ══════════════════════════════════════════════
# 8. YAML validity (if yq available)
# ══════════════════════════════════════════════
echo ""
echo "  YAML validity"
echo "  ──────────────"

if command -v yq &>/dev/null; then
    YAML_FILES=(
        "agents/config.yaml"
        "agents/templates/data-quality.yml"
        "agents/templates/domain-ownership.yml"
        "agents/templates/profiles.yml"
        "team/TEMPLATE-promotion-tracker.yml"
        "team/TEMPLATE-roster.yml"
        "team/engagements/TEMPLATE.yml"
    )

    for yf in "${YAML_FILES[@]}"; do
        if yq '.' "$WORKBENCH_DIR/$yf" &>/dev/null; then
            pass "$yf is valid YAML"
        else
            fail "$yf has YAML parse errors"
        fi
    done
else
    skp "YAML validation (yq not installed)"
fi

# ══════════════════════════════════════════════
# 9. Lua syntax (if luacheck or nvim available)
# ══════════════════════════════════════════════
echo ""
echo "  Lua syntax"
echo "  ──────────────"

LUA_FILES=(
    "nvim/init.lua"
    "nvim/lua/plugins/colorscheme.lua"
    "nvim/lua/plugins/editor.lua"
    "nvim/lua/plugins/lsp.lua"
    "wezterm/wezterm.lua"
)

if command -v luac &>/dev/null; then
    for lf in "${LUA_FILES[@]}"; do
        if luac -p "$WORKBENCH_DIR/$lf" 2>/dev/null; then
            pass "$lf syntax ok"
        else
            fail "$lf has Lua syntax errors"
        fi
    done
elif command -v nvim &>/dev/null; then
    for lf in "${LUA_FILES[@]}"; do
        if nvim --headless -c "luafile $WORKBENCH_DIR/$lf" -c "q" 2>/dev/null; then
            pass "$lf loads in nvim"
        else
            # nvim lua loading can fail due to missing plugins — not a syntax error
            skp "$lf (nvim load — plugins may not be installed)"
        fi
    done
else
    skp "Lua syntax checks (no luac or nvim)"
fi

# ══════════════════════════════════════════════
# 10. JSON validity
# ══════════════════════════════════════════════
echo ""
echo "  JSON validity"
echo "  ──────────────"

JSON_FILES=(
    "vscode/settings.json"
    "vscode/keybindings.json"
)

for jf in "${JSON_FILES[@]}"; do
    if python3 -m json.tool "$WORKBENCH_DIR/$jf" &>/dev/null; then
        pass "$jf is valid JSON"
    elif command -v jq &>/dev/null && jq '.' "$WORKBENCH_DIR/$jf" &>/dev/null; then
        pass "$jf is valid JSON"
    else
        fail "$jf has JSON parse errors"
    fi
done

# ══════════════════════════════════════════════
# 11. Security checks
# ══════════════════════════════════════════════
echo ""
echo "  Security"
echo "  ──────────────"

# Check .gitignore has sensitive patterns
GITIGNORE="$WORKBENCH_DIR/.gitignore"
for pattern in ".env" ".venv/" "__pycache__/" "team/engagements/*.yml"; do
    if grep -qF "$pattern" "$GITIGNORE" 2>/dev/null; then
        pass ".gitignore has '$pattern'"
    else
        fail ".gitignore MISSING '$pattern'"
    fi
done

# Check templates don't have real secrets
for f in "$WORKBENCH_DIR"/agents/templates/env.template "$WORKBENCH_DIR"/agents/templates/profiles.yml; do
    if grep -iE '(password|secret|token)\s*[:=]\s*\S' "$f" 2>/dev/null | grep -vq 'env_var\|HINT\|TODO\|example\|placeholder\|{%\|{{'; then
        fail "$(basename "$f") may contain real credentials"
    else
        pass "$(basename "$f") has no real credentials"
    fi
done

# Check LICENSE exists
if [[ -f "$WORKBENCH_DIR/LICENSE" ]]; then
    pass "LICENSE file exists"
else
    fail "LICENSE file MISSING"
fi

# ══════════════════════════════════════════════
# Summary
# ══════════════════════════════════════════════
echo ""
echo "  ══════════════════════════"
TOTAL=$((TESTS_PASSED + TESTS_FAILED + TESTS_SKIPPED))

if [[ $TESTS_FAILED -eq 0 ]]; then
    echo -e "  ${GREEN}All $TOTAL tests passed${RESET} ($TESTS_PASSED passed, $TESTS_SKIPPED skipped)"
else
    echo -e "  ${RED}$TESTS_FAILED failed${RESET}, $TESTS_PASSED passed, $TESTS_SKIPPED skipped (of $TOTAL)"
fi
echo ""

exit $TESTS_FAILED
