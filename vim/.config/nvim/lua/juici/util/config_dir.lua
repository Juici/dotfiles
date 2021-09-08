local path = require('path')

-- Gets the vim config directory.
local function config_dir()
  -- Get the path to this file.
  local src = debug.getinfo(1, 'S').source:sub(2)
  -- Strip file and navigate up 3 directories.
  local dir = path.parent(path.parent(path.parent(path.parent(src))))
  -- Resolve any symlinks.
  return path.realpath(dir)
end

return config_dir
