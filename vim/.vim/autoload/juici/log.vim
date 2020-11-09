" Log info message.
function! juici#log#info(msg) abort
  try
    echohl None
    echomsg a:msg
  endtry
endfunction

" Log warning message.
function! juici#log#warn(msg) abort
  try
    echohl WarningMsg
    echomsg a:msg
  finally
    echohl None
  endtry
endfunction

" Log error message.
function! juici#log#error(msg) abort
  try
    echohl ErrorMsg
    echomsg a:msg
  finally
    echohl None
  endtry
endfunction
