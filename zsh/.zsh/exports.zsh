# Set pager.
export PAGER='less -F'

# Set editor.
(( ${+commands[nvim]} )) && export VISUAL=nvim || export VISUAL=vim
export EDITOR=$VISUAL
export FCEDIT=$VISUAL

# Enable ANSI colour support for less.
export LESS=R

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
