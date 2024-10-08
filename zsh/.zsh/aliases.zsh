# Enable colour for commands. {{{
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias pacman='pacman --color=auto'
alias yay='yay --color=auto'
# }}}

# QoL aliases. {{{
alias la='ls -A'
# }}}

# Unified diff.
alias diff='diff -u --color=auto'

# Use neovim over vim.
alias vim='nvim'

# Exa aliases. {{{
alias exa='eza --colour=auto --extended --git'
alias e='eza'
alias ea='eza --all'
alias el='eza --long'
alias eal='eza --all --long'
# }}}

# Git aliases (sorted alphabetically). {{{
alias g='git'

alias ga='git add'

alias gb='git branch'

alias gc='git commit -v'
alias gc!='git commit -v --amend'
alias gco='git checkout'
alias gcp='git cherry-pick'

alias gd='git diff'

alias gf='git fetch'

alias gl='git pull'
alias glg='git log --stat'
alias glo='git log --oneline'

alias gp='git push'
alias gpd='git push --dry-run'

alias gr='git remote'

alias gsb='git status -sb'
alias gst='git status'
# }}}

# Alias functions when using kitty. {{{
if [[ "$TERM" == "xterm-kitty" ]]; then
    # Send kitty terminfo over ssh.
    # Use a function over an alias to keep completion function.
    ssh() {
        kitty +kitten ssh "$@"
    }

    # Inline image viewer.
    icat() {
        kitty +icat "$@"
    }
fi
# }}}

# Alias for zathura. {{{
if (( ${+commands[zathura]} && !${+commands[pdf]} )); then
    alias pdf='zathura --fork'
fi
# }}}

# Mimic docker with podman. {{{
if (( ${+commands[podman]} )); then
    alias docker='podman'
    (( ${+commands[podman-compose]} )) && alias 'docker-compose'='podman-compose'
fi
# }}}

# }}}
