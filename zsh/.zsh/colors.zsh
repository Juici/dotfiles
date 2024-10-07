# LS_COLORS definitions.
zinit wait lucid blockf for \
    atclone'dircolors -b LS_COLORS >! clrs.plugin.zsh' \
    atpull'%atclone' \
    atload'zstyle ":completion:*:default" list-colors "${(s.:.)LS_COLORS}"' \
        trapd00r/LS_COLORS
