" Echo warning.
function! juici#functions#EchoWarn(msg) abort
  try
    echohl WarningMsg
    echomsg a:msg
  finally
    echohl None
  endtry
endfunction

" Echo error.
function! juici#functions#EchoErr(msg) abort
  try
    echohl ErrorMsg
    echomsg a:msg
  finally
    echohl None
  endtry
endfunction

" Download and install vim-plug if not already installed.
let s:plug_path = g:vim_dir . '/autoload/plug.vim'
let s:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
function! juici#functions#PlugLoad() abort
  if !filereadable(s:plug_path)
    if executable('curl')
      echomsg 'Installing vim-plug at ' . s:plug_path

      call system('curl -fLo ' . shellescape(s:plug_path) . ' --create-dirs ' . s:plug_url)
      if v:shell_error
        call juici#functions#EchoErr('Error: Failed to install vim-plug')
      endif
    else
      call juici#functions#EchoErr('Error: Cannot install vim-plug, manual install required')
      exit
    endif
  endif
endfunction
