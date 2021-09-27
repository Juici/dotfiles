local path = require('vfs.path')

local src = juici.util.source_file()
local dir = path.parent(src)

local modules = {}

local function load_module(name)
  if modules[name] == nil then
    local file = path.join(dir, name .. '.lua')
    modules[name] = assert(loadfile(file))
  end
  modules[name]()
end

local settings = {}

function settings.load()
  load_module('general')
  load_module('persist')
  load_module('appearance')
  load_module('editing')
end

return settings
