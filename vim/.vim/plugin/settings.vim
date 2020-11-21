scriptencoding utf-8

" Variables {{{

  let s:is_sudo = exists('$SUDO_USER')  " In sudo, but not root user.
  let s:tmp_dir = g:vim_dir . '/tmp'

" }}}

" External Programs {{{

  " Use ripgrep as default grep program.
  if executable('rg')
    set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
  endif

" }}}

" General {{{

  set autoread                  " Detect when a file is changed externally.
  set history=1000              " Set history size to 1000.
  set modelines=5               " Scan 5 lines looking for modeline.

  if has('mouse')
    set mouse=a                 " Enable mouse support.
  endif

  if s:is_sudo
    " Don't create root-owned files.
    set nobackup
    set nowritebackup
  else
    " Keep backup files out of the way.
    execute 'set' 'backupdir=' . s:tmp_dir . '/backup'
    set backupdir+=.
  endif

  if s:is_sudo
    " Don't create root-owned files.
    set noswapfile
  else
    " Keep swap files out of the way.
    execute 'set' 'directory=' . s:tmp_dir . '/swap'
    set directory+=.
  endif

  if exists('&belloff')
    set belloff=all             " Never ring the bell, for any reason.
  endif
  set visualbell t_vb=          " Stop beep for non-error bells.

  if exists('&inccommand')
    set inccommand=split        " Live preview of substitution (:s) results.
  endif

  set hidden                    " Allow buffers with unsaved changes to be 
                                "   hidden.
  set switchbuf=usetab          " Try to reuse windows/tabs when switching
                                "   buffers.

  if exists('&swapsync')
    set swapsync=               " Let OS sync swapfiles lazily.
  endif

  if has('persistant_undo')
    if s:is_sudo
      " Don't create root-owned files.
      set noundofile
    else
      " Keep undo files out of the way.
      execute 'set' 'undodir=' . s:tmp_dir . '/undo'
      set undodir+=.
      " Actually use undo files.
      set undofile
    endif
  endif

  set updatecount=80            " Update swapfiles every 80 typed characters.
  set updatetime=2000           " CursorHold interval.

  if has('viminfo')
    let s:viminfo = 'viminfo'   " Vim.
  elseif has('shada')
    let s:viminfo = 'shada'     " Neovim.
  endif

  if exists('s:viminfo')
    if s:is_sudo
      " Don't create root-owned files.
      execute 'set' s:viminfo . '='
    else
      " Defaults:
      "   Neovim: !,'100,<50,s10,h
      "   Vim:    '100,<50,s10,h
      "
      " - ! save/restore global variables (only all-uppercase variables)
      " - '100 save/restore marks from last 100 files
      " - <50 save/restore 50 lines from each register
      " - s10 max item size 10KB
      " - h do not save/restore 'hlsearch' setting
      "
      " Our overrides:
      " - '0 store marks for 0 files
      " - <0 don't save registers
      " - f0 don't store file marks
      " - n: store in ~/.vim/tmp

      let s:viminfo_file = s:tmp_dir . '/' . s:viminfo

      execute 'set' s:viminfo . "='0,<0,f0,n" . s:viminfo_file

      if !empty(glob(s:viminfo_file))
        if !filereadable(s:viminfo_file)
          call juici#log#warn('Warning: ' . s:viminfo
                \ . ' file exists but is not readable: ' . s:viminfo_file)
        endif
      endif
    endif
  endif

  if has('mksession')
    " Override ~/.vim/view default.
    execute 'set' 'viewdir=' . s:tmp_dir . '/view'
    " Save/Restore just these options (with `:{mk,load}view`).
    set viewoptions=cursor,folds
  endif

  set wildcharm=<C-z>           " Substitute for 'wildchar' (<Tab>) in macros.

  if has('wildignore')
    set wildignore+=*.o         " Patterns to ignore during file navigation.
  endif

  if has('wildmenu')
    set wildmenu                " Show options as list when tab completing, etc.
  endif
  set wildmode=longest:full,full    " Shell-like autocompletion to unambiguous
                                    "   portion.

  " Shell to use for `!`, `:!`, `system()`, etc.
  if exists('$SHELL')
    " Use the $SHELL environment variable if it exists.
    set shell=$SHELL
  elseif executable('zsh')
    " Use zsh if it exists.
    set shell=zsh
  elseif executable('bash')
    " Fallback to bash.
    set shell=bash
  else
    " Use sh if all else fails.
    set shell=sh
  endif

  set ttyfast                   " Faster redrawing.

  if has('windows')
    set splitbelow              " Open horizontal splits below current window.
  endif
  if has('vertsplit')
    set splitright              " Open vertical splits right of current window.
  endif

" }}}

" Editing {{{

  set expandtab                 " Use spaces instead of tabs.
  set smarttab                  " <Tab>/<BS> indent/dedent leading whitespace.
  set shiftround                " Always indent by a multiple of 'shiftwidth'.
  set shiftwidth=4              " Spaces per tab (when shifting).
  set tabstop=4                 " Spaces per tab.
  if v:progname !=# 'vi'
    set softtabstop=-1          " Use 'shiftwidth' for <Tab>/<BS> at the end of
                                "   a line.
  endif
  set autoindent                " Maintain indent of current line.

  set backspace=indent,start,eol    " Unrestricted backspacing in insert mode.
  set whichwrap=b,h,l,s,<,>,[,],~   " Allow <BS>/h/l/<Left>/<Right>/<Space> to
                                    "   cross line boundaries.

  set textwidth=80              " Hard wrap at 80 columns.

  set formatoptions+=n          " Smart auto-indenting inside numbered lists.
  if v:version > 703 || v:version == 703 && has('patch-5.4.1')
    set formatoptions+=j        " Remove comment leader when joining comment
                                "   lines.
  endif

  if has('virtualedit')
    set virtualedit=block       " Allow cursor to move where there is no text
                                "   when in visual block mode.
  endif

