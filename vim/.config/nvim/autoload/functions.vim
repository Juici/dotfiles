" Download and install vim-plug if not already installed.
let s:plugpath = expand('<sfile>:p:h') . '/plug.vim'    " Path to plug.vim file.
function! functions#PlugLoad()
    if !filereadable(s:plugpath)
        if executable('curl')
            echom 'Installing vim-plug at ' . s:plugpath

            let plugurl = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
            call system('curl -fLo ' . shellescape(s:plugpath) . ' --create-dirs ' . plugurl)
            if v:shell_error
                echom 'Error downloading vim-plug. Please install it manually.\n'
                exit
            endif
        else
            echom 'vim-plug not installed. Plesae install it manually or install curl.\n'
            exit
        endif
    endif
endfunction
