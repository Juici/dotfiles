-- Get the path to the currently open file/directory.
local function file_path()
  if vim.o.filetype == 'netrw' then
    -- The directory open in the current buffer.
    return vim.b.netrw_curdir
  else
    -- The file open in the current buffer.
    return vim.api.nvim_buf_get_name(0)
  end
end

return file_path
