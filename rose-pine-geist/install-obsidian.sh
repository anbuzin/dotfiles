#!/bin/bash
# Copy the rose-pine-geist code-block snippet into an Obsidian vault.
# Copied, not linked — synced vaults should stay self-contained.
# Re-run after regenerating (uv run build.py).
#
# Usage: ./install-obsidian.sh [vault-path]   (default: ~/vaults/main)
set -e

SRC="$(cd "$(dirname "$0")" && pwd)/obsidian/rose-pine-geist-code.css"
VAULT="${1:-$HOME/vaults/main}"
SNIPPETS="$VAULT/.obsidian/snippets"

if [[ ! -d "$VAULT/.obsidian" ]]; then
    echo "No Obsidian vault at $VAULT (pass the vault path as an argument)"
    exit 1
fi

mkdir -p "$SNIPPETS"
cp "$SRC" "$SNIPPETS/"
echo "Copied: rose-pine-geist-code.css → $SNIPPETS"
echo "First install? Enable it once: Settings → Appearance → CSS snippets"
