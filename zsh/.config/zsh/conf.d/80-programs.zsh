# -*- mode: zsh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# vim: ft=zsh tw=120 sw=4 sts=4 et foldmarker=[[[,]]]

# TODO: Validate that the "command" in the path is not a symlink to nothing.

# rg: Replacement for grep.
# eza: Replacement for ls.
# fd: Replacement for find.
# bat: Replacement for cat.
# hexyl: Command-line hex viewer.
# hyperfine: Command-line benchmarking tool.
# vivid: LS_COLORS generator.
# dust: Replacement for du.
# delta: Replacement for diff.
# mold: Replacement for ld.
zinit wait lucid as'command' from'gh-r' completions for \
    if'[[ ! -v commands[rg] ]]' lbin'!ripgrep*/rg' \
        BurntSushi/ripgrep \
    if'[[ ! -v commands[eza] ]]' lbin'!eza*/eza' \
    atclone'curl -fsSLo _eza https://raw.githubusercontent.com/eza-community/eza/refs/heads/main/completions/zsh/_eza' \
    atpull'%atclone' \
        eza-community/eza \
    if'[[ ! -v commands[fd] ]]' lbin'!fd*/fd' \
        @sharkdp/fd \
    if'[[ ! -v commands[bat] ]]' lbin'!bat*/bat' \
    atclone'bat*/bat --completion zsh >! _bat' atpull'%atclone' \
        @sharkdp/bat \
    if'[[ ! -v commands[hexyl] ]]' lbin'!hexyl*/hexyl' \
        @sharkdp/hexyl \
    if'[[ ! -v commands[hyperfine] ]]' lbin'!hyperfine*/hyperfine' \
        @sharkdp/hyperfine \
    if'[[ ! -v commands[vivid] ]]' lbin'!vivid*/vivid' \
        @sharkdp/vivid \
    if'[[ ! -v commands[dust] ]]' lbin'!dust*/dust' \
        bootandy/dust \
    if'[[ ! -v commands[delta] ]]' lbin'!delta*/delta' \
    atclone'delta*/delta --generate-completion zsh >! _delta' atpull'%atclone' \
    atload'_comps[delta]=_delta' \
        dandavison/delta \
    if'[[ ! -v commands[mold] ]]' lbin'!mold*/bin/*' \
        rui314/mold

zinit wait lucid as'null' for \
    atclone'cargo build --bins --release' atpull'%atclone' \
    lbin'!target/release/termi' \
        Juici/termi
