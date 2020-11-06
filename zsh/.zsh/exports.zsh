# Set pager.
export PAGER='less -F'

# Set editor.
if (( ${+commands[nvim]} )); then
    export VISUAL='nvim'
else
    export VISUAL='vim'
fi
export EDITOR="$VISUAL"
export FCEDIT="$VISUAL"
export GIT_EDITOR="$VISUAL"

# Enable ANSI colour and mouse support for less.
export LESS='-R --mouse --wheel-lines=3'

# Coloured man pages.
export LESS_TERMCAP_mb=$'\e[01;31m'     # Begins blinking.
export LESS_TERMCAP_md=$'\e[01;31m'     # Begins bold.
export LESS_TERMCAP_me=$'\e[0m'         # Ends mode.
export LESS_TERMCAP_se=$'\e[0m'         # Ends standout-mode.
export LESS_TERMCAP_so=$'\e[00;47;30m'  # Begins standout-mode.
export LESS_TERMCAP_ue=$'\e[0m'         # Ends underline.
export LESS_TERMCAP_us=$'\e[04;34m'     # Begins underline.

# Fix electron wastebin problem.
export ELECTRON_TRASH=kioclient5

# Use sccache wrapper for cargo.
if (( ${+commands[sccache]} )); then
    export RUSTC_WRAPPER="${commands[sccache]}"
fi

# Enable command history in IEx.
export ERL_AFLAGS="-kernel shell_history enabled -kernel shell_history_file_bytes 1024000"
