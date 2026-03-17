SHELL := /bin/bash
.DEFAULT_GOAL := help

# Detect OS
UNAME := $(shell uname -s)

# XDG config dir
XDG_CONFIG_HOME ?= $(HOME)/.config

# Colors
GREEN  := \033[0;32m
YELLOW := \033[0;33m
CYAN   := \033[0;36m
DIM    := \033[2m
RESET  := \033[0m

.PHONY: help deps-lowpower deps-full shell-tools shell-rc python-tools git-config fonts ssh-setup docker tmux nvim wezterm vscode onboard-link uninstall clean

help: ## Show this help
	@echo ""
	@echo "  darkcoffys-workbench"
	@echo "  ════════════════════"
	@echo ""
	@echo "  Use ./setup for the full experience:"
	@echo "    $(CYAN)./setup$(RESET)              Full (WezTerm + VS Code + neovim)"
	@echo "    $(CYAN)./setup --low-power$(RESET)  Minimal (tmux + neovim, no GUI)"
	@echo ""
	@echo "  Or run individual targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "    $(CYAN)make %-16s$(RESET) %s\n", $$1, $$2}'
	@echo ""

# ═══════════════════════════════════════════════
# Dependencies
# ═══════════════════════════════════════════════

deps-lowpower: ## Install minimal packages (tmux, neovim, CLI tools)
	@echo -e "$(GREEN)Installing low-power packages...$(RESET)"
ifeq ($(UNAME),Darwin)
	brew install tmux neovim ripgrep fd fzf git curl direnv bat eza yq
else
	sudo apt-get update && sudo apt-get install -y \
		tmux neovim ripgrep fd-find fzf git curl unzip direnv bat
	@# yq
	@if ! command -v yq &>/dev/null; then \
		echo -e "$(YELLOW)  Installing yq...$(RESET)"; \
		sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && sudo chmod +x /usr/local/bin/yq; \
	fi
	@# eza (not in older apt repos — install from cargo if missing)
	@if ! command -v eza &>/dev/null; then \
		echo -e "$(DIM)  eza not in apt, will be available after cargo tools$(RESET)"; \
	fi
endif

deps-full: ## Install full packages (WezTerm, neovim, CLI tools)
	@echo -e "$(GREEN)Installing full packages...$(RESET)"
ifeq ($(UNAME),Darwin)
	brew install --cask wezterm
	brew install neovim ripgrep fd fzf git curl direnv bat eza yq
else
	@if ! command -v wezterm &>/dev/null; then \
		echo -e "$(YELLOW)Installing WezTerm...$(RESET)"; \
		curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg; \
		echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list; \
		sudo apt-get update; \
	fi
	sudo apt-get install -y \
		wezterm neovim ripgrep fd-find fzf git curl unzip direnv bat
endif

# ═══════════════════════════════════════════════
# Shell tools (shared by both modes)
# ═══════════════════════════════════════════════

shell-tools: ## Install starship prompt, zoxide, fzf integration
	@echo -e "$(GREEN)Setting up shell tools...$(RESET)"
	@# Starship
	@if ! command -v starship &>/dev/null; then \
		echo -e "$(YELLOW)  Installing Starship...$(RESET)"; \
		curl -sS https://starship.rs/install.sh | sh -s -- -y; \
	else \
		echo -e "$(DIM)  Starship already installed$(RESET)"; \
	fi
	@# zoxide
ifeq ($(UNAME),Darwin)
	@brew install zoxide 2>/dev/null || true
else
	@if ! command -v zoxide &>/dev/null; then \
		echo -e "$(YELLOW)  Installing zoxide...$(RESET)"; \
		curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh; \
	else \
		echo -e "$(DIM)  zoxide already installed$(RESET)"; \
	fi
endif
	@# Shell integration
	@echo -e "$(YELLOW)  Linking shell config...$(RESET)"
	@mkdir -p $(XDG_CONFIG_HOME)/starship
	@ln -sf $(CURDIR)/starship/starship.toml $(XDG_CONFIG_HOME)/starship.toml
	@echo -e "$(GREEN)  Shell tools ready (wired up by 'make shell-rc').$(RESET)"

shell-rc: ## Wire up shell (starship, zoxide, direnv, fzf, aliases) in your rc file
	@echo -e "$(YELLOW)Setting up shell rc...$(RESET)"
	@# Detect user's shell rc file
	@RCFILE=""; \
	if [ -n "$$ZSH_VERSION" ] || [ "$$(basename $$SHELL)" = "zsh" ]; then \
		RCFILE="$(HOME)/.zshrc"; \
	else \
		RCFILE="$(HOME)/.bashrc"; \
	fi; \
	touch "$$RCFILE"; \
	if grep -q "darkcoffys-workbench" "$$RCFILE" 2>/dev/null; then \
		echo -e "$(DIM)  Already sourced in $$RCFILE$(RESET)"; \
	else \
		echo "" >> "$$RCFILE"; \
		echo "# darkcoffys-workbench (starship, zoxide, direnv, fzf, aliases)" >> "$$RCFILE"; \
		echo "[ -f $(CURDIR)/shell/rc.sh ] && source $(CURDIR)/shell/rc.sh" >> "$$RCFILE"; \
		echo -e "$(GREEN)  Added source line to $$RCFILE$(RESET)"; \
		echo -e "$(CYAN)  Run: source $$RCFILE  (or open a new terminal)$(RESET)"; \
	fi

# ═══════════════════════════════════════════════
# Diagramming
# ═══════════════════════════════════════════════

mermaid: ## Install Mermaid CLI (mmdc) for diagram rendering
	@echo -e "$(GREEN)Setting up Mermaid CLI...$(RESET)"
	@if ! command -v mmdc &>/dev/null; then \
		if command -v npm &>/dev/null; then \
			echo -e "$(YELLOW)  Installing @mermaid-js/mermaid-cli...$(RESET)"; \
			npm install -g @mermaid-js/mermaid-cli; \
		elif command -v npx &>/dev/null; then \
			echo -e "$(DIM)  npm not global — use: npx mmdc -i diagram.mmd -o diagram.png$(RESET)"; \
		else \
			echo -e "$(YELLOW)  Node.js not found. Install Node first, or use GitHub rendering.$(RESET)"; \
			echo -e "$(DIM)  Mermaid renders natively in GitHub markdown — no CLI needed for that.$(RESET)"; \
		fi; \
	else \
		echo -e "$(DIM)  mmdc already installed$(RESET)"; \
	fi

# ═══════════════════════════════════════════════
# Python toolchain
# ═══════════════════════════════════════════════

python-tools: ## Install uv, ruff, pre-commit
	@echo -e "$(GREEN)Setting up Python toolchain...$(RESET)"
	@# uv (fast pip/venv replacement)
	@if ! command -v uv &>/dev/null; then \
		echo -e "$(YELLOW)  Installing uv...$(RESET)"; \
		curl -LsSf https://astral.sh/uv/install.sh | sh; \
	else \
		echo -e "$(DIM)  uv already installed ($$(uv --version))$(RESET)"; \
	fi
	@# ruff (linter + formatter)
	@if ! command -v ruff &>/dev/null; then \
		echo -e "$(YELLOW)  Installing ruff...$(RESET)"; \
		if command -v uv &>/dev/null; then \
			uv tool install ruff; \
		else \
			pip install --user ruff; \
		fi; \
	else \
		echo -e "$(DIM)  ruff already installed ($$(ruff --version))$(RESET)"; \
	fi
	@# pre-commit
	@if ! command -v pre-commit &>/dev/null; then \
		echo -e "$(YELLOW)  Installing pre-commit...$(RESET)"; \
		if command -v uv &>/dev/null; then \
			uv tool install pre-commit; \
		else \
			pip install --user pre-commit; \
		fi; \
	else \
		echo -e "$(DIM)  pre-commit already installed ($$(pre-commit --version))$(RESET)"; \
	fi
	@echo -e "$(GREEN)  Python toolchain ready.$(RESET)"

# ═══════════════════════════════════════════════
# Git config
# ═══════════════════════════════════════════════

git-config: ## Link git aliases and defaults (does NOT touch user.name/email)
	@echo -e "$(YELLOW)Linking git config...$(RESET)"
	@# Add as an include so it doesn't overwrite existing config
	@git config --global include.path $(CURDIR)/git/gitconfig
	@echo -e "$(GREEN)  Git config included from git/gitconfig$(RESET)"
	@echo -e "$(DIM)  Your user.name and user.email are untouched.$(RESET)"
	@echo -e "$(DIM)  Run 'git aliases' to see available shortcuts.$(RESET)"

# ═══════════════════════════════════════════════
# Onboard tool
# ═══════════════════════════════════════════════

onboard-link: ## Add CLI tools to PATH (~/.local/bin)
	@echo -e "$(YELLOW)Linking CLI tools...$(RESET)"
	@mkdir -p $(HOME)/.local/bin
	@for cmd in onboard scaffold sqlprism-init ssh-setup install-fonts team-status; do \
		ln -sf $(CURDIR)/bin/$$cmd $(HOME)/.local/bin/$$cmd; \
		chmod +x $(CURDIR)/bin/$$cmd; \
		echo -e "$(GREEN)  $$cmd → ~/.local/bin/$$cmd$(RESET)"; \
	done

# ═══════════════════════════════════════════════
# Config symlinks
# ═══════════════════════════════════════════════

tmux: ## Symlink tmux config (low-power mode)
	@echo -e "$(YELLOW)Linking tmux config...$(RESET)"
	@ln -sf $(CURDIR)/tmux/tmux.conf $(HOME)/.tmux.conf
	@echo -e "$(GREEN)  ~/.tmux.conf → tmux/tmux.conf$(RESET)"

nvim: ## Symlink neovim config (both modes)
	@echo -e "$(YELLOW)Linking neovim config...$(RESET)"
	@mkdir -p $(XDG_CONFIG_HOME)/nvim
	@ln -sf $(CURDIR)/nvim/init.lua $(XDG_CONFIG_HOME)/nvim/init.lua
	@ln -sf $(CURDIR)/nvim/lua $(XDG_CONFIG_HOME)/nvim/lua
	@echo -e "$(GREEN)  ~/.config/nvim/ → nvim/$(RESET)"

wezterm: ## Symlink WezTerm config (full mode)
	@echo -e "$(YELLOW)Linking WezTerm config...$(RESET)"
	@mkdir -p $(XDG_CONFIG_HOME)/wezterm
	@ln -sf $(CURDIR)/wezterm/wezterm.lua $(HOME)/.wezterm.lua
	@echo -e "$(GREEN)  ~/.wezterm.lua → wezterm/wezterm.lua$(RESET)"

vscode: ## Install VS Code extensions (full mode)
	@echo -e "$(YELLOW)Installing VS Code extensions...$(RESET)"
	@if command -v code &>/dev/null; then \
		while IFS= read -r ext; do \
			code --install-extension "$$ext" --force 2>/dev/null || true; \
		done < $(CURDIR)/vscode/extensions.txt; \
		echo -e "$(GREEN)  Extensions installed$(RESET)"; \
		mkdir -p $(XDG_CONFIG_HOME)/Code/User; \
		ln -sf $(CURDIR)/vscode/settings.json $(XDG_CONFIG_HOME)/Code/User/settings.json; \
		ln -sf $(CURDIR)/vscode/keybindings.json $(XDG_CONFIG_HOME)/Code/User/keybindings.json; \
		echo -e "$(GREEN)  VS Code settings linked$(RESET)"; \
	else \
		echo -e "$(YELLOW)  VS Code not found — skipping extensions$(RESET)"; \
	fi

# ═══════════════════════════════════════════════
# Machine setup
# ═══════════════════════════════════════════════

fonts: ## Install JetBrains Mono Nerd Font
	@$(CURDIR)/bin/install-fonts

ssh-setup: ## Generate SSH key and print public key
	@$(CURDIR)/bin/ssh-setup

docker: ## Install Docker + Docker Compose
	@echo -e "$(GREEN)Setting up Docker...$(RESET)"
ifeq ($(UNAME),Darwin)
	@echo -e "$(YELLOW)  Install Docker Desktop from https://docker.com/products/docker-desktop$(RESET)"
else
	@if ! command -v docker &>/dev/null; then \
		echo -e "$(YELLOW)  Installing Docker...$(RESET)"; \
		curl -fsSL https://get.docker.com | sh; \
		sudo usermod -aG docker $$USER; \
		echo -e "$(GREEN)  Docker installed$(RESET)"; \
		echo -e "$(YELLOW)  Log out and back in for group changes to take effect$(RESET)"; \
	else \
		echo -e "$(DIM)  Docker already installed ($$(docker --version))$(RESET)"; \
	fi
endif

# ═══════════════════════════════════════════════
# Cleanup
# ═══════════════════════════════════════════════

uninstall: ## Remove all symlinks and shell integration
	@echo -e "$(YELLOW)Removing symlinks...$(RESET)"
	@rm -f $(HOME)/.tmux.conf
	@rm -f $(HOME)/.wezterm.lua
	@rm -f $(XDG_CONFIG_HOME)/nvim/init.lua
	@rm -f $(XDG_CONFIG_HOME)/nvim/lua
	@rm -f $(XDG_CONFIG_HOME)/starship.toml
	@rm -f $(XDG_CONFIG_HOME)/Code/User/settings.json
	@rm -f $(XDG_CONFIG_HOME)/Code/User/keybindings.json
	@for cmd in onboard scaffold sqlprism-init ssh-setup install-fonts team-status; do \
		rm -f $(HOME)/.local/bin/$$cmd; \
	done
	@git config --global --unset include.path 2>/dev/null || true
	@echo -e "$(YELLOW)  Note: shell rc.sh source line left in your rc file (remove manually if wanted)$(RESET)"
	@echo -e "$(GREEN)  All symlinks removed.$(RESET)"

clean: uninstall ## Alias for uninstall
