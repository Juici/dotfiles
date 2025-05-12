#!/usr/bin/env zsh
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

# TODO
# Kitty keyboard protocol: https://sw.kovidgoyal.net/kitty/keyboard-protocol/

# Emacs style bindings.
bindkey -e

typeset -gA Key=(
    up      "${(V)terminfo[kcuu1]:-^[OA}"
    down    "${(V)terminfo[kcud1]:-^[OB}"
    right   "${(V)terminfo[kcuf1]:-^[OC}"
    left    "${(V)terminfo[kcub1]:-^[OD}"

    home    "${(V)terminfo[khome]:-^[OH}"
    end     "${(V)terminfo[kend]:-^[OF}"

    backspace   "${(V)terminfo[kbs]:-^?}"
)

# TODO: Create a state machine based parser, using bindings for every byte?
