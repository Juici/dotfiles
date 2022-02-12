# Load Plugins {{{

# Keychain SSH/GPG agent.
zi ice wait nocd lucid id-as'local/keychain'
zi load ${Juici[PLUGINS]}/keychain

# Background notifier for long running commands.
zi ice wait nocd lucid id-as'local/bgnotify'
zi load ${Juici[PLUGINS]}/bgnotify


# Syntax highlighting.
zi ice wait nocd lucid atinit'ZI[COMPINIT_OPTS]=-C; zicompinit; zicdreplay'
zi load z-shell/fast-syntax-highlighting

# Auto suggestions.
zi ice wait nocd lucid atload'→keybinds_onload_autosuggestions && _zsh_autosuggest_start && zle && zle autosuggest-fetch && zle redisplay'
zi load zsh-users/zsh-autosuggestions

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
#ZSH_AUTOSUGGEST_STRATEGY=(history completion)

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
