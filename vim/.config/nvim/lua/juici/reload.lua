-- Reloads an autoloaded module.
local function reload(mod)
  -- Clear cached value.
  package.loaded[mod] = nil
  -- Load the module.
  return load('return ' .. mod)()
end

return reload
