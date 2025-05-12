#!/usr/bin/env zsh
# -*- mode: zsh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# vim: ft=zsh tw=120 sw=4 sts=4 et foldmarker=[[[,]]]

# General.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=40
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Strategy.
# ZSH_AUTOSUGGEST_STRATEGY=(history)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Widgets.
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(end-of-line)
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=(forward-char forward-word)
ZSH_AUTOSUGGEST_EXECUTE_WIDGETS=()
ZSH_AUTOSUGGEST_CLEAR_WIDGETS=(
    history-search-forward
    history-search-backward
    history-beginning-search-forward
    history-beginning-search-backward
    history-substring-search-up
    history-substring-search-down
    up-line-or-beginning-search
    down-line-or-beginning-search
    up-line-or-history
    down-line-or-history
    accept-line
    copy-earlier-word
    tab-complete
)

# F-Sy-H: Syntax highlighting.
# zsh-autosuggestions: Auto suggestions.
zinit wait'0c' lucid nocd for \
    atload'(( ${+functions[_zsh_highlight_bind_widgets]} )) && _zsh_highlight_bind_widgets; _zsh_autosuggest_start; zle && zle autosuggest-fetch && zle redisplay' \
        zsh-users/zsh-autosuggestions
