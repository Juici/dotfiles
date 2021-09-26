local uv = vim.loop

local os = {}

--- Gets the path to the current working directory.
---
---@return string path
function os.getcwd()
  return uv.cwd()
end

--- Changes the current working directory to the given path.
---
---@param path string
function os.setcwd(path)
  uv.chdir(path)
end

--- Gets the path to the user's home directory.
---
---@return string path
function os.homedir()
  return uv.os_homedir()
end

--- Gets the current process id.
---
---@return integer pid
function os.getpid()
  return uv.os_getpid()
end

return os
