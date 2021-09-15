" Make directories recursively along the path.
function! juici#util#mkdirp(dir) abort
  " Expand and resolve directory path.
  let l:dir = fnamemodify(resolve(expand(a:dir)), ':p')

  " Recursively ensure parent directory exists.
  let l:parent_dir = fnamemodify(l:dir, ':h')
  if !isdirectory(l:parent_dir)
    call juici#util#mkdirp(l:parent_dir)
  endif

  " Create directory.
  call mkdir(l:dir)
endfunction

" Get the path to the current working directory.
function! juici#util#pwd() abort
  " Get the working directory from the $PWD environment variable.
  "
  " Prefer to use $PWD since it preserves symlinks, often resulting in a path
  " more presentable to the user.
  let l:pwd = getenv('PWD')
  " If the $PWD environment variable is not set fallback to getcwd().
  if l:pwd is v:null
    let l:pwd = getcwd()
  endif

  " Resolve the path with tilde '~' notation.
  let l:pwd = fnamemodify(l:pwd, ':p:~')

  return l:pwd
endfunction

" Get the path to the current open file/directory.
function! juici#util#file_path() abort
  " Get the path to the open file/directory.
  if &filetype ==# 'netrw' && exists('b:netrw_curdir')
    " The directory open in the current buffer.
    "
    " Prefer this to expand('%') when in netrw due to inconsistencies of the '%'
    " register when in netrw.
    let l:file = b:netrw_curdir
  else
    " The file open in the current buffer.
    let l:file = expand('%')
  endif

  " Resolve the file name relative to working directory and fallback to tilde
  " '~' notation if the not inside working directory path.
  let l:file = fnamemodify(l:file, ':p:~:.')

  return l:file
endfunction

" Get the path with leading directory names shortened.
"
" eg.
"   '~/.vim/autoload/juici/settings' -> '~/.v/a/j/settings'
"   '~/.vim/autoload/juici/settings/' -> '~/.v/a/j/settings/'
"   '~user/.vim/autoload/juici/settings/' -> '~user/.v/a/j/settings/'
function! juici#util#shorten_dirs(path, ...) abort
  " Trim leading and trailing whitespace.
  let l:path = trim(a:path)

  " Gets the threshold path length or default to 0 to always shorten.
  let l:threshold = get(a:, 1, 0)

  " If the strwidth of the path is greater than the threshold then shorten the
  " path.
  if strwidth(l:path) > l:threshold
    " Shorten leading directory names to 1 character or 2 characters if hidden
    " directory (eg. '.dirname').
    "
    " Repeated instances of separators '/' are shortened to single characters.
    " eg. 'the/dir//path/being///shortened' -> 't/d/p/b/s'
    "let l:path = substitute(l:path, '\m\(\_^\|/\@<=\)\(\~[^/]*\|\.\?[^/]\)[^/]*/\+\_$\@!', '\2/', 'g')
    let l:path = pathshorten(l:path)
  endif

  return l:path
endfunction
