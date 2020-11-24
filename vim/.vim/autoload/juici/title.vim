" The threshold width for the working directory path before the directory names
" are shortened.
let s:threshold_pwd_width = 20
" The threshold width for the file path before the directory names are
" shortened.
let s:threshold_file_width = 20

" The vim program name, eg. 'nvim', 'vim'.
"
" Defaults to 'vim' if not present.
let s:prog = get(v:, 'progname', 'vim')

function! juici#title#title() abort
  let l:pwd = juici#util#pwd()
  let l:file = juici#util#file_path()

  " Remove '/' from the end of the PWD if not at root.
  if strlen(l:pwd) > 1 && l:pwd[-1:] ==# '/'
    let l:pwd = l:pwd[:-2]
  endif

  " Shorten directory names for PWD and file path if the strwidth is greater
  " than the threshold.
  let l:pwd = juici#util#shorten_dirs(l:pwd, s:threshold_pwd_width)
  let l:file = juici#util#shorten_dirs(l:file, s:threshold_file_width)

  let l:title = l:pwd . ' - ' . s:prog

  " If the file name is not empty than add to title.
  if strwidth(l:file) > 0
    let l:title .= ' (' . l:file . ')'
  endif

  return l:title
endfunction
