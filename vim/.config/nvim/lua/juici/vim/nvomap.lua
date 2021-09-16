local map = juici.vim.map

local function nvomap(lhs, rhs, opts)
  return map('', lhs, rhs, opts)
end

return nvomap
