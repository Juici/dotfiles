local settings = {}

local src = debug.getinfo(1, 'S').source:sub(2)
local dir = juici.path.parent(src)

local modules = {}

local function load_module(name)
  if modules[name] == nil then
    local file = juici.path.join(dir, name .. '.lua')
    modules[name] = assert(loadfile(file))
  end
  modules[name]()
end

function settings.load()
  load_module('general')
  load_module('persist')
  load_module('appearance')
  load_module('editing')
end

return settings
