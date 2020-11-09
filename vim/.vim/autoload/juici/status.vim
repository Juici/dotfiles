function! juici#status#file_name() abort
  let l:filename = winwidth(0) > 70 ? expand('%') : expand('%:t')
  if l:filename =~# 'NERD_tree'
    return ''
  endif
  let l:modified = &modified ? ' +' : ''
  return fnamemodify(l:filename, ':~:.') . l:modified
endfunction

function! juici#status#file_encoding() abort
  " Only show file encoding if it's not 'utf-8'.
  return &fileencoding ==# 'utf-8' ? '' : &fileencoding
endfunction

function! juici#status#file_format() abort
  " Only show file format if it's not 'unix'.
  let l:format = &fileformat ==# 'unix' ? '' : &fileformat
  " Don't show format if in narrow terminal.
  return winwidth(0) > 70 ? format : ''
endfunction

function! juici#status#file_type() abort
  " TODO: Use vim-devicons here?
  return winwidth(0) > 70 ? &filetype : ''
endfunction

function! juici#status#linter() abort
  " TODO: Linter hooks.
  return ''
endfunction

function! juici#status#linter_warnings() abort
  " TODO: Linter hooks.
  return ''
endfunction

function! juici#status#linter_errors() abort
  " TODO: Linter hooks.
  return ''
endfunction

function! juici#status#linter_ok() abort
  " TODO: Linter hooks.
  return ''
endfunction

function! juici#status#read_only() abort
  " Display a lock for readonly files.
  return &ft !~# 'help' && &readonly ? '' : ''
endfunction

function! juici#status#line_info() abort
  return '%3p%% | %3l:%-2v'
endfunction

function! juici#status#git_branch() abort
  if exists('*fugitive#head')
    " Use vim-fugitive to get branch name.
    let l:branch = fugitive#head()
  elseif executable('git')
    " Fallback to use 'git rev-parse' to get branch name.
    let l:branch = system('git rev-parse --abbrev-ref HEAD 2>/dev/null')[0:-2]
  else
    " Git executable not found in path.
    let l:branch = ''
  endif
  return l:branch !=# '' ? ' ' . l:branch : ''
endfunction
