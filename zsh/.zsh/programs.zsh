# Programs {{{

# Replacement for ls.
zi ice wait lucid if'(( ! ${+commands[exa]} ))' from'gh-r' as'program' mv'exa* -> exa' atclone'curl -o _exa https://raw.githubusercontent.com/ogham/exa/master/contrib/completions.zsh' atpull'%atclone'
zi light ogham/exa

# Replacement for grep.
zi ice wait lucid if'(( ! ${+commands[rg]} ))' from'gh-r' as'program' mv'*/rg -> rg'
zi light BurntSushi/ripgrep

# Replacement for find.
zi ice wait lucid if'(( ! ${+commands[fd]} ))' from'gh-r' as'program' mv'*/fd -> fd'
zi light sharkdp/fd

# Replacement for cat.
zi ice wait lucid if'(( ! ${+commands[bat]} ))' from'gh-r' as'program' mv'*/bat -> bat' atclone'mv */autocomplete/bat.zsh _bat' atpull'%atclone'
zi light sharkdp/bat

# Hex viewer.
zi ice wait lucid if'(( ! ${+commands[hexyl]} ))' from'gh-r' as'program' mv'*/hexyl -> hexyl'
zi light sharkdp/hexyl

# Replacement for vim.
zi ice wait lucid if'(( ! ${+commands[nvim]} ))' from'gh-r' as'program' pick'*/bin/nvim'
zi light neovim/neovim

# }}}

# Configs {{{

# Tweaks and configurations for bat.
zi ice wait lucid id-as'local/bat'
zi load ${Juici[CONFIGS]}/bat

# }}}
