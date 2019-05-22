" Get init.vim file.
let s:init_vim = expand('<sfile>:p:h') . '/.vim/init.vim'

if filereadable(s:init_vim)
    exec 'source ' . s:init_vim
else
    echom 'Could not find init file ' . s:init_vim
endif
