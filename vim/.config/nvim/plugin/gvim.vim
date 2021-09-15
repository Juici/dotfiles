" Settings for GVim.
if has('gui_running')
  set guioptions-=T           " Don't show toolbar.
  set guioptions-=L           " Don't show left scrollbar.
  set guioptions-=l
  set guioptions-=R           " Don't show right scrollbar.
  set guioptions-=r
  set guioptions-=b           " Don't show bottom scrollbar.

  call juici#gui#set_size()
  call juici#gui#set_font()
endif
