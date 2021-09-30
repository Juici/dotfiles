local uv = vim.loop
local _path = require('vfs.path')

local Stat = require('vfs.fs.stat')

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
---@return Stat?
function fs.stat(path)
  return Stat:wrap(uv.fs_stat(path))
end

--- Performs an lstat system call on the given path.
---
---@param path string
---@return Stat?
function fs.lstat(path)
  return Stat:wrap(uv.fs_lstat(path))
end

--- Performs an fstat system call on the given file descriptor.
---
---@param fd integer
---@return Stat?
function fs.fstat(fd)
  return Stat:wrap(uv.fs_fstat(fd))
end

--- Uses the uid/gid to test for access to the given path.
---
---@param path string
---@param mode integer|string
---@return boolean
function fs.access(path, mode)
  return uv.fs_access(path, mode)
end

--- Rename a file or directory.
---
---@param path string
---@param new_path string
---@return boolean
function fs.rename(path, new_path)
  return uv.fs_rename(path, new_path)
end

--- Returns `true` if the given path exists.
---
---@param path string
---@return boolean
function fs.exists(path)
  return fs.access(path, F_OK)
end

--- Returns `true` if the given path is readable.
---
---@param path string
---@return boolean
function fs.is_readable(path)
  return fs.access(path, R_OK)
end

--- Returns `true` if the given path is writable.
---
---@param path string
---@return boolean
function fs.is_writable(path)
  return fs.access(path, W_OK)
end

--- Returns `true` if the given path is executable.
---
---@param path string
---@return boolean
function fs.is_executable(path)
  return fs.access(path, X_OK)
end

--- Returns `true` if the given path is a regular file.
---
---@param path string
---@return boolean
function fs.is_file(path)
  local st = fs.stat(path)
  return st ~= nil and st:is_file()
end

--- Returns `true` if the given path is a directory.
---
---@param path string
---@return boolean
function fs.is_dir(path)
  local st = fs.stat(path)
  return st ~= nil and st:is_dir()
end

--- Returns `true` if the given path is a symbolic link.
---
---@param path string
---@return boolean
function fs.is_link(path)
  local st = fs.lstat(path)
  return st ~= nil and st:is_link()
end

--- Resolves symlinks in the given path and normalises the result.
---
---@param path string
---@return string
function fs.realpath(path)
  local resolved = vim.fn.resolve(path)
  return _path.resolve(resolved)
end

return fs
