local map = juici.vim.map

local function nmap(lhs, rhs, opts)
  return map('n', lhs, rhs, opts)
end

return nmap
