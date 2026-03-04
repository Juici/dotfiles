# -*- mode: zsh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# vim: ft=zsh tw=120 sw=4 sts=4 et foldmarker=[[[,]]]

autoload -Uz @term-set-title

.hooks-report-cwd() {
    # TODO: Handle Tmux passthrough.
    builtin print -rn $'\e]7;'"file://${HOST:-localhost}${PWD}"$'\a'
}

.hooks-set-title() {
    local match mbegin mend title cwd="${(D)PWD}" cmd="$1"

    # Prettify current working directory path.
    (( ${#cwd} > 20 )) && cwd=${cwd//(#b)('~'[^\/]#|(.|)[^\/])[^\/]#\//"${match[1]}/"}

    title="${cwd}"
    [[ -n "${cmd}" ]] && title="${cwd} - ${cmd}"

    @term-set-title "${title}"
}

.hooks-set-user-var() {
    local key="$1" value="$(builtin print -rn "$2" | base64)"

    # TODO: Handle Tmux passthrough.
    builtin print -rn $'\e]1337;SetUserVar='"${key}=${value}"$'\a'
}

→hooks-preexec() {
    builtin emulate -LR zsh ${=${options[xtrace]:#off}:+-o xtrace}
    builtin setopt extended_glob warn_create_global typeset_silent no_short_loops rc_quotes no_auto_pushd

    # Tell wezterm the full command that is being run.
    .hooks-set-user-var 'WEZTERM_PROG' "$1"

    .hooks-report-cwd
    .hooks-set-title "${2[(wr)^(*=*|ssh|sudo|-*)]}"
}

→hooks-precmd() {
    builtin emulate -LR zsh ${=${options[xtrace]:#off}:+-o xtrace}
    builtin setopt extended_glob warn_create_global typeset_silent no_short_loops rc_quotes no_auto_pushd

    .hooks-set-user-var 'WEZTERM_PROG' ''
    .hooks-set-user-var 'WEZTERM_IN_TMUX' "${${TMUX:+1}:-0}"

    .hooks-report-cwd
    .hooks-set-title

    # Clear progress tracking.
    print -rn $'\e]9;4;0\a'
}

autoload -Uz add-zsh-hook @term-set-title

add-zsh-hook preexec →hooks-preexec
add-zsh-hook precmd →hooks-precmd
