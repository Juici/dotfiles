" Bind <C-BS> to delete word backward.
map! <C-BS> <C-w>
map! <C-h> <C-w>

" Bind <C-Del> to delete word forward.
inoremap <silent><expr> <C-Del>
      \ col('.') == len(getline('.')) + 1 ? "\<C-\>\<C-o>v\"_d"
      \ : getline('.')[(col('.') - 1):col('.')] =~# '\v^\S\s$' ? "\<C-o>\"_x"
      \ : getline('.')[col('.'):] =~# '\v^\s+$' ? "\<C-o>v$h\"_d"
      \ : "\<C-o>\"_de"

" Use <Up> and <Down> in tab completion in command mode.
cmap <Up> <C-p>
cmap <Down> <C-n>

" Use <C-a> and <C-e> to navigate to start or end of line in command mode.
cmap <C-a> <Home>
cmap <C-e> <End>
