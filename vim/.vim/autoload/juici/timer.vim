let s:timer_interval = 1000       " 1 second timer interval.
let s:disable_timeout = 30000     " 30 second idle timeout.

let g:juici#timer#_inited = v:false
let g:juici#timer#_id = v:null
let g:juici#timer#_timeout_id = v:null
let g:juici#timer#_callbacks = {}

"
" Internal functions.
"

function! s:run_callbacks() abort
  for [l:id, l:Callback] in items(g:juici#timer#_callbacks)
    " If the callback is a function name, get the funcref.
    if type(l:Callback) == v:t_string
      let l:Callback = function(l:Callback)
    endif

    call l:Callback()
  endfor
endfunction

function! s:init_timer() abort
  " Initialise timer if not already initialised.
  if has('timers') && !g:juici#timer#_inited
    let g:juici#timer#_inited = v:true

    " Enable the timer.
    call s:enable_timer()
  endif
endfunction

function! s:start_timeout() abort
  if has('timers') && g:juici#timer#_timeout_id is v:null
    " Set a timeout before timer is disabled if there is no activity.
    let g:juici#timer#_timeout_id = timer_start(s:disable_timeout, {-> s:disable_timer() }, { 'repeat': 0 })
  endif
endfunction

function! s:cancel_timeout() abort
  if has('timers') && g:juici#timer#_timeout_id isnot v:null
    " Stop the timeout.
    call timer_stop(g:juici#timer#_timeout_id)
    let g:juici#timer#_timeout_id = v:null
  endif
endfunction

function! s:enable_timer() abort
  if has('timers') && g:juici#timer#_id is v:null
    let g:juici#timer#_id = timer_start(s:timer_interval, {-> s:run_callbacks() }, { 'repeat': -1 })

    " Immediatly start timeout.
    call s:start_timeout()

    augroup juici_timer
      autocmd!
      autocmd CursorHold,CursorHoldI,FocusLost * silent call s:start_timeout()
      autocmd CursorMoved,CursorMovedI,FocusGained * silent call s:cancel_timeout()
    augroup END
  endif
endfunction

function! s:disable_timer() abort
  call s:cancel_timeout()

  if has('timers') && g:juici#timer#_id isnot v:null
    " Stop the timer.
    call timer_stop(g:juici#timer#_id)
    let g:juici#timer#_id = v:null

    augroup juici_timer
      autocmd!
      autocmd CursorMoved,CursorMovedI,FocusGained * ++once silent call s:enable_timer()
    augroup END
  endif
endfunction

"
" API functions.
"

function! juici#timer#add(id, callback) abort
  let l:cb_type = type(a:callback)

  if l:cb_type == v:t_func || l:cb_type == v:t_string
    let g:juici#timer#_callbacks[a:id] = a:callback

    call s:init_timer()
  else
    throw 'Timer callback must be a funcref or string name of function: ' . a:id
  endif
endfunction

function! juici#timer#remove(id) abort
  if has_key(g:juici#timer#_callbacks, a:id)
    call remove(g:juici#timer#_callbacks, a:id)
  endif
endfunction
