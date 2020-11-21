" Enable deleting words over insert mode entrance point.
if has('patch-8.2.0590')
  set backspace+=nostop
else
  inoremap <silent><expr> <C-w> col('.') == len(getline('.')) + 1 ? "\<C-o>vb\"_d" : "\<C-o>\"_db"
endif

" Bind Ctrl-Backspace to delete word.
noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>
