" Vim filetype plugin file
" Language: Tig config

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setlocal formatoptions-=t
setlocal shiftwidth=4 tabstop=4
setlocal comments=b:#

let b:undo_ftplugin = 'setlocal formatoptions< shiftwidth< tabstop< comments<'
