local noremap = juici.vim.noremap

local function tnoremap(lhs, rhs, opts)
  return noremap('t', lhs, rhs, opts)
end

return tnoremap
