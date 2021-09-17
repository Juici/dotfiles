local cnoremap = juici.vim.cnoremap
local rhs = juici.vim.rhs

-- Use <Up> and <Down> for history navigation and tab completion.
cnoremap('<Up>', '<C-p>')
cnoremap('<Down>', '<C-n>')

-- Use <C-a> and <C-e> to navigate to start or end of line.
cnoremap('<C-a>', '<Home>')
cnoremap('<C-e>', '<End>')

-- Bind <C-BS> to delete word backward.
cnoremap('<C-BS>', '<C-w>')
cnoremap('<C-h>', '<C-w>')

-- Bind <C-Del> to delete word forward.
do
  -- Use `vim.regex` to support `iskeyword` option.
  local re = vim.regex('\\%#=2\\v^\\s*%(\\k+|[^[:keyword:][:space:]]+)?')

  cnoremap('<C-Del>', function()
    local buf = vim.fn.getcmdline()
    local pos = vim.fn.getcmdpos()

    -- If at end of buffer then do nothing.
    if pos > #buf then
      return ''
    end

    local left = buf:sub(1, pos - 1)
    local right = buf:sub(pos)

    local _, del = re:match_str(right)
    right = right:sub(del + 1)

    buf =  left .. right

    return rhs([[<C-\>e']]) .. buf .. rhs([['<CR>]])
  end, { expr = true })
end
