scriptencoding utf-8

let s:middot = '·'
let s:raquo = '»'
let s:small_l = 'ℓ'

" Override default `foldtext()`, which produces something like:
"
"   +---  2 lines: source $HOME/path/to/file/being/edited----------------------
"
" Instead returning:
"
"   »··[2ℓ]··: source $HOME/path/to/file/being/edited··························
"
function! juici#settings#FoldText() abort
  let l:lines = '[' . (v:foldend - v:foldstart + 1) . s:small_l . ']'
  let l:first = substitute(getline(v:foldstart), '\v *', '', '')
  let l:dashes = substitute(v:folddashes, '-', s:middot, 'g')
  return s:raquo . s:middot . s:middot . l:lines . l:dashes . ': ' . l:first
endfunction
