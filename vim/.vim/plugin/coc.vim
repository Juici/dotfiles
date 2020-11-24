"
" Custom colours for CoC.
"

call juici#color#set('CocHighlightText', { 'bg': { 'gui': '#333843', 'cterm': '238' } })

call juici#color#link('CocErrorSign', 'ErrorMsg')
call juici#color#link('CocWarningSign', 'WarningMsg')
call juici#color#link('CocInfoSign', 'WarningMsg')
call juici#color#set('CocHintSign', { 'fg': { 'gui': get(g:, 'terminal_color_4', '#61AFEF'), 'cterm': 39 } })
