" Enable deleting words over insert mode entrance point.
if !has('patch-8.2.0590')
  inoremap <silent><expr> <C-w>
        \ col('.') == 1 ? "\<C-o>\"_dh"
        \ : "\<C-\>\<C-o>\"_db"
endif
" Bind <C-BS> to delete word backward.
map! <C-BS> <C-w>
map! <C-h> <C-w>

" Bind <C-Del> to delete word forward.
inoremap <silent><expr> <C-Del>
      \ col('.') == len(getline('.')) + 1 ? "\<C-\>\<C-o>v\"_d"
      \ : "\<C-o>\"_de"
