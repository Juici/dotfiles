#!/usr/bin/env zsh
# -*- mode: zsh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# vim: ft=zsh tw=120 sw=4 sts=4 et foldmarker=[[[,]]]

zmodload zsh/zutil

autoload -Uz list-processes

# Options [[[

setopt no_menu_complete     # Do not auto select first match for ambiguous completion.
setopt auto_menu            # Use menu completion on 2nd tab press.
setopt complete_in_word     # Complete from wherever the cursor is in word.
setopt always_to_end        # Move the cursor to the end of the word after completion.

setopt no_nomatch           # Do nothing when no completion match exists.

# ]]]

# Zstyle [[[
#
#     :completion:{function}:{completer}:{command}:{argument}:{tag}
#
# https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Completion-System-Configuration

# Completers to use.
zstyle ':completion:*::::' completer _complete _ignored

# Navigatable completion menu.
zstyle ':completion:*:*:*:*:*' menu select

# Make completion:
# - Try exact (case-sensitive) match first.
# - Then fall back to case-insensitive.
# - Accept abbreviations after . or _ or - (ie. f.b -> foo.bar).
# - Substring complete (ie. bar -> foobar).
zstyle ':completion:*' matcher-list \
    '' \
    '+m:{[:lower:]}={[:upper:]}' \
    '+m:{[:upper:]}={[:lower:]}' \
    '+m:{_-}={-_}' \
    'r:|[._-]=* r:|=*' \
    'l:|=* r:|=*'

# If the `_ignored` completer has only one match, show it anyway.
zstyle ':completion:*' single-ignored show

# Ignore completion functions (until the `_ignored` completer).
zstyle ':completion:*:functions' ignored-patterns '_*'

# Allow completion of ..<Tab> to ../ and beyond.
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(..) ]] && reply=(..)'

# $CDPATH is overpowered (can allow us to jump to 100s of directories) so tends
# to dominate completion; exclude path-directories from the tag-order so that
# they will only be used as a fallback if no completions are found.
zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories'

# Colour processes.
zstyle ':completion:*:*:*:*:processes' command 'list-processes'
zstyle ':completion:*:*:*:*:processes' list-colors '=(#b) #([0-9]##) ##-- ##(*) #=2=0=01;34'
zstyle ':completion:*:*:*:*:processes' sort numeric

# Don't complete user pollution.
() {
    local -a non_ignored_users=( root "$USERNAME" )

    zstyle ':completion:*:*:*:*:users' ignored-patterns "${(k)userdirs[@]:|non_ignored_users}"
}

# ]]]

# Plugins [[[

# zsh-users: general completions
# zsh-rust-completions: rustc/rustup/cargo
# pnpm-shell-completion: pnpm
zinit wait lucid blockf for \
    atpull'zinit creinstall -q .' \
        zsh-users/zsh-completions \
    atpull'zinit creinstall -q .' \
        Juici/zsh-rust-completions \
    atclone'./zplug.zsh' atpull'%atclone' \
        g-plane/pnpm-shell-completion

# TODO

# ]]]