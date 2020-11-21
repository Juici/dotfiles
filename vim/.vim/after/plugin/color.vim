function s:CheckColorScheme()
  if !has('termguicolors')
    let g:base16colorspace=256
  endif

  let g:onedark_hide_endofbuffer = 1
  let g:onedark_terminal_italics = 1

  " Set background and colour scheme.
  set background=dark
  silent! colorscheme onedark   " Fail silently if the colour scheme isn't available.

  " Allow for overrides.
  silent! doautocmd ColorScheme
endfunction

if v:progname !=# 'vi'
  "if has('autocmd')
  "  augroup juici_autocolor
  "    autocmd!
  "    autocmd FocusGained * call s:CheckColorScheme()
  "  augroup END
  "endif

  call s:CheckColorScheme()
endif
