# Programs {{{

# rg: Replacement for grep.
# exa: Replacement for ls.
# fd: Replacement for find.
# bat: Replacement for cat.
# hexyl: Command-line hex viewer.
# hyperfine: Command-line benchmarking tool.
# vivid: LS_COLORS generator.
# neovim: Replacement for vim.
zi wait lucid as'program' from'gh-r' for \
    if'(( ! ${+commands[rg]} ))' sbin'**/rg' \
        BurntSushi/ripgrep \
    if'(( ! ${+commands[eza]} ))' sbin'**/eza' cp'completions/eza.zsh _eza' \
        eza-community/eza \
    if'(( ! ${+commands[fd]} ))' sbin'**/fd' \
        @sharkdp/fd \
    if'(( ! ${+commands[bat]} ))' sbin'**/bat' \
        @sharkdp/bat \
    if'(( ! ${+commands[hexyl]} ))' sbin'**/hexyl' \
        @sharkdp/hexyl \
    if'(( ! ${+commands[hyperfine]} ))' sbin'**/hyperfine' \
        @sharkdp/hyperfine \
    if'(( ! ${+commands[vivid]} ))' sbin'**/vivid' \
        @sharkdp/vivid \
    if'(( ! ${+commands[nvim]} ))' sbin'**/bin/nvim' \
        neovim/neovim

# }}}

# Configs {{{

# Tweaks and configurations for bat.
zi wait lucid for \
    _local/config-bat

# }}}
