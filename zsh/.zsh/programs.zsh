# Replacement for ls.
zinit ice wait'0' lucid if'(( ! $+commands[exa] ))' from'gh-r' as'program' mv'exa* -> exa' atclone'curl -o _exa https://raw.githubusercontent.com/ogham/exa/master/contrib/completions.zsh' atpull'%atclone'
zinit light ogham/exa

# Replacement for grep.
zinit ice wait'0' lucid if'(( ! $+commands[rg] ))' from'gh-r' as'program' mv'*/rg -> rg'
zinit light BurntSushi/ripgrep

# Replacement for find.
zinit ice wait'0' lucid if'(( ! $+commands[fd] ))' from'gh-r' as'program' mv'*/fd -> fd'
zinit light sharkdp/fd
