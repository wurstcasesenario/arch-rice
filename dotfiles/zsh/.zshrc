# =========================
# Zsh History Settings
# =========================
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e

# =========================
# Enable Zsh Completion
# =========================
autoload -Uz compinit
compinit

# ========================
# Oh My Zsh-like Enhancements
# ========================

# --- Command Suggestions ---
if [ -f ~/.zsh_custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source ~/.zsh_custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# --- Syntax Highlighting ---
if [ -f ~/.zsh_custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source ~/.zsh_custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# =========================
# Prompt
# =========================
# Initialize Starship prompt if installed
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

# =========================
# System Info
# =========================

# Run fastfetch if installed
if command -v fastfetch >/dev/null 2>&1; then
    fastfetch --config os
fi

# =========================
# Aliases
# =========================
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ff='fastfetch'
alias ffd='fastfetch --config default'

# =========================
# Settings
# =========================
zstyle ':completion:*' menu select
zstyle ':completion:*' select-prompt '%SScrolling active: %p%s'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Autocorrect typos in commands
setopt CORRECT

# Highlight completion candidates
setopt AUTO_MENU
