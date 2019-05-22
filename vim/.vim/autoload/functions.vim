" Download and install vim-plug if not already installed.
let s:plug_path = expand('<sfile>:p:h') . '/plug.vim'
let s:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
function! functions#PlugLoad() abort
  if !filereadable(s:plug_path)
    if executable('curl')
      echomsg 'Installing vim-plug at ' . s:plug_path

      call system('curl -fLo ' . shellescape(s:plug_path) . ' --create-dirs ' . s:plug_url)
      if v:shell_error
        echoerr 'Error: Failed to install vim-plug'
      endif
    else
      echoerr 'Error: Cannot install vim-plug, manual install required'
      exit
    endif
  endif
endfunction
