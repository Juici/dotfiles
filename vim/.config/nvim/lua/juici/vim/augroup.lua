--- Creates an augroup, or recreates an augroup.
local function augroup(name, callback)
  vim.validate {
    name = { name, 'string' },
    callback = { callback, vim.is_callable, 'callable' },
  }

  vim.api.nvim_command('augroup ' .. name)
  vim.api.nvim_command('autocmd!')
  callback()
  vim.api.nvim_command('augroup END')
end

return augroup
