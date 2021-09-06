" Vim filetype plugin file
" Language: ART

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setlocal formatoptions-=t
setlocal shiftwidth=2 tabstop=2
setlocal comments=s1:(*,mb:*,ex:*)

let b:undo_ftplugin = 'setlocal formatoptions< shiftwidth< tabstop< comments<'
