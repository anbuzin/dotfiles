# Dotfiles location
DOTFILES="$(dirname "$(readlink ~/.zshrc 2>/dev/null || echo ~/.zshrc)")"
[[ "$DOTFILES" == "." ]] && DOTFILES="$HOME/local/resources/dotfiles"

# --- Keychain API key management ---
# Keys stored as "$MACHINE_PREFIX/KEY_NAME" in macOS Keychain
MACHINE_PREFIX=$(cat ~/.dotfiles-machine 2>/dev/null || echo "default")

key-add() { security add-generic-password -a "$USER" -s "$MACHINE_PREFIX/$1" -w -U; }
key-get() { security find-generic-password -a "$USER" -s "$MACHINE_PREFIX/$1" -w 2>/dev/null; }
key-del() { security delete-generic-password -a "$USER" -s "$MACHINE_PREFIX/$1"; }
key-list() { security dump-keychain 2>/dev/null | grep "svce.*\"$MACHINE_PREFIX/" | sed "s/.*\"$MACHINE_PREFIX\///;s/\"$//" | sort -u; }

keys() {
    export OPENAI_API_KEY=$(key-get OPENAI_API_KEY)
    export ANTHROPIC_API_KEY=$(key-get ANTHROPIC_API_KEY)
    # Add more as needed
    echo "Loaded keys ($MACHINE_PREFIX)"
}

# --- Aliases ---
alias gelv="source ~/local/resources/gel_dev/gelv/bin/activate"
alias pyv="source .venv/bin/activate"
alias proj="cd ~/local/projects"
alias res="cd ~/local/resources"
alias cdf='cd "$(fd --type d --hidden --exclude Library --exclude Applications . | fzf)"'
alias ef='fd --type f --hidden --exclude Library --exclude Applications . | fzf | xargs nvim'

# --- Prompt ---
setopt PROMPT_SUBST
PS1='%F{#89b4fa}%n@%m%f:%F{#cdd6f4}%~%f %F{#f5e0dc}$ %f'

# --- Plugins ---
source "$DOTFILES/zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh"
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# --- Homebrew ---
export HOMEBREW_BUNDLE_FILE="$HOME/.config/Brewfile"
