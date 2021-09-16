local noremap = juici.vim.noremap

local function vnoremap(lhs, rhs, opts)
  return noremap('v', lhs, rhs, opts)
end

return vnoremap
