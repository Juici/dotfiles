local THRESHOLD_PWD_WIDTH = 20
local THRESHOLD_FILE_WIDTH = 20

local function title()
  local prog = vim.v.progname

  local pwd = juici.util.pwd()
  -- Resolve the working directory with tilde notation.
  pwd = vim.fn.fnamemodify(pwd, ':~')

  -- Shorten directory names for paths if they exceed the threshold.
  if #pwd > THRESHOLD_PWD_WIDTH then
    pwd = vim.fn.pathshorten(pwd)
  end

  local s = pwd .. ' - ' .. prog

  local file = juici.util.file_path()
  if file ~= '' then
    -- Resolve the file name replative to the working directory and fallback to
    -- tilde notation if not inside working directory path.
    file = vim.fn.fnamemodify(file, ':~:.')

    -- Shorten directory names for paths if they exceed the threshold.
    if #file > THRESHOLD_FILE_WIDTH then
      file = vim.fn.pathshorten(file)
    end

    s = s .. ' (' .. file ..  ')'
  end

  return s
end

return title
