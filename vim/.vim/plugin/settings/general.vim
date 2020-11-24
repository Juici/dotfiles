set autoread            " Detect when a file is modified externally.
set modelines=5         " Scan 5 lines looking for a modeline.
set history=1000        " Set history size to 1000.

set hidden              " Allow buffers with unsaved changes to be hidden.
set switchbuf=usetab    " Try to reuse windows/tabs when switching buffers.

" Enable mouse support.
if has('mouse')
  set mouse=a
endif

" Faster redrawing.
if exists('&ttyfast')
  set ttyfast
endif

" Never ring bell, for any reason.
if exists('&belloff')
  set belloff=all
endif
" Stop beep for non-error bells.
set visualbell t_vb=

" Enable live preview of substitution results.
if exists('&inccommand')
  set inccommand=split
endif

"
" Shell.
"

" Set the shell to use for `!`, `:!`, `system()`, etc.
if exists('$SHELL')
  " Use the $SHELL environment variable if it is present.
  set shell=$SHELL
elseif executable('zsh')
  " Use zsh if it can be found.
  set shell=zsh
elseif executable('bash')
  " Fallback to bash.
  set shell=bash
else
  " If all else fails fallback to sh.
  set shell=sh
endif

"
" Wild menu.
"

" Set patterns to ignore during when expanding files.
if has('wildignore')
  set wildignore+=*.o
endif

" Show options as a menu list when tab completing, etc.
if has('wildmenu')
  set wildmenu
endif

" Shell-like autocompletion to unambiguous portion.
set wildmode=longest:full,full

" Substitute binding for 'wildchar' (<Tab>) when in macros.
set wildcharm=<C-z>

"
" Splits.
"

" Open horizontal splits below current window.
if has('windows')
  set splitbelow
endif

" Open vertical splits right of current window.
if has('vertsplit')
  set splitright
endif
