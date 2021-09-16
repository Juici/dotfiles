-- Shallow merges `src` into `dst`, returning a copy.
--
-- The original tables are not modified.
local function shallow_merge(dst, src)
  return vim.tbl_extend('force', dst, src)
end

return shallow_merge
