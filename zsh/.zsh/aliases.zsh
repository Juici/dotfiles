# Enable colour for commands.
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias pacman='pacman --color=auto'

# Autocorrection exceptions.
alias sudo='nocorrect sudo'
alias man='nocorrect man'
alias mv='nocorrect mv'
alias mkdir='nocorrect mkdir'

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
