# -*- mode: zsh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# vim: ft=zsh tw=120 sw=4 sts=4 et foldmarker=[[[,]]]

zmodload zsh/terminfo

# ZLE Application Mode [[[

# Make sure terminal is in application mode when zle is active, since only then
# are values from $terminfo valid.
if [[ -v terminfo[smkx] && -v terminfo[rmkx] ]]; then

    →keybinds-zle-line-init() {
        # Enable application mode in terminal.
        echoti smkx
    }

    →keybinds-zle-line-finish() {
        # Disable application mode in terminal.
        echoti rmkx
    }

    autoload -Uz add-zle-hook-widget

    add-zle-hook-widget line-init →keybinds-zle-line-init
    add-zle-hook-widget line-finish →keybinds-zle-line-finish

fi

# ]]]

# Emacs style bindings.
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

# Bind Shift+{Left,Right} to noop.
(( ${+terminfo[kLFT]} )) && bindkey -s "${terminfo[kLFT]}" ''
(( ${+terminfo[kRIT]} )) && bindkey -s "${terminfo[kRIT]}" ''

# Bind variations of [Ctrl]+[Shift]+[Alt]+{Up,Down} to noop.
() {
    (( ${+terminfo[kUP]} )) && bindkey -s "${terminfo[kUP]}" ''
    (( ${+terminfo[kDN]} )) && bindkey -s "${terminfo[kDN]}" ''

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
→keybinds-tab-complete() {
    # Expand glob or autocomplete.
    zle expand-or-complete
    # Fetch updated autosuggestion.
    zle autosuggest-fetch

    # Redisplay buffer.
    zle redisplay

    # FIXME: Highlighting breaks when tab completion fails.
    # FIXME: Autosuggestions occasionally don't get cleared.
}
zle -N tab-complete →keybinds-tab-complete
bindkey '^I' tab-complete

# Kitty keyboard protocol: https://sw.kovidgoyal.net/kitty/keyboard-protocol/

# TODO: Create a state machine based parser, using bindings for every byte?
