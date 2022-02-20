autoload -U colors
colors

# LS_COLORS definitions.
zi light-mode for \
    pick'clrs.zsh' \
    atclone'dircolors -b LS_COLORS >! clrs.zsh' \
    atpull'%atclone' \
    atload'zstyle ":completion:*:default" list-colors "${(s.:.)LS_COLORS}"' \
        trapd00r/LS_COLORS
