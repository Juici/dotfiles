local map = juici.vim.map

local function imap(lhs, rhs, opts)
  return map('i', lhs, rhs, opts)
end

return imap
