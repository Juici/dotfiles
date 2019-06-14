" Appearance {{{

  " Initial dimensions.
  set columns=132
  set lines=40

  " Font settings.
  let s:guifont_name = 'Fira Code'
  let s:guifont_size = 10

  let s:guifont = s:guifont_name . ':h' . s:guifont_size

  execute 'set' 'guifont=' . escape(s:guifont, ' ')

" }}}
