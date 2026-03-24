#
# ~/.bashrc
#

# Stop if not running as Terminal
[[ $- != *i* ]] && return

# PATH additions
if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Add Flutter SDK to PATH only if the folder exists
if [ -d "$HOME/development/flutter/bin" ]; then
    export PATH="$PATH:$HOME/development/flutter/bin"
fi

# Adds CHROME_EXECUTABLE if Chromium is installed
if [ -f /usr/bin/chromium ]; then
    export CHROME_EXECUTABLE=/usr/bin/chromium
fi

if [ -f /usr/bin/ ]; then
    export ANDROID_HOME=$HOME/Android/Sdk
fi


# Initialize Starship prompt if installed
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi

# Run fastfetch if installed
if command -v fastfetch >/dev/null 2>&1; then
    fastfetch --config os
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ff='fastfetch'
alias ffd='fastfetch --config default'
