if &loadplugins
  set noshowmode
endif

let g:lightline = {
      \   'colorscheme': 'onedark',
      \   'active': {
      \     'left': [ [ 'mode', 'paste' ],
      \               [ 'gitbranch' ],
      \               [ 'readonly', 'filename' ] ],
      \     'right': [ [ 'lineinfo' ],
      \                [ 'percent' ],
      \                [ 'filetype', 'fileformat', 'fileencoding' ],
      \                [ 'linter_warnings', 'linter_errors' ] ]
      \   },
      \   'component_expand': {
      \     'readonly': 'juici#lightline#ReadOnly',
      \     'linter': 'juici#lightline#Linter',
      \     'linter_warnings': 'juici#lightline#LinterWarnings',
      \     'linter_errors': 'juici#lightline#LinterErrors',
      \     'linter_ok': 'juici#lightline#LinterOk'
      \   },
      \   'component_type': {
      \     'readonly': 'error',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error'
      \   },
      \   'component_function': {
      \     'fileencoding': 'juici#lightline#FileEncoding',
      \     'filename': 'juici#lightline#FileName',
      \     'fileformat': 'juici#lightline#FileFormat',
      \     'filetype': 'juici#lightline#FileType',
      \     'gitbranch': 'juici#lightline#GitBranch'
      \   },
      \   'tabline': {
      \     'left': [ [ 'tabs' ] ],
      \     'right': [ [ 'close' ] ]
      \   },
      \   'tab': {
      \     'active': [ 'filename', 'modified' ],
      \     'inactive': [ 'filename', 'modified' ]
      \   },
      \   'separator': { 'left': '', 'right': '' },
      \   'subseparator': { 'left': '|', 'right': '|' }
      \ }
