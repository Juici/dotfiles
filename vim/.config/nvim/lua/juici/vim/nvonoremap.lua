local noremap = juici.vim.noremap

local function nvonoremap(lhs, rhs, opts)
  return noremap('', lhs, rhs, opts)
end

return nvonoremap
