# Replacement for ls.
zinit ice wait'0' lucid if'(( ! $+commands[exa] ))' from'gh-r' as'program' mv'exa* -> exa'
zinit light ogham/exa

# Replacement for grep.
zinit ice wait'0' lucid if'(( ! $+commands[rg] ))' from'gh-r' as'program' mv'complete/_rg -> _rg'
zinit light BurntSushi/ripgrep

# Replacement for find.
zinit ice wait'0' lucid if'(( ! $+commands[fd] ))' from'gh-r' as'program' mv'autocomplete/_fd -> _fd'
zinit light sharkdp/fd
