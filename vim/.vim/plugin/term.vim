if has('termguicolors')
  " Not needed for xterm-256color, but it is needed inside tmux.
  if &term =~# 'tmux-256color'
    let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  endif
endif

if !has('nvim')
  " Make S-Up etc work inside tmux.
  " See: https://superuser.com/a/402084/322531
  if &term =~# 'tmux-256color'
    execute 'set' "<xUp>=\<Esc>[1;*A"
    execute 'set' "<xDown>=\<Esc>[1;*B"
    execute 'set' "<xRight>=\<Esc>[1;*C"
    execute 'set' "<xLeft>=\<Esc>[1;*D"
  endif
endif

if &term =~# '256color'
  " Disable background color erase.
  set t_ut=
endif
