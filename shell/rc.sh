# ──────────────────────────────────────────────
# darkcoffys-workbench :: shell bootstrap
# ──────────────────────────────────────────────
# Source this from your .bashrc or .zshrc:
#   source ~/darkcoffys-workbench/shell/rc.sh
#
# Auto-detects bash vs zsh. Safe to source if
# tools aren't installed yet (guards everything).
# ──────────────────────────────────────────────

# ── Detect shell ──
if [ -n "$ZSH_VERSION" ]; then
    DCWS_SHELL="zsh"
elif [ -n "$BASH_VERSION" ]; then
    DCWS_SHELL="bash"
else
    DCWS_SHELL="sh"
fi

# ── PATH additions ──
# ~/.local/bin (workbench CLI tools, uv, etc.)
[[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && export PATH="$HOME/.local/bin:$PATH"

# uv/cargo bin
[[ -d "$HOME/.cargo/bin" ]] && [[ ":$PATH:" != *":$HOME/.cargo/bin:"* ]] && export PATH="$HOME/.cargo/bin:$PATH"

# ── Starship prompt ──
if command -v starship &>/dev/null; then
    eval "$(starship init "$DCWS_SHELL")"
fi

# ── zoxide (smart cd) ──
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init "$DCWS_SHELL")"
fi

# ── direnv (auto-load .env/.envrc) ──
if command -v direnv &>/dev/null; then
    eval "$(direnv hook "$DCWS_SHELL")"
fi

# ── fzf keybindings ──
if command -v fzf &>/dev/null; then
    # fzf 0.48+ uses this method
    if [[ "$DCWS_SHELL" == "zsh" ]]; then
        source <(fzf --zsh 2>/dev/null) || {
            # Fallback: search known paths for fzf shell integration
            for fzf_path in \
                /usr/share/doc/fzf/examples \
                /usr/share/fzf \
                /opt/homebrew/opt/fzf/shell \
                /usr/local/opt/fzf/shell; do
                if [[ -d "$fzf_path" ]]; then
                    [[ -f "$fzf_path/key-bindings.zsh" ]] && source "$fzf_path/key-bindings.zsh"
                    [[ -f "$fzf_path/completion.zsh" ]] && source "$fzf_path/completion.zsh"
                    break
                fi
            done
        }
    elif [[ "$DCWS_SHELL" == "bash" ]]; then
        eval "$(fzf --bash 2>/dev/null)" || {
            # Fallback: search known paths for fzf shell integration
            for fzf_path in \
                /usr/share/doc/fzf/examples \
                /usr/share/fzf \
                /opt/homebrew/opt/fzf/shell \
                /usr/local/opt/fzf/shell; do
                if [[ -d "$fzf_path" ]]; then
                    [[ -f "$fzf_path/key-bindings.bash" ]] && source "$fzf_path/key-bindings.bash"
                    break
                fi
            done
        }
    fi
fi

# ── fzf config ──
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --margin=1"
if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
elif command -v fdfind &>/dev/null; then
    export FZF_DEFAULT_COMMAND="fdfind --type f --hidden --exclude .git"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# ── Source aliases ──
DCWS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")/.." 2>/dev/null && pwd)"
if [[ -f "$DCWS_DIR/shell/aliases.sh" ]]; then
    source "$DCWS_DIR/shell/aliases.sh"
fi
