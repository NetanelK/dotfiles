#!/usr/bin/env bash
# macOS preferences (run once on new machine, then reboot)

set -e

echo "Applying macOS defaults..."

# Finder
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"  # List view
defaults write com.apple.finder NewWindowTarget -string "PfHm"       # Home dir

# Keyboard
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false    # Key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Trackpad
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true  # Tap to click

# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock show-recents -bool false

# Screenshots
defaults write com.apple.screencapture location -string "$HOME/Desktop"
defaults write com.apple.screencapture type -string "png"

# Misc
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

echo "Done. Restart (or log out) for all changes to take effect."
