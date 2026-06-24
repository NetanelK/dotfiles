#!/usr/bin/env bash
# macOS preferences (run once on new machine, then reboot)

set -e

echo "Applying macOS defaults..."

# Appearance
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'

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

# Disable Spotlight hotkey (⌘Space) so Raycast can use it
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:64:enabled false" \
    ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:164:enabled false" \
    ~/Library/Preferences/com.apple.symbolichotkeys.plist

# Misc
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

echo "Done. Log out and back in for all changes to take effect."
echo "Then open Raycast and set ⌘Space as its hotkey."
