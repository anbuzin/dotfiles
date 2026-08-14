#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$DOTFILES/backups/$(date +%Y%m%d_%H%M%S)"

link() {
    local src="$1" dst="$2" name="$3"
    mkdir -p "$(dirname "$dst")"
    [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]] && return
    if [[ -e "$dst" || -L "$dst" ]]; then
        mkdir -p "$BACKUP_DIR"
        mv "$dst" "$BACKUP_DIR/$name"
        echo "Backed up: $name"
    fi
    ln -s "$src" "$dst"
    echo "Linked: $dst"
}

# Machine prefix for keychain namespacing
if [[ ! -f ~/.dotfiles-machine ]]; then
    read -p "Machine name for keychain prefix (e.g. mac, triangle): " prefix
    [[ -z "$prefix" ]] && echo "Cannot be empty" && exit 1
    echo "$prefix" > ~/.dotfiles-machine
fi

link "$DOTFILES/zshrc"           "$HOME/.zshrc"           "zshrc"
link "$DOTFILES/tmux.conf"       "$HOME/.tmux.conf"       "tmux.conf"
link "$DOTFILES/config/ghostty"  "$HOME/.config/ghostty"  "ghostty"
link "$DOTFILES/config/nvim"     "$HOME/.config/nvim"     "nvim"
link "$DOTFILES/config/Brewfile" "$HOME/.config/Brewfile" "Brewfile"
link "$DOTFILES/zsh"             "$HOME/.zsh"             "zsh"

# rose-pine-geist neovim plugin (ghostty/zsh pick it up via the links above)
link "$DOTFILES/rose-pine-geist/nvim" \
     "$HOME/.local/share/nvim/site/pack/themes/start/rose-pine-geist" \
     "rose-pine-geist-nvim"

# Obsidian snippet is separate: rose-pine-geist/install-obsidian.sh

echo "Done. Restart shell or: source ~/.zshrc"
