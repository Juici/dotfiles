local map = juici.vim.map

local function lmap(lhs, rhs, opts)
  return map('l', lhs, rhs, opts)
end

return lmap
