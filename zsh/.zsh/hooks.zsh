autoload -U add-zsh-hook


-hooks-title() {
    emulate -L zsh

    local cmd="${1:gs/$/\\$}"
    print -Pn "\e]0;$cmd:q\a"
}

-hooks-pwd() {
    print -Pn '%~'
}


# Keep track of local command history.
HISTCMD_LOCAL=0

-hooks-update-window-title-precmd() {
    emulate -L zsh

    if (( HISTCMD_LOCAL == 0 )); then
        # HISTCMD_LOCAL not set yet, just show PWD.
        -hooks-title "$(-hooks-pwd)"
    else
        local last
        print -v last -- ${$(history -1)[2]}

        if [[ -n "$TMUX" ]]; then
            # Inside tmux, just show last cmd since tmux will prefix title with
            # session name.
            -hooks-title "$last"
        else
            # Outside tmux, from PWD followed by last cmd.
            -hooks-title "$(-hooks-pwd) > $last"
        fi
    fi
}
add-zsh-hook precmd -hooks-update-window-title-precmd

-hooks-update-window-title-preexec() {
    emulate -L zsh
    setopt extendedglob

    HISTCMD_LOCAL=$(( ++HISTCMD_LOCAL ))

    local trimmed="${2[(wr)^(*=*|ssh|sudo|-*)]}"
    if [[ -n "$TMUX" ]]; then
        # Inside tmux, just show last cmd since tmux will prefix title with
        # session name.
        -hooks-title "$trimmed"
    else
        # Outside tmux, from PWD followed by last cmd.
        -hooks-title "$(-hooks-pwd) > $trimmed"
    fi
}
add-zsh-hook preexec -hooks-update-window-title-preexec
