" Make sure lightline is loaded.
try
  call lightline#init()
  let g:juici#_loaded_lightline = v:true
catch /E117/
  call juici#log#warn('Lightline is not loaded')
  finish
endtry

" Hide modeline if lightline is enabled.
set noshowmode

let g:lightline = {
      \   'colorscheme': 'onedark',
      \   'active': {
      \     'left': [ [ 'mode', 'paste' ],
      \               [ 'filename', 'readonly' ],
      \               [ 'diagnostics' ],
      \               [ 'lint' ] ],
      \     'right': [ [ 'lineinfo' ],
      \                [ 'gitbranch' ],
      \                [ 'filetype', 'fileformat', 'fileencoding' ] ],
      \   },
      \   'component_expand': {
      \     'readonly': 'juici#status#read_only',
      \     'lineinfo': 'juici#status#line_info',
      \   },
      \   'component_visible_condition': {
      \     'readonly': '&readonly',
      \   },
      \   'component_type': {
      \     'readonly': 'error',
      \   },
      \   'component_function': {
      \     'fileencoding': 'juici#status#file_encoding',
      \     'filename': 'juici#status#file_name',
      \     'fileformat': 'juici#status#file_format',
      \     'filetype': 'juici#status#file_type',
      \     'gitbranch': 'juici#status#git_branch',
      \     'diagnostics': 'juici#status#diagnostics',
      \     'lint': 'juici#status#lint_status',
      \   },
      \   'tabline': {
      \     'left': [ [ 'tabs' ] ],
      \     'right': [ [ 'close' ] ],
      \   },
      \   'tab': {
      \     'active': [ 'filename', 'modified' ],
      \     'inactive': [ 'filename', 'modified' ],
      \   },
      \   'separator': { 'left': '', 'right': '' },
      \   'subseparator': { 'left': '|', 'right': '|' },
      \ }
