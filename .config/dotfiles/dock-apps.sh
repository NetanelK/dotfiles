#!/usr/bin/env bash
# Restore Dock layout
# Run after apps are installed: bash ~/.config/dotfiles/dock-apps.sh

set -e

# Clear current Dock
defaults write com.apple.dock persistent-apps -array

# Add apps in order
dock_app() {
    defaults write com.apple.dock persistent-apps -array-add \
        "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$1</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
}

dock_app "/System/Applications/Safari.app"
dock_app "/Applications/Google Chrome.app"
dock_app "/Applications/Microsoft Outlook.app"
dock_app "/Applications/Microsoft Teams.app"
dock_app "/System/Applications/Calendar.app"
dock_app "/System/Applications/Notes.app"
dock_app "/System/Applications/System Settings.app"
dock_app "/System/Applications/iPhone Mirroring.app"
dock_app "/Applications/Visual Studio Code.app"
dock_app "/Applications/iTerm.app"
dock_app "/Applications/Lens.app"
dock_app "/Applications/SDM.app"
dock_app "/Applications/Gemini.app"
dock_app "/System/Applications/TextEdit.app"
dock_app "/System/Applications/Preview.app"
dock_app "/Applications/Xcode.app"

# Restart Dock
killall Dock

echo "Dock restored."
