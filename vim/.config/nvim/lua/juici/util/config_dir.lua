-- Gets the vim config directory.
local function config_dir()
  -- Get the path to this file.
  local src = debug.getinfo(1, 'S').source:sub(2)
  -- Strip file and navigate up 3 directories.
  local dir = vim.fn.fnamemodify(src, ':h:h:h:h')
  -- Resolve any symlinks.
  return vim.fn.resolve(dir)
end

return config_dir
