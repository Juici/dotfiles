#!/usr/bin/env zsh
# -*- mode: zsh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# vim: ft=zsh tw=120 sw=4 sts=4 et foldmarker=[[[,]]]

# rg: Replacement for grep.
# eza: Replacement for ls.
# fd: Replacement for find.
# bat: Replacement for cat.
# hexyl: Command-line hex viewer.
# hyperfine: Command-line benchmarking tool.
# vivid: LS_COLORS generator.
# neovim: Replacement for vim.
zinit wait lucid as'null' from'gh-r' for \
    if'(( ! ${+commands[rg]} ))' lbin'!**/rg' \
        BurntSushi/ripgrep \
    if'(( ! ${+commands[eza]} ))' lbin'!**/eza' cp'completions/eza.zsh _eza' \
        eza-community/eza \
    if'(( ! ${+commands[fd]} ))' lbin'!**/fd' \
        sharkdp/fd \
    if'(( ! ${+commands[bat]} ))' lbin'!**/bat' \
        sharkdp/bat \
    if'(( ! ${+commands[hexyl]} ))' lbin'!**/hexyl' \
        sharkdp/hexyl \
    if'(( ! ${+commands[hyperfine]} ))' lbin'!**/hyperfine' \
        sharkdp/hyperfine \
    if'(( ! ${+commands[vivid]} ))' lbin'!**/vivid' \
        sharkdp/vivid \
    if'(( ! ${+commands[nvim]} ))' lbin'!**/bin/nvim' \
        neovim/neovim

zinit wait lucid as'null' for \
    atclone'cargo build --bins --release' atpull'%atclone' \
    lbin'!target/release/termi' \
        Juici/termi
