local uv = vim.uv

--- Stats returned by `stat`, `lstat`, and `fstat` syscalls.
---
---@class stat: uv.fs_stat.result
---@field type stat.type

---@alias stat.type
---| "file" # A regular file.
---| "directory" # A directory.
---| "link" # A symbolic link.
---| "fifo" # A FIFO named pipe.
---| "socket" # A socket.
---| "char" # A character device.
---| "block" # A block device.

---@alias access_mode
---| ""
---| "r"
---| "rw"
---| "rwx"
---| "w"
---| "wx"
---| "x"

local M = {}

--- Performs a `stat` system call on the given path.
---
---@param path string
---@return stat?
function M.stat(path)
    return uv.fs_stat(path) --[[@as stat]]
end

--- Performs an `lstat` system call on the given path.
---
---@param path string
---@return stat?
function M.lstat(path)
    return uv.fs_lstat(path) --[[@as stat]]
end

--- Performs an `fstat` system call on the given file descriptor.
---
---@param fd integer
---@return stat?
function M.fstat(fd)
    return uv.fs_fstat(fd) --[[@as stat]]
end

--- Uses the uid/gid to test for access to the given path.
---
---@param path string
---@param mode access_mode
---@return boolean
function M.access(path, mode)
    return uv.fs_access(path, mode) == true
end

--- Rename a file or directory.
---
---@param path string
---@param new_path string
---@return boolean
function M.rename(path, new_path)
    return uv.fs_rename(path, new_path) == true
end

--- Returns `true` if the given path exists.
---
---@param path string
---@return boolean
function M.exists(path)
    return M.access(path, "")
end

--- Returns `true` if the given path is readable.
---
---@param path string
---@return boolean
function M.is_readable(path)
    return M.access(path, "r")
end

--- Returns `true` if the given path is writable.
---
---@param path string
---@return boolean
function M.is_writable(path)
    return M.access(path, "w")
end

--- Returns `true` if the given path is executable.
---
---@param path string
---@return boolean
function M.is_executable(path)
    return M.access(path, "x")
end

--- Returns `true` if the given path is a regular file.
---
---@param path string
---@return boolean
function M.is_file(path)
    local st = M.stat(path)
    return st ~= nil and st.type == "file"
end

--- Returns `true` if the given path is a directory.
---
---@param path string
---@return boolean
function M.is_dir(path)
    local st = M.stat(path)
    return st ~= nil and st.type == "directory"
end

--- Returns `true` if the given path is a symbolic link.
---
---@param path string
---@return boolean
function M.is_link(path)
    local st = M.lstat(path)
    return st ~= nil and st.type == "link"
end

return M
