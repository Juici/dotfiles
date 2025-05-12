# Load Plugins {{{

# keychain: Keychain SSH/GPG agent.
# bgnotify: Background notifier for long running commands.
zinit wait lucid for \
    has'keychain' \
        "${Juici[plugins]}/keychain" \
    "${Juici[plugins]}/bgnotify"

# F-Sy-H: Syntax highlighting.
# zsh-autosuggestions: Auto suggestions.
zinit wait'0b' lucid nocd for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
        z-shell/F-Sy-H \
    wait'0c' atload"→keybinds_onload_autosuggestions && _zsh_autosuggest_start && zle && zle autosuggest-fetch && zle redisplay" \
        zsh-users/zsh-autosuggestions

# }}}

# Settings {{{

# Auto suggestions {{{

# General.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=40
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Strategy.
ZSH_AUTOSUGGEST_STRATEGY=(history)
# ZSH_AUTOSUGGEST_STRATEGY=(history completion)

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

# }}}


# }}}
