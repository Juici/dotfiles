# Programs {{{

# Replacement for ls.
zinit ice wait lucid if'(( ! ${+commands[exa]} ))' from'gh-r' as'program' mv'exa* -> exa' atclone'curl -o _exa https://raw.githubusercontent.com/ogham/exa/master/contrib/completions.zsh' atpull'%atclone'
zinit light ogham/exa

# Replacement for grep.
zinit ice wait lucid if'(( ! ${+commands[rg]} ))' from'gh-r' as'program' mv'*/rg -> rg'
zinit light BurntSushi/ripgrep

# Replacement for find.
zinit ice wait lucid if'(( ! ${+commands[fd]} ))' from'gh-r' as'program' mv'*/fd -> fd'
zinit light sharkdp/fd

# Replacement for cat.
zinit ice wait lucid if'(( ! ${+commands[bat]} ))' from'gh-r' as'program' mv'*/bat -> bat' atclone'mv */autocomplete/bat.zsh _bat' atpull'%atclone'
zinit light sharkdp/bat

# Hex viewer.
zinit ice wait lucid if'(( ! ${+commands[hexyl]} ))' from'gh-r' as'program' mv'*/hexyl -> hexyl'
zinit light sharkdp/hexyl

# Replacement for vim.
zinit ice wait lucid if'(( ! ${+commands[nvim]} ))' from'gh-r' as'program' pick'*/bin/nvim'
zinit light neovim/neovim

# }}}

# Configs {{{

# Tweaks and configurations for bat.
zinit ice wait lucid id-as'local/bat'
zinit load ${Juici[CONFIGS]}/bat

# }}}
