" Don't set colour scheme in vi.
if v:progname ==# 'vi'
  finish
endif

function! s:update_colors() abort
  call juici#color#refresh()
endfunction

if has('autocmd')
  augroup juici_colorscheme
    autocmd!
    autocmd ColorScheme * silent call s:update_colors()
  augroup END
endif

let g:onedark_hide_endofbuffer = 1
let g:onedark_terminal_italics = 1

" Set background to dark.
set background=dark
" Set the colour scheme.
silent! colorscheme onedark

if !has('autocmd') && get(g:, 'colors_name', v:null) ==# 'onedark'
  call update_colors()
endif
