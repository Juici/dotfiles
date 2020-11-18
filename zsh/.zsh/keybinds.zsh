# Make sure terminal is in application mode when zle is active, since only then
# values from $terminfo are valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
    →keybinds_line_init() {
        echoti smkx
    }
    →keybinds_line_finish() {
        echoti rmkx
    }
    zle -N zle-line-init →keybinds_line_init
    zle -N zle-line-finish →keybinds_line_finish
fi

# Emacs style bindings
bindkey -e

# Page up and down through history.
(( ${+terminfo[kpp]} )) && bindkey "${terminfo[kpp]}" up-line-or-history
(( ${+terminfo[knp]} )) && bindkey "${terminfo[knp]}" down-line-or-history

# Fuzzy search history.
if (( ${+terminfo[kcuu1]} )); then
    autoload -U up-line-or-beginning-search
    zle -N up-line-or-beginning-search
    bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
fi
if (( ${+terminfo[kcud1]} )); then
    autoload -U down-line-or-beginning-search
    zle -N down-line-or-beginning-search
    bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
fi

# Home/End to beginning/end of line.
(( ${+terminfo[khome]} )) && bindkey "${terminfo[khome]}" beginning-of-line
(( ${+terminfo[kend]} )) && bindkey "${terminfo[kend]}" end-of-line

# Do history expansion.
bindkey ' ' magic-space

# Ctrl+Left to jump whole words.
(( ${+terminfo[kLFT5]} )) && bindkey "${terminfo[kLFT5]}" backward-word
bindkey '^[[1;5D' backward-word
# Ctrl+Right to jump whole words.
(( ${+terminfo[kRIT5]} )) && bindkey "${terminfo[kRIT5]}" forward-word
bindkey '^[[1;5C' forward-word

# Bind variations of [Ctrl]+[Shift]+[Alt]+Up to noop.
() {
    integer i
    for (( i = 3; i <= 8; i++ )); do
        (( ${+terminfo[kUP$i]} )) && bindkey -s "${terminfo[kUP$i]}" ''
        (( ${+terminfo[kDN$i]} )) && bindkey -s "${terminfo[kDN$i]}" ''
    done
}

# Shift+Tab goes to previous completion.
(( ${+terminfo[kcbt]} )) && bindkey "${terminfo[kcbt]}" reverse-menu-complete

# Backspace/Delete characters.
bindkey '^?' backward-delete-char
(( ${+terminfo[kdch1]} )) && bindkey "${terminfo[kdch1]}" delete-char

# Ctrl+Backspace to delete whole words.
bindkey '^H' backward-delete-word
bindkey '^_' backward-delete-word

# Ctrl+Delete to delete whole words.
(( ${+terminfo[kDC5]} )) && bindkey "${terminfo[kDC5]}" delete-word
bindkey '^[[3;5~' delete-word
[[ "$TERM" = 'linux' ]] && bindkey '^[[3~' delete-word

# Clear auto suggestions, expand/complete and fetch auto suggestions.
→keybinds_tab_complete() {
    # Expand glob or autocomplete.
    zle expand-or-complete
    # Fetch updated autosuggestion.
    zle autosuggest-fetch

    # Redisplay buffer.
    zle redisplay

    # TODO: Fix highlighting when tab completion fails.
}
zle -N tab-complete →keybinds_tab_complete
bindkey '^I' tab-complete

# Plugin Keybinds

# Key bindings for zsh-autosuggestions, called when plugin is loaded.
→keybinds_onload_autosuggestions() {
    # Use Ctrl+Space to accept whole suggestion.
    bindkey '^ ' autosuggest-accept

    # If zsh-fast-syntax-highlighting is already loaded rebind widgets to fix
    # highlighting issues from our new keybinds.
    if (( ${+functions[_zsh_highlight_bind_widgets]} )); then
        _zsh_highlight_bind_widgets
    fi
}
