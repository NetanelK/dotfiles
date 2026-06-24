#!/usr/bin/env bash
set -e

# Bootstrap: curl -fsSL https://raw.githubusercontent.com/NetanelK/dotfiles/main/bootstrap.sh | bash

echo "=== Dotfiles Bootstrap ==="

# 1. Homebrew
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew already installed"
fi

# 2. Clone bare repo
if [ -d "$HOME/.dotfiles" ]; then
    echo "~/.dotfiles already exists — pulling latest"
    git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" pull origin main || true
else
    echo "Cloning dotfiles..."
    git clone --bare https://github.com/NetanelK/dotfiles.git "$HOME/.dotfiles"
fi

# 3. Configure
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" config --local status.showUntrackedFiles no
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" config --local core.excludesFile "$HOME/.dotfiles-gitignore"

# 4. Checkout (backup conflicts)
echo "Checking out dotfiles..."
if ! git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout 2>/dev/null; then
    BACKUP="$HOME/.dotfiles-backup-$(date +%Y%m%d%H%M%S)"
    mkdir -p "$BACKUP"
    git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout 2>&1 | \
        grep -E "^\s+" | awk '{print $1}' | while read -r f; do
        mkdir -p "$BACKUP/$(dirname "$f")"
        mv "$HOME/$f" "$BACKUP/$f"
    done
    git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout
    echo "Backed up conflicting files to $BACKUP"
fi

# 5. Homebrew packages
echo "Installing Homebrew packages..."
brew bundle --global || true

# 6. Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# 7. Plugins & theme
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

[ -d "$ZSH_CUSTOM/themes/spaceship-prompt" ] || \
    git clone --depth=1 https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
ln -sf "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

[ -d "$ZSH_CUSTOM/plugins/fzf-tab" ] || \
    git clone https://github.com/Aloxaf/fzf-tab "$ZSH_CUSTOM/plugins/fzf-tab"
[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] || \
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] || \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# 8. VS Code extensions
if command -v code &>/dev/null && [ -f "$HOME/.vscode-extensions.txt" ]; then
    echo "Installing VS Code extensions..."
    while IFS= read -r ext; do
        code --install-extension "$ext" --force 2>/dev/null || true
    done < "$HOME/.vscode-extensions.txt"
fi

# 9. macOS defaults
if [ -f "$HOME/.config/dotfiles/macos-defaults.sh" ]; then
    echo "Applying macOS defaults..."
    bash "$HOME/.config/dotfiles/macos-defaults.sh"
fi

# 10. Claude settings from template
if [ ! -f "$HOME/.claude/settings.json" ] && [ -f "$HOME/.claude/settings.json.template" ]; then
    cp "$HOME/.claude/settings.json.template" "$HOME/.claude/settings.json"
    echo "Created ~/.claude/settings.json — fill in YOUR_AUTH_TOKEN_HERE"
fi

echo ""
echo "=== Bootstrap complete ==="
echo ""
echo "Create org-specific .local files from examples:"
echo "  cp ~/.config/dotfiles/examples/zshrc.local ~/.zshrc.local"
echo "  cp ~/.config/dotfiles/examples/env.local ~/.env.local"
echo "  cp ~/.config/dotfiles/examples/gitconfig.local ~/.gitconfig.local"
echo "  cp ~/.config/dotfiles/examples/ssh-config.local ~/.ssh/config.local"
echo "  cp ~/.config/dotfiles/examples/aws-config ~/.aws/config"
echo "  cp ~/.config/dotfiles/examples/saml2aws ~/.saml2aws"
echo ""
echo "Then edit each file and fill in real values."
echo "Finally: source ~/.zshrc"
