local noremap = juici.vim.noremap

local function xnoremap(lhs, rhs, opts)
  return noremap('x', lhs, rhs, opts)
end

return xnoremap
