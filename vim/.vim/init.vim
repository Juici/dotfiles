" Don't load plugins as vi.
if v:progname == 'vi'
  set noloadplugins
endif

let g:mapleader = '\<Space>'
let g:maplocalleader = '\\'

" Extension -> Filetype mappings.
let g:filetype_pl = 'prolog'

let g:vim_dir = expand('<sfile>:p:h')

" Language dependent indentation, syntax highlighting and more.
filetype indent plugin on
syntax on

" LanguageClient {{{

  " TODO: Configure LanguageClient.

" }}}

" Load local configurations.
let s:init_local = g:vim_dir . '/init.local.vim'
if filereadable(s:init_local)
  execute 'source ' . s:init_local
endif

" Plugins {{{

  if &loadplugins

    " Ensure vim-plug is installed.
    call juici#functions#PlugLoad()

    " Load vim-plug.
    let s:plugged_dir = g:vim_dir . '/plugged'
    call plug#begin(s:plugged_dir)

    " Load local plugins.
    let s:plugins_local = g:vim_dir . '/plugins.local.vim'
    if filereadable(s:plugins_local)
      execute 'source ' . s:plugins_local
    endif

    " TODO: Load plugins.

    " Finish loading plugins.
    call plug#end()

  endif

" }}}
