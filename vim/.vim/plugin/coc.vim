"
" Settings.
"

" Diagnostic icons.
if g:linux_console
  call coc#config('diagnostic.errorSign', 'E')
  call coc#config('diagnostic.warningSign', 'W')
  call coc#config('diagnostic.infoSign', 'i')
  call coc#config('diagnostic.hintSign', '?')
else
  call coc#config('diagnostic.errorSign', '✘')
  call coc#config('diagnostic.warningSign', '')
  call coc#config('diagnostic.infoSign', '')
  call coc#config('diagnostic.hintSign', '')
endif

"
" Custom colours for CoC.
"

call juici#color#set('CocHighlightText', { 'bg': { 'gui': '#333843', 'cterm': '238' } })

call juici#color#link('CocErrorSign', 'ErrorMsg')
call juici#color#link('CocWarningSign', 'WarningMsg')
call juici#color#link('CocInfoSign', 'WarningMsg')
call juici#color#set('CocHintSign', { 'fg': { 'gui': get(g:, 'terminal_color_4', '#61AFEF'), 'cterm': '39' } })

"
" Custom commands.
"

" Format the current buffer.
command! -nargs=0 Format :call CocAction('format')

" Sort import statements in the current buffer.
command! -nargs=0 SortImports :call CocAction('runCommand', 'editor.action.organizeImport')
