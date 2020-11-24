" Don't load plugins as vi,
" otherwise don't allow compatible mode.
if v:progname ==# 'vi'
  set noloadplugins
elseif &compatible
  set nocompatible
endif

" Speed up start by not searching for python executable.
if filereadable('/usr/bin/python3')
  let g:python3_host_prog = '/usr/bin/python3'
endif

" Map leaders.
let g:mapleader = "\<Space>"
let g:maplocalleader = "\\"

" Extension -> Filetype mappings.
let g:filetype_pl = 'prolog'

" The .vim directory.
let g:vim_dir = expand('<sfile>:p:h')

" Load local configurations.
let s:init_local = g:vim_dir . '/init.local.vim'
if filereadable(s:init_local)
  execute 'source' s:init_local
endif

let g:linux_console = $TERM =~# '\V\_^linux'

" Load that need to be loaded early, ie. before plugins.
call juici#settings#load_settings()

" Load plugins.
if &loadplugins
  call juici#plugins#load()
endif

" Language dependent indentation, syntax highlighting and more.
" Note: This must come after plugin loading, due to dein disabling it.
filetype indent plugin on
syntax on
