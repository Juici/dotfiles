local map = juici.vim.map

local function cmap(lhs, rhs, opts)
  return map('c', lhs, rhs, opts)
end

return cmap
