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
