# Set pager.
export PAGER='less -F'

# Set editor.
if (( ${+commands[nvim]} )); then
    export VISUAL='nvim'
    export DIFFPROG='nvim -d'
else
    export VISUAL='vim'
fi
export EDITOR="$VISUAL"
export FCEDIT="$VISUAL"
export GIT_EDITOR="$VISUAL"

# Enable ANSI colour and mouse support for less.
export LESS='-RMSK --mouse --wheel-lines=3'
export SYSTEMD_LESS='-FRSMK --mouse --wheel-lines=3'

() {
    # Ensure terminfo module is loaded.
    zmodload zsh/terminfo &>/dev/null || return 1

    # Coloured man pages.
    export LESS_TERMCAP_mb=${(%):-'%F{yellow}%B'}   # Begins blinking.
    export LESS_TERMCAP_md=${(%):-'%F{red}%B'}      # Begins bold.
    export LESS_TERMCAP_me=${terminfo[sgr0]}        # Ends mode.
    export LESS_TERMCAP_so=${terminfo[smso]}        # Begins standout-mode.
    export LESS_TERMCAP_se=${terminfo[rmso]}        # Ends standout-mode.
    export LESS_TERMCAP_us=${(%):-'%F{blue}%U'}     # Begins underline.
    export LESS_TERMCAP_ue=${terminfo[sgr0]}        # Ends underline.
}

# Fix electron wastebin problem.
export ELECTRON_TRASH=kioclient5

# Enable command history in IEx.
export ERL_AFLAGS="-kernel shell_history enabled -kernel shell_history_file_bytes 1024000"

# Allow jupyter-lab to install extensions for the user.
export JUPYTERLAB_DIR="$HOME/.local/share/jupyter/lab"
