" Download and install vim-plug if not already installed.
"function! juici#util#plug_load() abort
"  let l:plug_path = g:vim_dir . '/autoload/plug.vim'
"  let l:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
"
"  if !filereadable(l:plug_path)
"    if executable('curl')
"      call juici#log#info('Installing vim-plug at ' . l:plug_path)
"
"      call system('curl -fLo ' . shellescape(l:plug_path) . ' --create-dirs ' . l:plug_url)
"      if v:shell_error
"        call juici#log#error('Error: Failed to install vim-plug')
"      endif
"    else
"      call juici#log#error('Error: Cannot install vim-plug, manual install required')
"      exit
"    endif
"  endif
"endfunction

function! juici#util#mkdirp(dir) abort
  " Expand and resolve directory path.
  let l:dir = fnamemodify(resolve(expand(a:dir)), ':p')

  " Recursively ensure parent directory exists.
  let l:parent_dir = fnamemodify(l:dir, ':h')
  if !isdirectory(l:parent_dir)
    call juici#util#mkdirp(l:parent_dir)
  endif

  " Create directory.
  call mkdir(l:dir)
endfunction
