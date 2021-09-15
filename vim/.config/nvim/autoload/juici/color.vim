" Custom group colours.
let s:group_colors = {}
let s:group_links = {}

function! s:h(group, style) abort
  execute 'highlight' a:group
    \ 'guifg='   has_key(a:style, 'fg')    ? a:style.fg.gui   : 'NONE'
    \ 'guibg='   has_key(a:style, 'bg')    ? a:style.bg.gui   : 'NONE'
    \ 'guisp='   has_key(a:style, 'sp')    ? a:style.sp.gui   : 'NONE'
    \ 'gui='     has_key(a:style, 'gui')   ? a:style.gui      : 'NONE'
    \ 'ctermfg=' has_key(a:style, 'fg')    ? a:style.fg.cterm : 'NONE'
    \ 'ctermbg=' has_key(a:style, 'bg')    ? a:style.bg.cterm : 'NONE'
    \ 'cterm='   has_key(a:style, 'cterm') ? a:style.cterm    : 'NONE'
endfunction

function! s:l(group, to) abort
  let [l:to, l:default] = a:to

  if l:default
    execute 'highlight' 'default' 'link' a:group l:to
  else
    execute 'highlight!' 'link' a:group l:to
  endif
endfunction

function! juici#color#set(group, style, ...) abort
  let l:extend = get(a:, 1, v:false)

  if l:extend
    let l:style = s:group_colors[a:group]

    for l:style_type in ['fg', 'bg', 'sp']
      if has_key(a:style, l:style_type)
        let l:default_style = has_key(l:highlight, l:style_type)
              \ ? l:style[l:style_type]
              \ : { 'gui': 'NONE', 'cterm': 'NONE' }
        let l:style[style_type] = extend(l:default_style, a:style[l:style_type])
      endif
    endfor

    if has_key(a:style, 'gui')
      let l:style.gui = a:style.gui
    endif
    if has_key(a:style, 'cterm')
      let l:style.cterm = a:style.cterm
    endif
  else
    let l:style = a:style
    let s:group_colors[a:group] = l:style
  endif

  call s:h(a:group, l:style)
endfunction

function! juici#color#link(group, to, ...) abort
  let l:default = get(a:, 1, v:false)
  let l:to = [a:to, l:default]

  if !l:default || !has_key(s:group_links, a:group)
    let s:group_links[a:group] = l:to
  endif

  call s:l(a:group, l:to)
endfunction

" Refresh custom colours, such as when the colour scheme changes.
function! juici#color#refresh() abort
  for [l:group, l:style] in items(s:group_colors)
    call s:h(l:group, l:style)
  endfor
  for [l:group, l:to] in items(s:group_links)
    call s:l(l:group, l:to)
  endfor
endfunction
