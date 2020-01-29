# Load Plugins {{{

# Keychain SSH/GPG agent.
zplugin ice wait'0' lucid id-as'local/keychain'
zplugin load $LOCAL_PLUGINS/keychain

# Background notifier for long running commands.
zplugin ice wait'0' lucid id-as'local/bgnotify'
zplugin load $LOCAL_PLUGINS/bgnotify

# Tweaks and configurations for bat.
zplugin ice wait'0' lucid id-as'local/bat' has'bat'
zplugin load $LOCAL_PLUGINS/bat


# Syntax highlighting.
zplugin ice wait'!0' lucid atinit'zpcompinit; zpcdreplay'
zplugin load zdharma/fast-syntax-highlighting

# Auto suggestions.
zplugin ice wait'!0' lucid atload'_zsh_autosuggest_start'
zplugin load zsh-users/zsh-autosuggestions

# }}}

# Settings {{{

# Auto suggestions.
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1          # Fix double acceptance bug with forward-word.

# }}}

