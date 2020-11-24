"
" Tabbing and indentation.
"

let s:tab_size = 4

" Spaces per tab, when shifting.
execute 'set' 'shiftwidth=' . s:tab_size
" Spaces per tab.
execute 'set' 'tabstop=' . s:tab_size

" Use `shiftwidth` or tab/backspace at end of line.
if v:progname !=# 'vi'
  set softtabstop=-1
endif

set expandtab             " Use spaces instead of tabs.
set smarttab              " <Tab>/<BS> through tab sized whitespace.
set shiftround            " Always indent by a multiple of `shiftwidth`.
set autoindent            " Maintain indentation of current line.

"
" Line wrapping.
"

" Unrestricted backspacing in insert mode.
set backspace=indent,start,eol
if has('patch-8.2.0590')
  set backspace+=nostop
endif

" Hard wrap at 80 columns.
set textwidth=80

"
" Formatting.
"

set formatoptions+=n      " Smart auto-indenting in numbered lists.
if v:version > 703 || v:version == 703 && has('patch541')
  set formatoptions+=j    " Remove comment leader when joining comment lines.
endif

"
" Navigation.
"

" Allow <BS>/h/l/<Left>/<Right>/<Space> to cross line boundaries.
set whichwrap=b,h,l,s,<,>,[,],~

" Allow cursor to move where there is no text when in vistual block mode.
if has('virtualedit')
  set virtualedit=block
endif

" Start scrolling 3 lines before reaching the edge of the viewport.
set scrolloff=3
" Start scrolling 3 columns before reaching the edge of the viewport.
set sidescrolloff=3
