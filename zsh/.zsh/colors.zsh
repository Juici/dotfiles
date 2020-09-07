autoload -U colors
colors

# LS_COLORS definitions.
zinit ice atclone'dircolors -b LS_COLORS >! clrs.zsh' atpull'%atclone' pick'clrs.zsh' \
    atload'zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"'
zinit light trapd00r/LS_COLORS
