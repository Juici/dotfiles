if has('termguicolors')
  if !g:linux_console
    " Use guifg/guibg instead of ctermfg/ctermbg in terminal.
    set termguicolors
  endif

  " Not needed for xterm-256color, but it is needed inside tmux.
  if $TERM ==# 'tmux-256color'
    let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  endif
endif

if !has('nvim')
  " Make S-Up etc work inside tmux.
  " See: https://superuser.com/a/402084/322531
  if $TERM =~# '\Vtmux'
    execute 'set' "<xUp>=\<Esc>[1;*A"
    execute 'set' "<xDown>=\<Esc>[1;*B"
    execute 'set' "<xRight>=\<Esc>[1;*C"
    execute 'set' "<xLeft>=\<Esc>[1;*D"
  endif
endif

if $TERM =~# '\V256color'
  " Disable background color erase.
  set t_ut=
endif
