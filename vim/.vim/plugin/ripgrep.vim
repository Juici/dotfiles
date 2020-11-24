" Use ripgrep as grep program if available.
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
endif
