local map = juici.vim.map

local function icmap(lhs, rhs, opts)
  return map('!', lhs, rhs, opts)
end

return icmap
