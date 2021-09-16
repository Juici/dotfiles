local noremap = juici.vim.noremap

local function onoremap(lhs, rhs, opts)
  return noremap('o', lhs, rhs, opts)
end

return onoremap