" }}}

" Appearance {{{

  set cursorline                " Highlight the current line.
  set number                    " Show line numbers in the gutter.
  set showmatch                 " Show matching braces.

  set scrolloff=3               " Start scrolling 3 lines before edge of
                                "   viewport.
  set sidescrolloff=3           " Same as 'scrolloff', but for columns.

  if has('linebreak')
    set linebreak               " Wrap long lines at characters in 'breakat'.
  endif

  set list                      " Show whitespace.
  set listchars=nbsp:⦸          " CIRCLED REVERSE SOLIDUS (U+29B8, UTF-8: E2 A6 B8)
  set listchars+=tab:▷┅         " WHITE RIGHT-POINTING TRIANGLE (U+25B7, UTF-8: E2 96 B7)
                                "   + BOX DRAWINGS HEAVY TRIPLE DASH HORIZONTAL (U+2505, UTF-8: E2 94 85)
  set listchars+=extends:»      " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00BB, UTF-8: C2 BB)
  set listchars+=precedes:«     " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00AB, UTF-8: C2 AB)
  set listchars+=trail:•        " BULLET (U+2022, UTF-8: E2 80 A2)

  set shortmess+=A              " Ignore annoying swapfile messages.
  set shortmess+=I              " No splash screen.
  set shortmess+=O              " File-read message overwrites previous.
  set shortmess+=T              " Truncate non-file messages in middle.
  set shortmess+=W              " Don't echo '[w]'/'[written]' when writing.
  set shortmess+=a              " Use abbreviations in messages,
                                "   eg. '[RO]' instead of '[readonly]'.
  if has('patch-7.4.314')
    set shortmess+=c            " Completion messages.
  endif
  set shortmess+=o              " Overwrite file-written messages.
  set shortmess+=t              " Truncate file messages at start.

  set diffopt+=foldcolumn:0     " Don't show fold in diff view.

  if has('folding')
    if has('windows')
      set fillchars=diff:∙      " BULLET OPERATOR (U+2219, UTF-8: E2 88 99)
      set fillchars+=fold:·     " MIDDLE DOT (U+00B7, UTF-8: C2 B7)
      set fillchars+=vert:┃     " BOX DRAWINGS HEAVY VERTICAL (U+2503, UTF-8: E2 94 83)
    endif

    if has('nvim-0.3.1')
      set fillchars+=eob:\      " Suppress ~ at EndOfBuffer.
    endif


    set foldmethod=marker       " Fold based on markers.
    set foldcolumn=1            " Fold column size.
    set foldtext=juici#fold#fold_text()
  endif

  " Switch cursor when in different modes.
  set guicursor=n-v-c:blinkon0-block
  set guicursor+=i-ci-ve:blinkon0-ver25
  set guicursor+=r-cr:blinkon0-hor20
  set guicursor+=o:blinkon0-hor50

  " Attempt to use xterm escape sequences to change cursor shape for vim.
  if !has('nvim')
    let &t_SI = "\<Esc>[6 q"
    let &t_SR = "\<Esc>[4 q"
    let &t_EI = "\<Esc>[2 q"

    " Fix lagging cursor shape when waiting for escape sequence.
    set ttimeoutlen=10
  endif

  " Settings for GVim.
  if has('gui_running')
    " Set default size.
    set columns=132
    set lines=40

    set guioptions-=T           " Don't show toolbar.
    set guioptions-=L           " Don't show left scrollbar.
    set guioptions-=l
    set guioptions-=R           " Don't show right scrollbar.
    set guioptions-=r
    set guioptions-=b           " Don't show bottom scrollbar.

    let s:guifont_name = 'JetBrainsMono Nerd Font Mono'
    let s:guifont_size = 10

    " Set 's:guifont_name' correctly.
    if has('gui_gtk2') || has('gui_gtk3')
      let s:guifont = s:guifont_name . ' ' . s:guifont_size
    elseif has('gui_photon')
      let s:guifont = s:guifont_name . ':s' . s:guifont_size
    elseif has('gui_kde')
      let s:guifont = s:guifont_name . '/' . s:guifont_size . '/-1/50/0/0/0/1/0'
    elseif has('gui_win32')
      let s:guifont = substitute(s:guifont_name, ' ', '_', 'g') . ':h'
            \ . s:guifont_size . ':cDEFAULT'
    endif

    " Set 'guifont' if 's:guifont' has been set.
    if exists('s:guifont')
      execute 'set' 'guifont=' . escape(s:guifont, ' ')
    endif
  endif

  set laststatus=2              " Always show status line.
  set cmdheight=1               " Set command bar height.

  set lazyredraw                " Don't bother updating screen during macro
                                "   playback.

  if has('termguicolors')
    set termguicolors           " Use guifg/guibg instead of ctermfg/ctermbg in
                                "   terminal.
  endif

" }}}
