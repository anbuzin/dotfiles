# Dotfiles location
DOTFILES="$HOME/local/resources/dotfiles"

# --- Keychain API key management ---
# Keys stored as "$MACHINE_PREFIX/KEY_NAME" in macOS Keychain
MACHINE_PREFIX=$(cat ~/.dotfiles-machine 2>/dev/null || echo "default")

key-add() {
    [[ -z "$1" ]] && echo "Usage: key-add KEY_NAME" && return 1
    local val
    printf "Value for %s/%s: " "$MACHINE_PREFIX" "$1"
    IFS= read -rs val
    echo
    [[ -z "$val" ]] && echo "Empty value, aborting" && return 1
    security add-generic-password -a "$USER" -s "$MACHINE_PREFIX/$1" -U -w "$val"
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

# --- Editor ---
export EDITOR="nvim"
export VISUAL="nvim"

# --- Aliases ---
alias vim="nvim"
alias pyv="source .venv/bin/activate"
alias cdf='cd "$(fd --type d --hidden --exclude Library --exclude Applications . | fzf)"'
alias ef='fd --type f --hidden --exclude Library --exclude Applications . | fzf | xargs nvim'

# --- Prompt ---
source "$DOTFILES/rose-pine-geist/zsh/rose-pine-geist-prompt.zsh"
PS1="%F{$RPG_PINE}%n@%m%f:%F{$RPG_TEXT}%~%f %F{$RPG_ROSE}$ %f"

# --- Plugins ---
source "$DOTFILES/rose-pine-geist/zsh/rose-pine-geist-highlighting.zsh"
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# --- Homebrew ---
export HOMEBREW_BUNDLE_FILE="$HOME/.config/Brewfile"

eval "$(fnm env --use-on-cd --shell zsh)"

export SSH_AUTH_SOCK="$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh"

