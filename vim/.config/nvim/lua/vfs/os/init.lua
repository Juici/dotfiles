local uv = vim.loop
local _os = require('os')

local os = {}

--------------------------------------------------
-- Constants
--------------------------------------------------

do
  local is_windows
  if jit and jit.os then
    is_windows = jit.os == 'Windows'
  else
    is_windows = package.config:sub(1, 1) == '\\'
  end

  --- `true` if the platform operating system is Windows.
  os.is_windows = is_windows
end

---@alias platform
---| "'windows'"
---| "'posix'"

do
  local platform
  if os.is_windows then
    platform = 'windows'
  else
    platform = 'posix'
  end

  --- The platform operating system.
  ---
  ---@type platform
  os.platform = platform
end

--------------------------------------------------
-- Functions
--------------------------------------------------

--- Returns the path to the user's home directory.
---
---@return string
function os.homedir()
  return uv.os_homedir()
end

--- Returns the path to the temporary directory.
---
---@return string
function os.tmpdir()
  return uv.os_tmpdir()
end

--------------------------------------------------
-- Extensions
--------------------------------------------------

if not os.is_windows then
  --- Posix specific OS module.
  os.posix = require('vfs.os.posix')
end

--------------------------------------------------
-- Fallback to stdlib
--------------------------------------------------

-- Pass through calls to missing functions to stdlib module.
setmetatable(os, {
  __index = function(_, fn)
    return _os[fn]
  end,
})

return os
