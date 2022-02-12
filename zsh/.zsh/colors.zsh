autoload -U colors
colors

# LS_COLORS definitions.
zi ice atclone'dircolors -b LS_COLORS >! clrs.zsh' atpull'%atclone' pick'clrs.zsh' \
    atload'zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"'
zi light trapd00r/LS_COLORS
