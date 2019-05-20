autoload -U colors
colors

# LS_COLORS definitions.
zplugin ice atclone'dircolors -b LS_COLORS >! clrs.zsh' atpull'%atclone' pick'clrs.zsh' \
    atload'zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"'
zplugin light trapd00r/LS_COLORS
