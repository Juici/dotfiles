# -*- mode: zsh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# vim: ft=zsh tw=120 sw=4 sts=4 et foldmarker=[[[,]]]

(( ${+commands[bat]} )) || return

# Aliases [[[

alias batp='bat --paging=always'

# ]]]

# Config [[[

() {
    local -a opts=(
        # Set sane defaults.
        --paging='never'        # No paging by default.
        --italic-text='always'  # Allow italics.

        # Theme and styling.
        --theme='TwoDark'
        --style='changes,header,numbers,grid'

        # Syntax mapping.
        --map-syntax='.ignore:gitignore'
    )

    export BAT_PAGER='less -RF'
    export BAT_OPTS="${(F)opts}"
}

# ]]]
