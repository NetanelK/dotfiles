#!/usr/bin/env bash
# Create Developer folder structure and symlink

set -e

echo "Setting up Developer folder structure..."

mkdir -p ~/Developer/Projects/Current
mkdir -p ~/Developer/Projects/Archive
mkdir -p ~/Developer/Projects/Incubator
mkdir -p ~/Developer/Projects/Personal

# Symlink ~/Projects -> ~/Developer/Projects/Current
if [ ! -L "$HOME/Projects" ]; then
    # Back up existing Projects dir if it's a real directory
    if [ -d "$HOME/Projects" ]; then
        echo "  Moving existing ~/Projects contents to ~/Developer/Projects/Current/"
        mv "$HOME/Projects"/* "$HOME/Developer/Projects/Current/" 2>/dev/null || true
        rmdir "$HOME/Projects" 2>/dev/null || rm -rf "$HOME/Projects"
    fi
    ln -sf "$HOME/Developer/Projects/Current" "$HOME/Projects"
    echo "  Linked ~/Projects -> ~/Developer/Projects/Current"
else
    echo "  ~/Projects symlink already exists"
fi

echo "Done."
echo ""
echo "Structure:"
echo "  ~/Developer/"
echo "  └── Projects/"
echo "      ├── Current/    ← active work (~/Projects points here)"
echo "      ├── Archive/    ← completed/inactive"
echo "      ├── Incubator/  ← experimental"
echo "      └── Personal/   ← side projects"
