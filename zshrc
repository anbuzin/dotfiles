# Dotfiles location
DOTFILES="$(dirname "$(readlink ~/.zshrc 2>/dev/null || echo ~/.zshrc)")"
[[ "$DOTFILES" == "." ]] && DOTFILES="$HOME/local/resources/dotfiles"

# --- Keychain API key management ---
# Keys stored as "$MACHINE_PREFIX/KEY_NAME" in macOS Keychain
MACHINE_PREFIX=$(cat ~/.dotfiles-machine 2>/dev/null || echo "default")

key-add() {
    [[ -z "$1" ]] && echo "Usage: key-add KEY_NAME" && return 1
    security add-generic-password -a "$USER" -s "$MACHINE_PREFIX/$1" -U -w
}
key-get() {
    [[ -z "$1" ]] && echo "Usage: key-get KEY_NAME" && return 1
    security find-generic-password -a "$USER" -s "$MACHINE_PREFIX/$1" -w 2>/dev/null
}
key-del() {
    [[ -z "$1" ]] && echo "Usage: key-del KEY_NAME" && return 1
    security delete-generic-password -a "$USER" -s "$MACHINE_PREFIX/$1"
}
key-list() { security dump-keychain 2>/dev/null | grep "svce.*\"$MACHINE_PREFIX/" | sed "s/.*\"$MACHINE_PREFIX\///;s/\"$//" | sort -u; }

keys() {
    local key_name
    for key_name in $(key-list); do
        export "$key_name"="$(key-get "$key_name")"
    done
    echo "Loaded $(key-list | wc -l | tr -d ' ') keys ($MACHINE_PREFIX)"
}

# --- Aliases ---
alias pyv="source .venv/bin/activate"
alias cdf='cd "$(fd --type d --hidden --exclude Library --exclude Applications . | fzf)"'
alias ef='fd --type f --hidden --exclude Library --exclude Applications . | fzf | xargs nvim'

# --- Prompt ---
PS1="%F{#89b4fa}%n@%m%f:%F{#cdd6f4}%~%f %F{#f5e0dc}$ %f"

# --- Plugins ---
source "$DOTFILES/zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh"
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# --- Homebrew ---
export HOMEBREW_BUNDLE_FILE="$HOME/.config/Brewfile"

eval "$(fnm env --use-on-cd --shell zsh)"

