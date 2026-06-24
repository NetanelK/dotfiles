# Raycast Settings

Raycast settings can't be tracked as raw files (encrypted SQLite + plist).

## Export (current machine)

1. Open Raycast → Settings (⌘,) → Advanced → Export
2. Save the `.rayconfig` file to `~/.config/dotfiles/raycast.rayconfig`
3. Commit: `dotfiles add ~/.config/dotfiles/raycast.rayconfig && dotfiles commit -m "update raycast config" && dotfiles push`

## Import (new machine)

1. Install Raycast: `brew install --cask raycast`
2. Open Raycast → Settings → Advanced → Import
3. Select `~/.config/dotfiles/raycast.rayconfig`

## What's exported

- Hotkey settings
- Extensions & their configs
- Snippets
- Quicklinks
- Script commands
- Window management settings
- Theme

## What's NOT exported (need manual setup)

- Logins to extensions (GitHub, Linear, etc.)
- Raycast Pro/AI settings (tied to account)
