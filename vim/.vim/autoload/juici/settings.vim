function! juici#settings#load_plugin_settings() abort
  call juici#settings#deoplete#load()
  call juici#settings#lsp_client#load()
  call juici#settings#polyglot#load()
endfunction
