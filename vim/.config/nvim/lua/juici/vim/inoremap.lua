local noremap = juici.vim.noremap

local function inoremap(lhs, rhs, opts)
  return noremap('i', lhs, rhs, opts)
end

return inoremap
