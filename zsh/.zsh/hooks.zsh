autoload -Uz add-zsh-hook

.hooks_set_title() {
    emulate -L zsh

    local cmd=$1
    print -n "\e]0;${(q)cmd}\a"
}

.hooks_pwd() {
    emulate -L zsh

    print -Drn -- "$PWD"
}

.hooks_host() {
    emulate -L zsh

    print -Prn -- '@%m'
}

→hooks_update_window_title_precmd() {
    emulate -L zsh

    local title
    if [[ -n "$TMUX" ]]; then
        # Show hostname, tmux will prefix title with session.
        title=$(.hooks_host)
    else
        # Show PWD.
        title=$(.hooks_pwd)
    fi

    .hooks_set_title "$title"
}

→hooks_update_window_title_preexec() {
    emulate -L zsh
    setopt extendedglob

    local title
    if [[ -n "$TMUX" ]]; then
        # Show hostname, tmux will prefix title with session.
        title=$(.hooks_host)
    else
        # Command that is running, trimmed of arguments etc.
        local cmd="${2[(wr)^(*=*|ssh|sudo|-*)]}"

        # Show PWD followed by running command.
        title="$(.hooks_pwd) - $cmd"
    fi

    .hooks_set_title "$title"
}

add-zsh-hook precmd →hooks_update_window_title_precmd
add-zsh-hook preexec →hooks_update_window_title_preexec
