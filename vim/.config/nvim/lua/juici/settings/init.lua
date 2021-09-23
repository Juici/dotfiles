local path = juici.path
local util = juici.util

local src = util.source_file()
local dir = path.parent(src)

local modules = {}

local function load_module(name)
  if modules[name] == nil then
    local file = juici.path.join(dir, name .. '.lua')
    modules[name] = assert(loadfile(file))
  end
  modules[name]()
end

local M = {}

M.load = function()
  load_module('general')
  load_module('persist')
  load_module('appearance')
  load_module('editing')
end

return M
