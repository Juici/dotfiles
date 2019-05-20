# {{{ Load Plugins

# Keychain SSH/GPG agent.
zplugin ice id-as'local/keychain' wait'0' lucid
zplugin light $LOCAL_PLUGINS/keychain

# Background notifier for long running commands.
zplugin ice id-as'local/bgnotify' wait'0' lucid
zplugin light $LOCAL_PLUGINS/bgnotify

# Tweaks and configurations for bat.
zplugin ice id-as'local/bat'
zplugin light $LOCAL_PLUGINS/bat


# Tmux aliases and colour support.
#zplugin ice svn
#zplugin snippet OMZ::plugins/tmux

# Auto suggestions.
zplugin ice wait'!0' atload'_zsh_autosuggest_start' lucid
zplugin light zsh-users/zsh-autosuggestions

# Syntax highlighting. LAST PLUGIN LOADED.
zplugin ice wait'1' atinit'zpcompinit; zpcdreplay' lucid
zplugin light zdharma/fast-syntax-highlighting

# }}}

# {{{ Settings

# Auto suggestions.
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1          # Fix double acceptance bug with forward-word.

# }}}

