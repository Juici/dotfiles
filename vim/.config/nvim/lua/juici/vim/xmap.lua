local map = juici.vim.map

local function xmap(lhs, rhs, opts)
  return map('x', lhs, rhs, opts)
end

return xmap
