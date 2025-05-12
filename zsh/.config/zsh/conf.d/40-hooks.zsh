#!/usr/bin/env zsh
# -*- mode: zsh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# vim: ft=zsh tw=120 sw=4 sts=4 et foldmarker=[[[,]]]

.hooks-title-pwd() {
    local match mbegin mend wd="${(D)PWD}"

    (( ${#wd} > 20 )) && wd=${wd//(#b)('~'[^\/]#|(.|)[^\/])[^\/]#\//"${match[1]}/"}

    builtin print -rn -- "$wd"
}

→hooks-preexec() {
    builtin emulate -LR zsh ${=${options[xtrace]:#off}:+-o xtrace}
    builtin setopt extended_glob warn_create_global typeset_silent no_short_loops rc_quotes no_auto_pushd

    local cmd="${2[(wr)^(*=*|ssh|sudo|-*)]}"

    # Report current working directory.
    builtin print -rn $'\e]7;'"${PWD}"$'\a'

    @term-set-title "$(.hooks-title-pwd) - ${cmd}"
}

→hooks-precmd() {
    builtin emulate -LR zsh ${=${options[xtrace]:#off}:+-o xtrace}
    builtin setopt extended_glob warn_create_global typeset_silent no_short_loops rc_quotes no_auto_pushd

    # Report current working directory.
    builtin print -rn $'\e]7;'"${PWD}"$'\a'

    @term-set-title "$(.hooks-title-pwd)"
}

autoload -Uz add-zsh-hook @term-set-title

add-zsh-hook preexec →hooks-preexec
add-zsh-hook precmd →hooks-precmd
