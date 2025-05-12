#!/usr/bin/env zsh
# -*- mode: zsh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# vim: ft=zsh tw=120 sw=4 sts=4 et foldmarker=[[[,]]]

# LS_COLORS definitions.
zinit wait lucid blockf for \
    atclone'sort LS_COLORS | dircolors --sh - >! ls_colors.plugin.zsh' \
    atpull'%atclone' \
    atload'zstyle ":completion:*:default" list-colors "${(s.:.)LS_COLORS}"' \
        trapd00r/LS_COLORS
