local noremap = juici.vim.noremap

local function lnoremap(lhs, rhs, opts)
  return noremap('l', lhs, rhs, opts)
end

return lnoremap
