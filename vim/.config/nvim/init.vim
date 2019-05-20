" Ensure vim-plug is installed.
call functions#PlugLoad()

" Plugins directory for vim-plug.
let s:plugdir = expand('<sfile>:p:h') . '/plugged'

" Load vim-plug.
call plug#begin(s:plugdir)

" General {{{

    set autoread    " Detect when a file is changed.

    set history=1000    " Change history to 1000.
    set textwidth=80    " Set line width.

    if has('nvim')
        " Show results of substitution as they're happening, but don't open a
        " split.
        set inccommand=nosplit
    endif

    set backspace=indent,eol,start " Sane backspace.
    set clipboard=unnamed

    if has('mouse')
        set mouse=a
    endif

    " Searching
    set ignorecase      " Case insensitive searching.
    set smartcase       " Case sensitive, if expression contains uppercase.
    set hlsearch        " Highlight search results.
    set incsearch       " Set incremental search.
    set nolazyredraw    " Don't redraw whilst executing macros.

    set magic   " Set magic on, for regex.

    " Error bells.
    set noerrorbells
    set visualbell
    set t_vb=
    set tm=500

" }}}

" Appearance {{{

    set number          " Show line numbers.
    set wrap            " Turn on line wrapping.
    set autoindent      " Automatically set indent of new line.
    set ttyfast         " Faster redrawing.
    set diffopt+=vertical,iwhite,internal,algorithm:patience,hiddenoff
    set laststatus=2    " Show status line all the time.
    set so=7            " Cursor 7 lines when moving vertically.
    set wildmenu        " Enhanced command line completion.
    "set wildmode=list:longest   " Complete files like a shell. 
    set hidden          " Current buffer can be put in the background.
    set showcmd         " Show incomplete commands.
    set noshowmode      " Don't show the mode.
    set shell=$SHELL
    set cmdheight=1     " Set command bar height.
    set title           " Set terminal title.
    set showmatch       " Show matching braces.

    " Tab control.
    set expandtab
    set smarttab
    set tabstop=4
    set softtabstop=4
    set shiftwidth=4
    set shiftround

    " Code folding.
    set foldmethod=syntax   " Fold based on indent.
    set foldlevelstart=99
    set foldnestmax=10      " Deepest fold is 10 levels.
    set nofoldenable        " Don't fold by default.
    set foldlevel=1

    " Toggle invisible characters.
    set nolist
    set listchars=tab:→\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
    set showbreak=↪

    " Tell vim the terminal supports 256 colours.
    set t_Co=256
    " Switch cursor based in mode.
    set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50

    if &term =~ '256color'
        " Disable background colour erase.
        set t_ut=
    endif

    " Enable 24 bit true colour if supported.
    if has('termguicolors')
        if !has('nvim')
            let &t_8f = '\<Esc>[38;2;%lu;%lu;%lum'
            let &t_8b = '\<Esc>[42;2;%lu;%lu;%lum'
        endif
        set termguicolors
    endif

	" Highlight conflicts.
    match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
" }}}

call plug#end()

" Final Setup {{{

    " TODO: Colourscheme.
    
    syntax on
    filetype plugin indent on

" }}}

" vim:set foldmethod=marker foldlevel=0
