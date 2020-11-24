" Use Tab to trigger completion or go to next completion.
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>"
      \ : <SID>check_prev_space() ? "\<Tab>"
      \ : coc#refresh()
" Use Shift-Tab to go to previous completion.
inoremap <silent><expr> <S-Tab>
      \ pumvisible() ? "\<C-p>"
      \ : "\<S-Tab>"

" Use Ctrl-Space to trigger or accept completion.
if has('nvim')
  inoremap <silent><expr> <C-Space>
        \ pumvisible() ? "\<C-n>"
        \ : coc#refresh()
else
  inoremap <silent><expr> <C-@>
        \ pumvisible() ? "\<C-n>"
        \ : coc#refresh()
endif

" Check if the character before is a whitespace character.
function! s:check_prev_space() abort
  let l:col = col('.') - 1
  return !col || getline('.')[l:col - 1] =~# '\v\s'
endfunction
