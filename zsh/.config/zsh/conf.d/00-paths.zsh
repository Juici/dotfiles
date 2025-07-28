# -*- mode: zsh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# vim: ft=zsh tw=120 sw=4 sts=4 et foldmarker=[[[,]]]

typeset -gU cdpath fpath mailpath manpath path
typeset -gUT INFOPATH infopath
typeset -gUT GOPATH gopath

# Set GOPATH.
gopath=(
    "${HOME}/go"
)

# Paths to look for executable files.
path=(
    "${HOME}/.local/bin"
    "${HOME}/.cargo/bin"
    "${^gopath[@]}/bin"
    /usr/local/{,s}bin
    /usr/{,s}bin
    /{,s}bin
    "${path[@]}"
)

# Paths to look for man pages.
manpath=(
    "${HOME}/.local/share/man"
    /usr/local/share/man
    /usr/share/man
    "${manpath[@]}"
)

# Paths to look for info pages.
infopath=(
    "${HOME}/.local/share/info"
    /usr/local/share/info
    /usr/share/info
    "${infopath[@]}"
)
