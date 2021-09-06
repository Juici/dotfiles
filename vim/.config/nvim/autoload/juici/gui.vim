let s:columns = 142
let s:lines = 40

let s:guifont_name = 'JetBrainsMono Nerd Font Mono'
let s:guifont_size = 10

function! juici#gui#set_size(...) abort
  let l:columns = get(a:, 1, s:columns)
  let l:lines = get(a:, 2, s:lines)

  execute 'set' 'columns=' . l:columns
  execute 'set' 'lines=' . l:lines
endfunction

function! juici#gui#set_font(...) abort
  let l:name = get(a:, 1, s:guifont_name)
  let l:size = get(a:, 2, s:guifont_size)

  let l:font = s:format_font(l:name, l:size)

  execute 'set' 'guifont=' . l:font
endfunction

function! s:format_font(name, size) abort
  let l:font = v:null

  if has('gui_running')
    if has('gui_gtk2') || has('gui_gtk3')
      let l:font = a:name . ' ' . a:size
    elseif has('gui_photon')
      let l:font = a:name . ':s' . a:size
    elseif has('gui_kde')
      let l:font = a:name . '/' . a:size . '/-1/50/0/0/0/1/0'
    elseif has('gui_win32')
      let l:font = substitute(a:name, ' ', '_', 'g') . ':h' . a:size . ':cDEFAULT'
    endif
  else
    let l:font = a:name . ':h' . a:size
  endif

  if l:font is v:null
    call juici#log#warn('Unrecognised gui for font format, using fallback style')

    let l:font = a:name . ':h' . a:size
  endif

  return escape(l:font, ' ')
endfunction
