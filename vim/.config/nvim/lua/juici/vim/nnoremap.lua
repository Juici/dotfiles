local noremap = juici.vim.noremap

local function nnoremap(lhs, rhs, opts)
  return noremap('n', lhs, rhs, opts)
end

return nnoremap
