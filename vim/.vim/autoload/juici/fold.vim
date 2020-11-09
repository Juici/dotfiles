scriptencoding utf-8

let s:middot = '·'
let s:raquo = '»'
let s:small_l = 'ℓ'

let s:lines_pad_len = 4   " The number of digits to pad lines number to.

" Override default `foldtext()`, which produces something like:
"
"   +---  2 lines: source $HOME/path/to/file/being/edited----------------------
"
" Instead returning:
"
"   »······[2ℓ]·· source $HOME/path/to/file/being/edited ······················
"
function! juici#fold#fold_text() abort
  let l:fold_len = v:foldend - v:foldstart + 1

  let l:lines_prefix = '['
  let l:lines_suffix = s:small_l . ']'
  let l:pad_len = s:lines_pad_len + strlen(l:lines_prefix) + strlen(l:lines_suffix)

  let l:lines = l:lines_prefix . l:fold_len . l:lines_suffix
  let l:lines = substitute(printf('%' . l:pad_len . 's', l:lines), ' ', s:middot, 'g')

  let l:first = s:cleanup_fold_text(getline(v:foldstart))
  "let l:dashes = substitute(v:folddashes, '-', s:middot, 'g')

  return s:raquo . s:middot . s:middot . l:lines . s:middot . s:middot . ' ' . l:first . ' '
endfunction

" Clean up comment markers and fold markers from fold text.
"
" Based on the default implementation.
function! s:cleanup_fold_text(str) abort
  " Trim whitespace from the comment string.
  let l:cms_start = trim(&commentstring)

  " Locate `%s` and use the part before it.
  let l:cms_end = ''
  let l:cms_end_idx = stridx(l:cms_start, '%s')

  if l:cms_end_idx != -1
    " Skip `%s` and trim whitespace.
    let l:cms_end = trim(l:cms_start[(l:cms_end_idx + 2):])
    " Slice start string to before `%s` and trim whitespace.
    let l:cms_start = trim(l:cms_start[0:(l:cms_end_idx - 1)])
  endif

  let l:str = trim(a:str)

  " Strip comment string start from start of string.
  let l:str = substitute(l:str, '\v^\V' . escape(l:cms_start, '\'), '', '')
  " Strip comment string end from end of string.
  let l:str = substitute(l:str, '\V' . escape(l:cms_end, '\') . '\v$', '', '')

  " Trim whitespace from string.
  let l:str = trim(l:str)

  " Strip fold open marker from string.
  let l:fold_open = split(&foldmarker, ',')[0]
  let l:str = substitute(l:str, '\V' . escape(l:fold_open, '\') . '\v\d*', '', 'g')

  " Trim whitespace from string.
  return trim(l:str)
endfunction
