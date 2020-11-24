" Vim is being run in sudo, ie. the user is not root user.
let s:is_sudo = exists('$SUDO_USER')
" Directory in which to store temporary files.
let s:tmp_dir = g:vim_dir . '/tmp'

"
" Backup files.
"

if s:is_sudo
  " Don't create root-owned temporary files in sudo.
  set nobackup
  set nowritebackup
else
  " Keep backup files out of the way.
  execute 'set' 'backupdir=' . s:tmp_dir . '/backup'
  set backupdir+=.

  " Disable backup files.
  set nobackup
  set nowritebackup
endif

"
" Swap files.
"

if s:is_sudo
  " Don't create root-owned temporary files in sudo.
  set noswapfile
else
  " Keep swap files out of the way.
  execute 'set' 'directory=' . s:tmp_dir . '/swap'
  set directory+=.
endif

" Let OS sync swap files lazily.
if exists('&swapsync')
  set swapsync=
endif

" Update swap files every 80 typed characters.
set updatecount=80
" Update swap files every 300ms if nothing is typed.
"
" Note: This is also used for the CursorHold autocomment event, a longer
"       updatetime leads to noticable delays and degrades the user experience.
set updatetime=300

"
" Undo files.
"

if has('persistant_undo')
  if s:is_sudo
    " Don't create root-owned temporary files in sudo.
    set noundofile
  else
    " Keep undo files out of the way.
    execute 'set' 'undodir=' . s:tmp_dir . '/undo'
    set undodir+=.

    " Enable undo files.
    set undofile
  endif
endif

"
" Viminfo file.
"

if has('shada')
  " Neovim.
  let s:viminfo = 'shada'
elseif has('viminfo')
  " Vim.
  let s:viminfo = 'viminfo'
endif

if exists('s:viminfo')
  if s:is_sudo
    " Don't create root-owned temporary files in sudo.
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
          call juici#log#warn(s:viminfo . ' file exists but is not readable: '
                \ . s:viminfo_file)
        endif
      endif
  endif
endif

"
" Sessions.
"

if has('mksession')
  " Keep view files out of the way, overrides `~/.vim/view` default.
  execute 'set' 'viewdir=' . s:tmp_dir . '/view'

  " Save/Restore only theses options (with `:{mk,load}view`).
  set viewoptions=cursor,folds
endif
