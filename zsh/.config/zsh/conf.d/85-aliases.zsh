# -*- mode: zsh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# vim: ft=zsh tw=120 sw=4 sts=4 et foldmarker=[[[,]]]

# Enable colour. [[[

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# ]]]

# QoL. [[[

alias la='ls -A'
alias ll='ls -l'
alias lla='ls -lA'

# Unified diff.
alias diff='diff -u --color=auto'

# Use neovim over vim.
(( $+commands[nvim] )) && alias vim='nvim'

# Eza aliases.
if (( $+commands[eza] )); then
    alias eza='eza --colour=auto --extended --git'
    alias e='eza'
    alias ea='eza --all'
    alias el='eza --long'
    alias eal='eza --all --long'
fi

# Git aliases (sorted alphabetically).
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

# ]]]