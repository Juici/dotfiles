# Load Plugins {{{

# Keychain SSH/GPG agent.
zinit ice wait lucid id-as'local/keychain'
zinit load $LOCAL_PLUGINS/keychain

# Background notifier for long running commands.
zinit ice wait lucid id-as'local/bgnotify'
zinit load $LOCAL_PLUGINS/bgnotify

# Tweaks and configurations for bat.
zinit ice wait lucid id-as'local/bat' has'bat'
zinit load $LOCAL_PLUGINS/bat


# Syntax highlighting.
zinit ice wait'!' lucid atinit'zicompinit; zicdreplay'
zinit load zdharma/fast-syntax-highlighting

# Auto suggestions.
zinit ice wait'!' lucid atload'_zsh_autosuggest_start'
zinit load zsh-users/zsh-autosuggestions

# }}}

# Settings {{{

# Auto suggestions.
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1          # Fix double acceptance bug with forward-word.

# }}}

