local noremap = juici.vim.noremap

local function cnoremap(lhs, rhs, opts)
  return noremap('c', lhs, rhs, opts)
end

return cnoremap
