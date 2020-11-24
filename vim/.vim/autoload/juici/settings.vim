let s:settings_dir = expand('<sfile>:p:h') . '/settings'

function! juici#settings#load_settings() abort
  call s:load_settings_modules()
endfunction

" Load all 
function! s:load_settings_modules() abort
  " List of modules in settings dir.
  let l:modules = glob(s:settings_dir . '/*.vim', v:false, v:true)

  for l:module in l:modules
    " The name of the module, from the module file.
    let l:module = fnamemodify(l:module, ':t:r')

    " Get the module load function.
    let l:load_fn = join(['juici', 'settings', l:module, 'load'], '#')

    " Attempt to call module load function.
    try
      execute 'call' l:load_fn . '()'
    catch /E117/
      " Catch unknown function error.
      let v:errmsg = ''

      "call juici#log#warn('Failed to load settings module: ' . l:module)
    endtry
  endfor
endfunction
