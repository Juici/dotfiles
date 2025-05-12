#!/usr/bin/env zsh
# -*- mode: zsh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# vim: ft=zsh tw=120 sw=4 sts=4 et foldmarker=[[[,]]]

# Shortcuts for paths, eg. `cd ~abc`.
# For a full list, run `hash -d` (alias `d`).

() {
    local -AU dirs

    local zsh="${${(%):-%x}:A:h:h}"

    dirs=(
        zsh         "$zsh"
        dotfiles    "${zsh:h:h:h}"
    )

    local name dir
    for name dir in "${(kv)dirs[@]}"; do
        [[ -d "$dir" ]] && hash -d "$name"="$dir"
    done
}
