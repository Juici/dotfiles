local uv = vim.loop

local Stats = require('vfs.fs.stats')

local F_OK = 0
local R_OK = 4
local W_OK = 2
local X_OK = 1

local fs = {
  --- Test if file exists.
  F_OK = F_OK,
  --- Test if file is readable.
  R_OK = R_OK,
  --- Test if file is writable.
  W_OK = W_OK,
  --- Test if file is executable.
  X_OK = X_OK,
}

--- Performs a stat system call on the given path.
---
---@param path string
---@return Stats? status
function fs.stat(path)
  return Stats:wrap(uv.fs_stat(path))
end

--- Performs an lstat system call on the given path.
---
---@param path string
---@return Stats? status
function fs.lstat(path)
  return Stats:wrap(uv.fs_lstat(path))
end

--- Uses the uid/gid to test for access to the given path.
---
---@param path string
---@param mode integer|string
---@return boolean access
function fs.access(path, mode)
  return uv.fs_access(path, mode)
end

--- Checks if a path exists.
---
---@param path string
---@return boolean exists
function fs.exists(path)
  return fs.access(path, F_OK)
end

return fs
