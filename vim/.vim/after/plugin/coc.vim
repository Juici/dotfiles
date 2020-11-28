" Make sure CoC is loaded.
if !get(g:, 'juici#_loaded_coc', v:false)
  finish
endif

augroup juici_coc
  " Highlight the symbol and its references when holding the cursor.
  autocmd CursorHold,CursorHoldI * silent call CocActionAsync('highlight')

  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder silent call CocActionAsync('showSignatureHelp')
augroup END
