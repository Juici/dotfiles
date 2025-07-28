# -*- mode: zsh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# vim: ft=zsh tw=120 sw=4 sts=4 et foldmarker=[[[,]]]

zinit wait'0b' lucid nocd for \
    atinit'ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay' \
        zdharma-continuum/fast-syntax-highlighting
