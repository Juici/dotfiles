# Enable colour for commands.
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias pacman='pacman --color=auto'

# QoL aliases
alias la='ls -A'

if (( ${+commands[exa]} )); then
    alias exa='exa --colour=auto --extended --git'

    alias e='exa'

    alias ea='exa --all'
    alias el='exa --long'
    alias eal='exa --all --long'

    alias exaa='exa --all'
    alias exal='exa --long'
fi

# Git aliases (sorted alphabetically).
if (( ${+commands[git]} )); then
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
fi

# Use neovim over vim, if available.
if (( ${+commands[nvim]} )); then
    alias vim='nvim'
fi

# Alias for zathura.
if (( ${+commands[zathura]} && !${+commands[pdf]} )); then
    alias pdf='zathura --fork'
fi
