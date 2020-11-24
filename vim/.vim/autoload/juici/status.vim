function! juici#status#file_name() abort
  let l:filename = expand('%')
  if l:filename =~# '\VNERD_tree'
    return ''
  endif

  let l:modified = &modified ? ' +' : ''
  let l:filename = fnamemodify(l:filename, ':~:.')

  let l:winwidth = winwidth(0)
  if l:winwidth < 90 || strwidth(l:filename) > l:winwidth * 0.4
    let l:filename = l:winwidth < 70
          \ ? fnamemodify(l:filename, ':t')
          \ : pathshorten(l:filename)
  endif

  return l:filename . l:modified
endfunction

function! juici#status#file_encoding() abort
  " Only show file encoding if it's not 'utf-8'.
  return winwidth(0) < 80 || &fileencoding ==# 'utf-8' ? '' : &fileencoding
endfunction

function! juici#status#file_format() abort
  " Only show file format if it's not 'unix'.
  return winwidth(0) < 80 || &fileformat ==# 'unix' ? '' : &fileformat
endfunction

function! juici#status#file_type() abort
  return winwidth(0) < 70 ? '' : &filetype
endfunction

function! juici#status#diagnostics() abort
  let l:lint = ''

  if winwidth(0) >= 90 && exists('b:coc_diagnostic_info')
    let l:warnings = get(b:coc_diagnostic_info, 'warning', 0)
    let l:errors = get(b:coc_diagnostic_info, 'error', 0)

    let l:lint = ' ' . l:errors . '  ' . l:warnings
  endif

  return l:lint
endfunction

function! juici#status#lint_status() abort
  return winwidth(0) < 100 ? '' : get(g:, 'coc_status', '')
endfunction

function! juici#status#read_only() abort
  " Display a lock for readonly files, but only if they are modifiable.
  "
  " ie. exclude things like help and netrw.
  return &readonly && &modifiable ? '' : ''
endfunction

function! juici#status#line_info() abort
  return '%3p%% | %3l:%-2v'
endfunction

function! juici#status#git_branch() abort
  let l:branch = fugitive#head()
  return l:branch ==# '' ? '' : ' ' . l:branch
endfunction
