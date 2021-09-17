local inoremap = juici.vim.inoremap
local rhs = juici.vim.rhs

-- Bind <C-BS> to delete word backward.
inoremap('<C-BS>', '<C-w>')
inoremap('<C-h>', '<C-w>')

inoremap('<C-Del>', function()
  -- Get the cursor column (zero-indexed).
  local col = vim.api.nvim_win_get_cursor(0)[2]
  -- Get the current line.
  local buf = vim.api.nvim_get_current_line()

  -- If at end of line just delete the line break.
  if col == #buf then
    return rhs([[<C-\><C-o>v"_d]])
  end

  -- Get the text to the right of the cursor.
  local right = buf:sub(col + 1)

  -- Fix oddity when at last character in word, where `de` deletes the next word
  -- too.
  if right:match('^%S%s') then
    return rhs([[<C-o>"_x]])
  end

  -- If only whitespace exists until the end of the line, then delete until the
  -- end of the line. (This requires that there exists at least one whitespace
  -- character).
  if right:match('^%s+$') then
    return rhs([[<C-o>v$h"_d]])
  end

  return rhs([[<C-o>"_de]])
end, { expr = true })
