function! s:Config()
  if has_key(get(g:, 'LanguageClient_serverCommands', {}), &filetype)
    " gd -- go to definition
    nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>

    " K -- lookup keyword
    nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<CR>

    if exists('+signcolumn')
      setlocal signcolumn=yes
    endif
  endif
endfunction

augroup juici_languageclient_autocmds
  autocmd!
  autocmd FileType * call s:Config()
augroup END
