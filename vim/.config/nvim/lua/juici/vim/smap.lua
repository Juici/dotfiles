local map = juici.vim.map

local function smap(lhs, rhs, opts)
  return map('s', lhs, rhs, opts)
end

return smap
