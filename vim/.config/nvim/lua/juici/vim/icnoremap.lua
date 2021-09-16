local noremap = juici.vim.noremap

local function icnoremap(lhs, rhs, opts)
  return noremap('!', lhs, rhs, opts)
end

return icnoremap
