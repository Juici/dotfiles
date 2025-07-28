# -*- mode: zsh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# vim: ft=zsh tw=120 sw=4 sts=4 et foldmarker=[[[,]]]

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

# Fix electron wastebin problem.
export ELECTRON_TRASH='kioclient5'

# Enable command history in IEx.
export ERL_AFLAGS='-kernel shell_history enabled -kernel shell_history_file_bytes 1024000'

# Set PNPM home directory.
export PNPM_HOME="${XDG_DATA_HOME}/pnpm"

# Allow jupyter-lab to install extensions for the user.
export JUPYTERLAB_DIR="${XDG_DATA_HOME}/jupyter/lab"

# Show italics in man pages.
export GROFF_BIN_PATH="${Juici[functions_dir]}"
