-- Gets the vim directory.

local path = juici.path
local util = juici.util

-- Get the path to this file: '{vim_dir}/lua/juici/g/vim_dir.lua'.
local src = util.source_file()
-- Navigate up to vim dir.
local dir = path.parent(src) -- '{vim_dir}/lua/juici/g'
dir = path.parent(dir) -- '{vim_dir}/lua/juici'
dir = path.parent(dir) -- '{vim_dir}/lua'
dir = path.parent(dir) -- '{vim_dir}'

-- Resolve any symlinks.
return path.realpath(dir)
