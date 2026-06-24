#!/usr/bin/env bash
set -e

# Bootstrap script for new machines
# Run: curl -fsSL https://raw.githubusercontent.com/NetanelK/dotfiles/main/.dotfiles-bootstrap.sh | bash

echo "=== Dotfiles Bootstrap ==="

# 1. Install Homebrew
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew already installed"
fi

# 2. Install git (needed for clone)
brew install git

# 3. Clone bare repo
if [ -d "$HOME/.dotfiles" ]; then
    echo "~/.dotfiles already exists — skipping clone"
else
    echo "Cloning dotfiles..."
    git clone --bare https://github.com/NetanelK/dotfiles.git "$HOME/.dotfiles"
fi

# 4. Configure bare repo
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" config --local status.showUntrackedFiles no
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" config --local core.excludesFile "$HOME/.dotfiles-gitignore"

# 5. Checkout (backup conflicts)
echo "Checking out dotfiles..."
CONFLICTS=$(git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout 2>&1 | grep -E "^\s+" | awk '{print $1}') || true
if [ -n "$CONFLICTS" ]; then
    BACKUP="$HOME/.dotfiles-backup-$(date +%Y%m%d%H%M%S)"
    mkdir -p "$BACKUP"
    echo "$CONFLICTS" | while read -r f; do
        mkdir -p "$BACKUP/$(dirname "$f")"
        mv "$HOME/$f" "$BACKUP/$f"
    done
    echo "Backed up conflicting files to $BACKUP"
    git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout
fi

# 6. Install Homebrew packages
echo "Installing Homebrew packages (this takes a while)..."
brew bundle --global || true

# 7. Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# 8. Custom plugins & theme
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
echo "Installing zsh plugins and theme..."

[ -d "$ZSH_CUSTOM/themes/spaceship-prompt" ] || \
    git clone --depth=1 https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
ln -sf "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

[ -d "$ZSH_CUSTOM/plugins/fzf-tab" ] || \
    git clone https://github.com/Aloxaf/fzf-tab "$ZSH_CUSTOM/plugins/fzf-tab"

[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] || \
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] || \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# 9. VS Code extensions
if command -v code &>/dev/null; then
    echo "Installing VS Code extensions..."
    git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" show main:.vscode-extensions.txt 2>/dev/null | \
        while IFS= read -r ext; do code --install-extension "$ext" --force 2>/dev/null || true; done
fi

# 10. Claude Code settings from template
if [ ! -f "$HOME/.claude/settings.json" ] && [ -f "$HOME/.claude/settings.json.template" ]; then
    cp "$HOME/.claude/settings.json.template" "$HOME/.claude/settings.json"
    echo "Created ~/.claude/settings.json from template — fill in YOUR_AUTH_TOKEN_HERE"
fi

echo ""
echo "=== Bootstrap complete ==="
echo ""
echo "Manual steps remaining:"
echo "  1. Copy SSH keys (~/.ssh/id_ed25519, ~/.ssh/checkpoint.pem, etc.)"
echo "  2. Edit ~/.claude/settings.json — replace YOUR_AUTH_TOKEN_HERE"
echo "  3. Copy ~/.claude/zscaler-root-ca.pem from secure backup"
echo "  4. gh auth login"
echo "  5. saml2aws login -a ovp-devops"
echo "  6. source ~/.zshrc"
