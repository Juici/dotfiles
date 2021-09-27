-- Gets the vim directory.

local path = require('vfs.path')
local fs = require('vfs.fs')

-- Get the path to this file: '{vim_dir}/lua/juici/g/vim_dir.lua'.
local src = juici.util.source_file()
-- Navigate up to vim dir.
local dir = path.parent(src) -- '{vim_dir}/lua/juici/g'
dir = path.parent(dir) -- '{vim_dir}/lua/juici'
dir = path.parent(dir) -- '{vim_dir}/lua'
dir = path.parent(dir) -- '{vim_dir}'

-- Resolve any symlinks.
return fs.realpath(dir)
