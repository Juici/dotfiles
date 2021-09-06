-- Provides a mechanism for lazy autoloading, similar to mechanism in
-- Vimscript.
local function autoload(base)
  local storage = {}
  local mt = {
    __index = function(_, key)
      if storage[key] == nil then
        storage[key] = require(base .. '.' .. key)
      end
      return storage[key]
    end
  }
  return setmetatable({}, mt)
end

return autoload
