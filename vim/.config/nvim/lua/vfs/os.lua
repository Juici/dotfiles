local uv = vim.loop
local _os = require('os')

local os = {}

--- Returns the path to the current working directory.
---
---@return string
function os.getcwd()
  return uv.cwd()
end

--- Changes the current working directory to the given path.
---
---@param path string
function os.setcwd(path)
  uv.chdir(path)
end

do
  local _getenv = _os.getenv

  --- Returns the value of the given environment variable.
  ---
  ---@param name string
  ---@return string
  function os.getenv(name)
    local value = _getenv(name)
    if value ~= nil then
      return value
    end

    -- Handle fallback case of 'VIM' or 'VIMRUNTIME'.
    if name == 'VIM' or name == 'VIMRUNTIME' then
      value = vim.fn.getenv(name)
      if value == vim.NIL then
        value = nil
      end
    end

    return value
  end
end

--- Sets the value of the given environment variable.
---
--- If `value` is `nil`, then the environment variable will be unset.
---
---@param name string
---@param value? string
function os.setenv(name, value)
  uv.os_setenv(name, value)
end

--- Returns the path to the user's home directory.
---
---@return string
function os.homedir()
  return uv.os_homedir()
end

--- Returns the path to the current executable.
---
---@return string
function os.exepath()
  return uv.exepath()
end

--- Returns the current process id.
---
---@return integer
function os.getpid()
  return uv.os_getpid()
end

--- Returns the parent process id.
---
---@return integer
function os.getppid()
  return uv.os_getppid()
end

-- Pass through calls to missing functions to native os module.
do
  local mt = {
    __index = function(_, fn)
      return _os[fn]
    end,
  }
  setmetatable(os, mt)
end

return os
