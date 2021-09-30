local uv = vim.loop
local os = require('os')

local process = {}

--- Returns the path to the current working directory.
---
---@return string
function process.cwd()
  return uv.cwd()
end

--- Changes the current working directory to the given path.
---
---@param path string
function process.chdir(path)
  uv.chdir(path)
end

do
  local _getenv = os.getenv

  ---@param name string
  ---@return string?
  local function getenv(_, name)
    local value = _getenv(name)
    if value ~= nil then
      return value
    end

    -- Handle fallback case of 'VIM' or 'VIMRUNTIME'.
    if name == 'VIM' or name == 'VIMRUNTIME' then
      value = vim.env[name]
    end

    return value
  end

  ---@param name string
  ---@param value? string|number
  local function setenv(_, name, value)
    if value == nil then
      uv.os_unsetenv(name)
    else
      uv.os_setenv(name, value)
    end
  end

  --- Access and modify environment variables.
  process.env = setmetatable({}, {
    -- Gets an environment variable.
    __index = getenv,
    -- Sets or unsets an environment variable.
    __newindex = setenv,
    -- Gets a snapshot of the current environment variables.
    __call = uv.os_environ,
  })
end

--- Returns the path to the current executable.
---
---@return string
function process.exepath()
  return uv.exepath()
end

--- Returns the current process id.
---
---@return integer
function process.pid()
  return uv.os_getpid()
end

--- Returns the parent process id.
---
---@return integer
function process.ppid()
  return uv.os_getppid()
end

--- Returns a current timestamp in milliseconds.
---
--- The timestamp increases monotonically from some arbitrary point in time.
---
---@return integer
function process.now()
  return uv.now()
end

process.hrtime = require('vfs.process.hrtime')

--------------------------------------------------
-- Fallback to stdlib
--------------------------------------------------

-- Pass through calls to missing functions to stdlib module.
setmetatable(process, {
  __index = function(_, fn)
    return os[fn]
  end,
})

return process
