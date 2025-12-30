#
# ~/.bashrc
#

# Stop if not running as Terminal
[[ $- != *i* ]] && return

# PATH additions
if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.cargo/bin" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# Add ESPUP Rustc
if [ -d "$HOME/.rustup/toolchains/esp/bin" ]; then
    export PATH="$HOME/.rustup/toolchains/esp/bin:$PATH"
fi

# Rust / Cargo
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

# ESP Rust toolchain (only if installed)
if [ -f "$HOME/export-esp.sh" ]; then
    source "$HOME/export-esp.sh"
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
