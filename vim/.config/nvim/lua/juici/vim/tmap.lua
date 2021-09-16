local map = juici.vim.map

local function tmap(lhs, rhs, opts)
  return map('t', lhs, rhs, opts)
end

return tmap
