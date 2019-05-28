" Don't load plugins as vi.
if v:progname == 'vi'
  set noloadplugins
endif

let g:mapleader = "\<Space>"
let g:maplocalleader = "\\"

" Extension -> Filetype mappings.
let g:filetype_pl = 'prolog'

let g:vim_dir = fnamemodify(expand('<sfile>'), ':p:h')

" Language dependent indentation, syntax highlighting and more.
filetype indent plugin on
syntax on

" LanguageClient {{{

  let g:LanguageClient_serverCommands = {}

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

    " Load Plugins {{{

      " Language Server Protocol (LSP) support for vim.
      Plug 'autozimu/LanguageClient-neovim', {
            \ 'branch': 'next',
            \ 'do': 'sh install.sh',
            \ }

      "Plug 'chriskempson/base16-vim'
      Plug 'joshdick/onedark.vim'       " OneDark colour scheme.

      Plug 'itchyny/lightline.vim'      " Status line.
      Plug 'Yggdroot/indentLine'        " Indent guides.
      Plug 'wincent/terminus'           " Enhanced terminal features.
      Plug 'editorconfig/editorconfig'  " Support for .editorconfig files.

      " Syntax {{{



      " }}}

    " }}}

    " Finish loading plugins.
    call plug#end()

  endif

" }}}
