scriptencoding utf-8

"
" General.
"

set cursorline        " Highlight the current line.
set showmatch         " Show matching brackets, etc.

set laststatus=2      " Always show status line.
set cmdheight=2       " Set command bar height, with space for longer messages.

set lazyredraw        " Don't bother updating screen during macro playback.

if has('linebreak')
  set linebreak       " Wrap long lines at characters in `breakat`.
endif

"
" Gutter.
"

" Show line numbers.
set number

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear or resolve.
if has("patch-8.1.1564")
  " Merge signcolumn with line number column.
  set signcolumn=number
else
  set signcolumn=yes
endif

"
" Fill chars.
"

" Set the character used to denote a deleted line in diff view.
if has('diff')
  set fillchars=diff:∙          " BULLET OPERATOR (U+2219).
endif

" Set the character used to draw window separators.
if has('windows')
  set fillchars+=vert:│         " BOX BRAWINGS LIGHT VERTICAL (U+2502).
endif

" Suppress ~ at EndOfBuffer.
if has('nvim-0.3.1')
  set fillchars+=eob:\          " Fills using a space.
endif

"
" Folding.
"

if has('folding')
  " The character to fill fold line with.
  set fillchars+=fold:·           " MIDDLE DOT (U+00B7).

  set foldmethod=marker           " Fold based of markers.
  set foldcolumn=1                " Fold column size.
  set foldtext=juici#fold#text()  " Function for displaying fold text.

  set diffopt+=foldcolumn:0       " Don't show folds in diff view.
endif

"
" Whitespace.
"

" Show whitespace.
set list

set listchars=nbsp:⦸      " CIRCLED REVERSE SOLIDUS (U+29B8).
set listchars+=tab:\     " KEYBOARD TAB (U+F811) + SPACE (U+0020).
set listchars+=extends:»  " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00BB).
set listchars+=precedes:« " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00AB).
set listchars+=trail:•    " BULLET (U+2022).

"
" Messages.
"

set shortmess+=A    " Ignore annoying swapfile messages.
set shortmess+=I    " No splash screen.
set shortmess+=O    " File-read message overwrites previous.
set shortmess+=T    " Truncate non-file messages in middle.
set shortmess+=W    " Don't echo '[w]'/'[written]' when writing.
set shortmess+=a    " Abbreviations in messages (eg. '[RO]' not '[readonly]').
if has('patch-7.4.314')
  set shortmess+=c  " Completion messages.
endif
set shortmess+=o    " Overwrite file-written messages.
set shortmess+=t    " Truncate file messages at start.

"
" Cursor.
"

" Switch cursor when in different modes.
set guicursor=a:blinkon0-Cursor/lCursor   " Disable blinking and set colour.
set guicursor+=n-v-c:block                " Normal mode.
set guicursor+=i-ci-ve:ver25              " Insert mode.
set guicursor+=r-cr:hor20                 " Replace mode.
set guicursor+=o:hor50                    " Operator-pending mode.

" Attempt to use xterm escape sequences to change cursor shape for vim.
if !has('nvim')
  let &t_SI = "\<Esc>[6 q"
  let &t_SR = "\<Esc>[4 q"
  let &t_EI = "\<Esc>[2 q"

  " Fix lagging cursor shape when waiting for escape sequence.
  set ttimeoutlen=10
endif
