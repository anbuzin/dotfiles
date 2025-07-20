# python venv
alias gelv="source ~/local/resources/gel_dev/gelv/bin/activate"
alias pyv="source .venv/bin/activate"

# directories
alias proj="cd ~/local/projects"
alias res="cd ~/local/resources"

# commands
alias cdf='cd "$(fd --type d --hidden --exclude Library --exclude Applications . | fzf)"'
alias ef='fd --type f --hidden --exclude Library --exclude Applications . | fzf | xargs nvim'

# colors
PS1="%F{#89b4fa}%n@%m%f:%F{#cdd6f4}%~%f %F{#f5e0dc}$ %f"
source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# nirepl
export NIREPL_PATH="/Users/andrey/local/resources/gel_dev/nirepl"
alias ni="uvx -q --from '$NIREPL_PATH' nirun"

# brew bundle
export HOMEBREW_BUNDLE_FILE="$HOME/.config/Brewfile"

