local map = juici.vim.map

local function vmap(lhs, rhs, opts)
  return map('v', lhs, rhs, opts)
end

return vmap
