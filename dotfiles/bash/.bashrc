#
# ~/.bashrc
#

if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
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
alias off='systemctl poweroff'
alias reboot='systemctl reboot'

PS1='[\u@\h \W]\$ '
