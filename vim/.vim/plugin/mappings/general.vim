" Enable deleting words over insert mode entrance point.
if !has('patch-8.2.0590')
  inoremap <silent><expr> <C-w>
        \ col('.') == 1 ? "\<C-o>\"_dh"
        \ : col('.') == len(getline('.')) + 1 ? "\<C-o>vb\"_d"
        \ : "\<C-o>\"_db"
endif

" Bind Ctrl-Backspace to delete word backward.
map! <C-BS> <C-w>
map! <C-h> <C-w>

" Bind Ctrl-Delete to delete word forward.
inoremap <silent><expr> <C-Del>
      \ col('.') == len(getline('.')) + 1 ? "\<C-o>l\<C-o>\"_dh"
      \ : "\<C-o>\"_de"
