" Bind <C-Del> to delete word forward.
inoremap <silent><expr> <C-Del>
      \ col('.') == len(getline('.')) + 1 ? "\<C-\>\<C-o>v\"_d"
      \ : getline('.')[(col('.') - 1):col('.')] =~# '\v^\S\s$' ? "\<C-o>\"_x"
      \ : getline('.')[col('.'):] =~# '\v^\s+$' ? "\<C-o>v$h\"_d"
      \ : "\<C-o>\"_de"
