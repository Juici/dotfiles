" Hide modeline if lightline is enabled.
if &loadplugins
  set noshowmode
endif

let g:lightline = {
      \   'colorscheme': 'onedark',
      \   'active': {
      \     'left': [ [ 'mode', 'paste' ],
      \               [ 'filename', 'readonly' ] ],
      \     'right': [ [ 'lineinfo' ],
      \                [ 'gitbranch' ],
      \                [ 'filetype', 'fileformat', 'fileencoding' ],
      \                [ 'linter_warnings', 'linter_errors' ] ],
      \   },
      \   'component_expand': {
      \     'readonly': 'juici#status#read_only',
      \     'lineinfo': 'juici#status#line_info',
      \     'linter': 'juici#status#Linter',
      \     'linter_warnings': 'juici#status#linter_warnings',
      \     'linter_errors': 'juici#status#linter_errors',
      \     'linter_ok': 'juici#status#linter_ok',
      \   },
      \   'component_type': {
      \     'readonly': 'error',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \   },
      \   'component_function': {
      \     'fileencoding': 'juici#status#file_encoding',
      \     'filename': 'juici#status#file_name',
      \     'fileformat': 'juici#status#file_format',
      \     'filetype': 'juici#status#file_type',
      \     'gitbranch': 'juici#status#git_branch',
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
