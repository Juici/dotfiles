" Don't load plugins as vi.
if v:progname == 'vi'
  set noloadplugins
endif

" Map leaders.
let g:mapleader = "\<Space>"
let g:maplocalleader = "\\"

" Extension -> Filetype mappings.
let g:filetype_pl = 'prolog'

" The .vim directory.
let g:vim_dir = fnamemodify(expand('<sfile>'), ':p:h')

" Language dependent indentation, syntax highlighting and more.
filetype indent plugin on
syntax on

" Speed up start by not searching for python executable.
if filereadable('/usr/bin/python3')
  let g:python3_host_prog = '/usr/bin/python3'
endif

" LanguageClient {{{

  " Language Servers {{{

  let g:LanguageClient_serverCommands = {}

  let s:rust_lsp = executable('rustup')
        \ ? [exepath('rustup'), 'run', 'nightly', 'rls']
        \ : []

  let s:python_lsp = executable('pyls')
        \ ? [exepath('pyls')]
        \ : []

  if s:rust_lsp != []
    let g:LanguageClient_serverCommands['rust'] = s:rust_lsp
  endif

  if s:python_lsp != []
    let g:LanguageClient_serverCommands['python'] = s:python_lsp
  endif

  " }}}

" }}}

" Load local configurations.
let s:init_local = g:vim_dir . '/init.local.vim'
if filereadable(s:init_local)
  execute 'source' s:init_local
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
      execute 'source' s:plugins_local
    endif

    " Load Plugins {{{

      " Language Server Protocol (LSP) support for vim.
      Plug 'autozimu/LanguageClient-neovim', {
            \   'branch': 'next',
            \   'do': 'sh install.sh'
            \ }

      "Plug 'chriskempson/base16-vim'
      Plug 'joshdick/onedark.vim'       " OneDark colour scheme.

      Plug 'itchyny/lightline.vim'      " Status line.
      Plug 'Yggdroot/indentLine'        " Indent guides.

      Plug 'wincent/terminus'           " Enhanced terminal features.
      Plug 'editorconfig/editorconfig'  " Support for .editorconfig files.

      Plug 'tpope/vim-fugitive'         " Git wrapper.

      " Completion {{{

        if has('nvim')
          Plug 'Shougo/deoplete.nvim', {
                \   'do': ':UpdateRemotePlugins'
                \ }
        else
          Plug 'Shougo/deoplete.nvim'
          Plug 'roxma/nvim-yarp'
          Plug 'roxma/vim-hug-neovim-rpc'
        endif

        let g:deoplete#enable_at_startup = 1

      " }}}

      " Languages {{{

        Plug 'zplugin/zplugin-vim-syntax' " Zplugin syntax highlighting.

        Plug 'cespare/vim-toml' " TOML syntax highlighting.
        Plug 'neovimhaskell/haskell-vim' " Haskell syntax highlighting.

      " }}}

    " }}}

    " Finish loading plugins.
    call plug#end()

  endif

" }}}
