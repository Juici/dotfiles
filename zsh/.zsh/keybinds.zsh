# Make sure terminal is in application mode when zle is active, since only then
# values from $terminfo are valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
    zle-line-init() {
        echoti smkx
    }
    zle-line-finish() {
        echoti rmkx
    }
    zle -N zle-line-init
    zle -N zle-line-finish
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

# Ctrl+Left/Right to jump whole words.
(( ${+terminfo[kLFT5]} )) && bindkey "${terminfo[kLFT5]}" backward-word
[[ "$TERM" = 'linux' ]] && bindkey '^[[D' backward-word
bindkey '^[[1;5D' backward-word

forward-word() {
    zle .forward-word
    zle autosuggest-fetch
}
zle -N forward-word
(( ${+terminfo[kRIT5]} )) && bindkey "${terminfo[kRIT5]}" forward-word
[[ "$TERM" = 'linux' ]] && bindkey '^[[C' forward-word
bindkey '^[[1;5C' forward-word

# Ctrl+Up/Down noop, require for some systems.
[[ "$TERM" = 'linux' ]] && bindkey -s '^[[A' ''
bindkey -s '^[[1;5A' ''
[[ "$TERM" = 'linux' ]] && bindkey -s '^[[B' ''
bindkey -s '^[[1;5B' ''

# Shift+Tab goes to previous completion.
(( ${+terminfo[kcbt]} )) && bindkey "${terminfo[kcbt]}" reverse-menu-complete

# # Backspace/Delete characters.
# bindkey "^?" backward-delete-char
# (( ${+terminfo[kdch1]} )) && bindkey "${terminfo[kdch1]}" delete-char
# # Ctrl+Backspace/Ctrl+Delete to delete whole words.
# (( ${+terminfo[kbs]} )) && bindkey "${terminfo[kbs]}" backward-delete-word
# (( ${+terminfo[kDC5]} )) && bindkey "${terminfo[kDC5]}" delete-word

# Backspace/Delete characters.
bindkey '^?' backward-delete-char
(( ${+terminfo[kdch1]} )) && bindkey "${terminfo[kdch1]}" delete-char
# Ctrl+Backspace/Ctrl+Delete to delete whole words.
bindkey '^H' backward-delete-word
bindkey '^_' backward-delete-word
(( ${+terminfo[kDC5]} )) && bindkey "${terminfo[kDC5]}" delete-word
bindkey '^[[3;5~' delete-word

# Clear auto suggestions, expand/complete and fetch auto suggestions.
tab-complete() {
    # Fix autosuggest interaction issues with tab completion.
    zle autosuggest-clear

    #zle -R 'Completing...'
    zle expand-or-complete

    zle autosuggest-fetch

    # Redisplay prompt.
    zle redisplay

    # TODO: Fix highlighting when tab completion fails.
}
zle -N tab-complete
bindkey '^I' tab-complete
