" Vim filetype plugin file
" Language: ART

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setl formatoptions-=t

setl shiftwidth=2 tabstop=2

" Comments `(* comment *)`.
setl comments=s1:(*,mb:*,ex:*)

let b:undo_ftplugin = 'setl fo< com<'

