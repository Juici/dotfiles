" Make sure lightline is loaded.
try
  call lightline#init()
catch /E117/
  call juici#log#warn('Lightline is not loaded')
  finish
endtry

if !has('autocmd')
  finish
endif

augroup juici_lightline
  autocmd!

  " Update lightline when CoC status changes.
  autocmd User CocStatusChange,CocDignosticChange silent call lightline#update()

  " Update lightline after a period of idle.
  autocmd CursorHold,CursorHoldI * silent call lightline#update()
augroup END

function! s:lightline_update() abort
  " Check we aren't in command mode, since there are issues with lightline
  " when `inccommand=split`.
  if mode() !~# '\V\_^c'
    call lightline#update()
  endif
endfunction

" Periodically update the status line.
call juici#timer#add('lightline', {-> s:lightline_update() })
