function s:CheckColorScheme()
  if !has('termguicolors')
    let g:base16colorspace=256
  endif

  " Set background and colour scheme.
  set background=dark
  colorscheme onedark

  call s:ColorSchemeTweaks()

  " Allow for overrides.
  doautocmd ColorScheme
endfunction

function s:ColorSchemeTweaks()
  highlight markdownItalic gui=italic cterm=italic
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
