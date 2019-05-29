function! juici#lightline#FileName() abort
  let l:filename = winwidth(0) > 70 ? expand('%') : expand('%:t')
  if l:filename =~# 'NERD_tree'
    return ''
  endif
  let l:modified = &modified ? ' +' : ''
  return fnamemodify(l:filename, ':~:.') . l:modified
endfunction

function! juici#lightline#FileEncoding() abort
  " Only show file encoding if it's not 'utf-8'.
  return &fileencoding ==# 'utf-8' ? '' : &fileencoding
endfunction

function! juici#lightline#FileFormat() abort
  " Only show file format if it's not 'unix'.
  let l:format = &fileformat ==# 'unix' ? '' : &fileformat
  " Don't show format if in narrow terminal.
  return winwidth(0) > 70 ? format : ''
endfunction

function! juici#lightline#FileType() abort
  " TODO: Use vim-devicons here?
  return winwidth(0) > 70 ? &filetype : ''
endfunction

function! juici#lightline#Linter() abort
  " TODO: Linter hooks.
  return ''
endfunction

function! juici#lightline#LinterWarnings() abort
  " TODO: Linter hooks.
  return ''
endfunction

function! juici#lightline#LinterErrors() abort
  " TODO: Linter hooks.
  return ''
endfunction

function! juici#lightline#LinterOk() abort
  " TODO: Linter hooks.
  return ''
endfunction

function! juici#lightline#ReadOnly() abort
  " Display a lock for readonly files.
  return &ft !~# 'help' && &readonly ? '' : ''
endfunction

function! juici#lightline#GitBranch() abort
  if exists('*fugitive#head')
    " Use vim-fugitive to get branch name.
    let l:branch = fugitive#head()
  else
    " Fallback to use 'git rev-parse' to get branch name.
    let l:branch = system('git rev-parse --abbrev-ref HEAD 2>/dev/null')[0:-2]
  endif
  return l:branch !=# '' ? ' ' . l:branch : ''
endfunction
