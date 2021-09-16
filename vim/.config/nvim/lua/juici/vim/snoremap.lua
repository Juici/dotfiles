local noremap = juici.vim.noremap

local function snoremap(lhs, rhs, opts)
  return noremap('s', lhs, rhs, opts)
end

return snoremap
