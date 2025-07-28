# -*- mode: zsh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# vim: ft=zsh tw=120 sw=4 sts=4 et foldmarker=[[[,]]]

+log-debug() {
    (( Juici[debug] )) || return

    builtin print -- "\e[1;33m[DEBUG\e[2m:${functrace[1]}\e[0;1;33m]\e[0m ${1}\e[0m"
}

+log-operation() {
    builtin print -- "\e[1;34m::\e[39m ${1}\e[0m"
}

+log-info() {
    local depth=0 msg="$1" color='1;34' prefix

    if (( $# > 1 )); then
        (( depth = ${msg#-} ))
        msg="$2"
    fi

    if (( depth > 0 )); then
        prefix="${(pl:${depth}:)} ->"
    else
        prefix='==>'
    fi

    builtin print -- "\e[${color}m${prefix}\e[0m ${msg}\e[0m"
}

+log-warn() {
    local depth=0 msg="$1" color='1;33' prefix

    if (( $# > 1 )); then
        (( depth = ${msg#-} ))
        msg="$2"
    fi

    if (( depth > 0 )); then
        prefix="${(pl:${depth}:)} -> WARNING:"
    else
        prefix='==> WARNING:'
    fi

    builtin print -- "\e[${color}m${prefix}\e[0m ${msg}\e[0m"
}

+log-error() {
    local depth=0 msg="$1" color='1;31' prefix

    if (( $# > 1 )); then
        (( depth = ${msg#-} ))
        msg="$2"
    fi

    if (( depth > 0 )); then
        prefix="${(pl:${depth}:)} -> ERROR:"
    else
        prefix='==> ERROR:'
    fi

    builtin print -- "\e[${color}m${prefix}\e[0m ${msg}\e[0m"
}
