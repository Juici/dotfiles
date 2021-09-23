-- Reloads an autoloaded module.
local function reload(base, key)
  -- Clear cached value.
  package.loaded[base .. '.' .. key] = nil
  rawset(_G[base], key, nil)

  -- Load the module.
  return _G[base][key]
end

return reload
