let s:dein_vim_dir = has('nvim') ? 'nvim' : 'vim'
let s:plugin_dir = '~/.cache/dein/' . s:dein_vim_dir
let s:dein_dir = s:plugin_dir . '/repos/github.com/Shougo/dein.vim'

function! s:install_dein() abort
  let l:plugin_dir = fnamemodify(resolve(expand(s:plugin_dir)), ':p')
  let l:dein_dir = fnamemodify(expand(s:dein_dir), ':p')

  let l:dein_repo = 'https://github.com/Shougo/dein.vim'

  try
    " Check for plugin directory.
    if !isdirectory(l:dein_dir)
      call juici#log#warn('Missing dein plugin manager')
      if executable('git')
        call juici#log#info('Installing dein at ' . l:dein_dir)

        " Create plugin directory.
        call juici#util#mkdirp(l:dein_dir)

        " Git clone dein into plugins.
        call system('git clone --depth=1 ' . shellescape(l:dein_repo) . ' ' . shellescape(l:dein_dir))
        if v:shell_error
          call juici#log#error('Failed to install dein')
          return 0
        endif
      else
        call juici#log#error('Cannot install dein, git executable not found')
        return 0
      endif
    endif
  catch
    call juici#log#error(v:exception)
    return 0
  endtry

  return 1
endfunction

function! juici#plugins#load() abort
  " Ensure dein is installed.
  if s:install_dein()
    " Add dein to runtime path.
    execute 'set' 'runtimepath+=' . s:dein_dir

    " The path to this file, used to invalidate cache when modified.
    let l:plugins_file = g:vim_dir . '/autoload/juici/plugins.vim'

    if dein#load_state(s:plugin_dir)
      call dein#begin(s:plugin_dir, [l:plugins_file])

      call dein#add(s:dein_dir)     " Load dein plugin.

      call s:load_general()         " Load general plugins.
      call s:load_syntax()          " Load syntax plugins.

      call dein#add('neoclide/coc.nvim', { 'branch': 'release' }) " Load CoC.

      call dein#end()
      call dein#save_state()
    endif
  endif
endfunction

function! s:load_general() abort
  call dein#add('joshdick/onedark.vim')       " OneDark colour scheme.

  call dein#add('Yggdroot/indentLine')        " Indent guides.
  call dein#add('editorconfig/editorconfig')  " Support for `.editorconfig` files.
  call dein#add('wincent/terminus')           " Enhanced terminal features.

  call dein#add('tpope/vim-fugitive')         " Git wrapper.
endfunction

function! s:load_syntax() abort
  " Load polyglot enhanced syntax.
  call dein#add('sheerun/vim-polyglot')

  " Use treesitter syntax highlighting.
  call dein#add('nvim-treesitter/nvim-treesitter', {
        \   'branch': '0.5-compat',
        \   'hook_post_update': 'TSUpdate'
        \ })
endfunction
