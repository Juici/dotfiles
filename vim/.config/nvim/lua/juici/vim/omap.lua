local map = juici.vim.map

local function omap(lhs, rhs, opts)
  return map('o', lhs, rhs, opts)
end

return omap
