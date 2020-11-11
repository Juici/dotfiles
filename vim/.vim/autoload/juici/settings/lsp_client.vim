function! juici#settings#lsp_client#load() abort
  let g:LanguageClient_serverCommands = {}

  call s:add_command('rust', ['rustup', 'run', 'nightly', 'rls'])
  call s:add_command('python', ['pyls'])
endfunction

function! s:add_command(language, command) abort
  if len(a:command) == 0
    call juici#log#warn('Warning: Empty LSP command: ' . a:language)
    return 0
  elseif executable(a:command[0])
    let l:command = a:command
    let l:command[0] = exepath(a:command[0])

    let g:LanguageClient_serverCommands[a:language] = l:command
  endif
endfunction
