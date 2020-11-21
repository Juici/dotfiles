" Enable deleting words over insert mode entrance point.
if !has('patch-8.2.0590')
  inoremap <silent><expr> <C-w> col('.') == len(getline('.')) + 1 ? "\<C-o>vb\"_d" : "\<C-o>\"_db"
endif

" Bind Ctrl-Backspace to delete word.
map! <C-BS> <C-w>
map! <C-h> <C-w>
