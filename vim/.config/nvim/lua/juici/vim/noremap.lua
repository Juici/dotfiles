local map = juici.vim.map
local merge = juici.util.shallow_merge

local function noremap(mode, lhs, rhs, opts)
  opts = opts or {}
  return map(mode, lhs, rhs, merge(opts, { noremap = true }))
end

return noremap
