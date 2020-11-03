autoload -Uz add-zsh-hook


.hooks_title() {
    emulate -L zsh

    local cmd="${1:gs/$/\\$}"
    print -Pn "\e]0;$cmd:q\a"
}

.hooks_pwd() {
    emulate -L zsh

    print -Pn '%~'
}


# Keep track of local command history.
HISTCMD_LOCAL=0

→hooks_update_window_title_precmd() {
    emulate -L zsh

    if (( HISTCMD_LOCAL == 0 )); then
        # HISTCMD_LOCAL not set yet, just show PWD.
        .hooks_title "$(.hooks_pwd)"
    else
        local last
        print -v last -- "${$(history -1)[2]}"

        if [[ -n "$TMUX" ]]; then
            # Inside tmux, just show last cmd since tmux will prefix title with
            # session name.
            .hooks_title "$last"
        else
            # Outside tmux, from PWD followed by last cmd.
            .hooks_title "$(.hooks_pwd) > $last"
        fi
    fi
}
add-zsh-hook precmd →hooks_update_window_title_precmd

→hooks_update_window_title_preexec() {
    emulate -L zsh
    setopt extendedglob

    HISTCMD_LOCAL=$(( ++HISTCMD_LOCAL ))

    local trimmed="${2[(wr)^(*=*|ssh|sudo|-*)]}"
    if [[ -n "$TMUX" ]]; then
        # Inside tmux, just show last cmd since tmux will prefix title with
        # session name.
        .hooks_title "$trimmed"
    else
        # Outside tmux, from PWD followed by last cmd.
        .hooks_title "$(.hooks_pwd) > $trimmed"
    fi
}
add-zsh-hook preexec →hooks_update_window_title_preexec
