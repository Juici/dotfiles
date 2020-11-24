let s:middot = '·'
let s:raquo = '»'
let s:small_l = 'ℓ'

let s:lines_pad_len = 4   " The number of digits to pad lines number to.

" Get the set fold character.
function! juici#fold#fill_char() abort
  let l:fold_char = s:middot

  if exists('&fillchars')
    let l:fillchars = split(&fillchars, ',')

    " Reverse the list, since vim uses the value set last.
    for l:pair in reverse(l:fillchars)
      let l:split = split(l:pair, ':')

      " Look for `fold` entry.
      if len(l:split) == 2 && l:split[0] ==# 'fold'
        let l:fold_char = strcharpart(l:split[1], 0, 1)
        break
      endif
    endfor
  endif

  return l:fold_char
endfunction

" Override default `foldtext()`, which produces something like:
"
"   +---  2 lines: source $HOME/path/to/file/being/edited----------------------
"
" Instead returning:
"
"   »······[2ℓ]·· source $HOME/path/to/file/being/edited ······················
"
function! juici#fold#text() abort
  let l:fold_char = juici#fold#fill_char()
  let l:fold_len = v:foldend - v:foldstart + 1

  let l:lines_prefix = '['
  let l:lines_suffix = s:small_l . ']'
  let l:pad_len = s:lines_pad_len + strlen(l:lines_prefix) + strlen(l:lines_suffix)

  let l:lines = l:lines_prefix . l:fold_len . l:lines_suffix
  let l:lines = substitute(printf('%' . l:pad_len . 's', l:lines), ' ', l:fold_char, 'g')

  let l:first = s:cleanup_fold_text(getline(v:foldstart))
  "let l:dashes = substitute(v:folddashes, '-', l:fold_char, 'g')

  return s:raquo . l:fold_char . l:fold_char . l:lines . l:fold_char . l:fold_char . ' ' . l:first . ' '
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
