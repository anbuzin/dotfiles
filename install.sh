#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

link() {
    local src="$1" dst="$2"
    mkdir -p "$(dirname "$dst")"
    [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]] && return
    [[ -e "$dst" || -L "$dst" ]] && mv "$dst" "${dst}.backup.$(date +%Y%m%d%H%M%S)"
    ln -s "$src" "$dst"
    echo "Linked: $dst"
}

# Machine prefix for keychain namespacing
if [[ ! -f ~/.dotfiles-machine ]]; then
    read -p "Machine name for keychain prefix (e.g. mac, triangle): " prefix
    [[ -z "$prefix" ]] && echo "Cannot be empty" && exit 1
    echo "$prefix" > ~/.dotfiles-machine
fi

link "$DOTFILES/zshrc"          "$HOME/.zshrc"
link "$DOTFILES/tmux.conf"      "$HOME/.tmux.conf"
link "$DOTFILES/config/ghostty" "$HOME/.config/ghostty"
link "$DOTFILES/config/Brewfile" "$HOME/.config/Brewfile"
link "$DOTFILES/zsh"            "$HOME/.zsh"

echo "Done. Restart shell or: source ~/.zshrc"
