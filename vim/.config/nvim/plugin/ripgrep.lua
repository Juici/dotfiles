-- Use ripgrep as grep program if available.
if vim.fn.executable('rg') then
  vim.opt.grepprg = 'rg --vimgrep --no-heading --smart-case'
end
