" Don't set colour scheme in vi.
if v:progname ==# 'vi'
  finish
endif

function! s:set_termguicolors() abort
  " Disable `termguicolors` for linux console.
  if g:linux_console
    set notermguicolors
  endif
endfunction

function! s:update_colors() abort
  call s:set_termguicolors()
  call juici#color#refresh()
endfunction

if has('autocmd')
  augroup juici_colorscheme
    autocmd!
    autocmd ColorSchemePre * silent call s:set_termguicolors()
    autocmd ColorScheme * silent call s:update_colors()
  augroup END
endif

let g:onedark_hide_endofbuffer = 1
let g:onedark_terminal_italics = g:linux_console ? 0 : 1

" Set background to dark.
set background=dark
" Set the colour scheme.
silent! colorscheme onedark

if !has('autocmd')
  call s:update_colors()
endif
