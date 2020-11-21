let s:prog = get(v:, 'progname', 'vim')

function! juici#title#title() abort
  return s:prog
endfunction
