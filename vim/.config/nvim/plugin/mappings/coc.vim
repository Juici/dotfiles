" Use <Tab> to trigger completion or go to next completion.
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>"
      \ : <SID>check_prev_space() ? "\<Tab>"
      \ : coc#refresh()
" Use <S-Tab> to go to previous completion.
inoremap <silent><expr> <S-Tab>
      \ pumvisible() ? "\<C-p>"
      \ : "\<S-Tab>"

" Use <C-Space> to trigger or accept completion.
if has('nvim')
  inoremap <silent><expr> <C-Space>
        \ pumvisible() ? "\<C-n>"
        \ : coc#refresh()
else
  inoremap <silent><expr> <C-@>
        \ pumvisible() ? "\<C-n>"
        \ : coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Goto code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use <S-k> and <S-F2> to show documentation.
nnoremap <silent> K :call <SID>show_documentation()<CR>
nnoremap <silent> <F14> :call <SID>show_documentation()<CR>

" Use <Leader>rn and <Leader><C-r> to rename variables/functions.
nmap <Leader>rn <Plug>(coc-rename)
nmap <Leader><C-r> <Plug>(coc-rename)

if has('nvim-0.4.0') || has('patch-8.2.0750')
  " Remap <C-f> and <C-b> for scroll float windows/popups.
  nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1, 3) : "\<C-f>"
  nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0, 3) : "\<C-b>"
  inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<C-r>=coc#float#scroll(1, 3)\<CR>" : "\<Right>"
  inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<C-r>=coc#float#scroll(0, 3)\<CR>" : "\<Left>"

  " Neovim only mapping for visual mode scroll.
  if has('nvim')
    vnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#nvim_scroll(1, 3) : "\<C-f>"
    vnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#nvim_scroll(0, 3) : "\<C-b>"
  endif
endif

"
" Internal utility functions.
"

" Check if the character before is a whitespace character.
function! s:check_prev_space() abort
  let l:col = col('.') - 1
  return !col || getline('.')[l:col - 1] =~# '\v\s'
endfunction

function! s:show_documentation() abort
  if coc#rpc#ready()
    silent call CocActionAsync('doHover')
  endif
endfunction
