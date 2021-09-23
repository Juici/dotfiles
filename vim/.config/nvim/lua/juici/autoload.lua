-- Provides a mechanism for lazy autoloading, similar to mechanism in
-- Vimscript.
local function autoload(base)
  local mt = {
    __index = function(t, key)
      local ok, val = pcall(require, base .. '.' .. key)
      if ok then
        t[key] = val
        return val
      end
      return nil
    end
  }
  return setmetatable({}, mt)
end

return autoload
