---@alias st_type
---| "'file'" # A regular file.
---| "'directory'" # A directory.
---| "'link'" # A symbolic link.
---| "'fifo'" # A FIFO named pipe.
---| "'socket'" # A socket.
---| "'char'" # A character device.
---| "'block'" # A block device.

---@alias st_time { nsec: integer, sec: integer }

--- Stats returned by `stat` and `lstat` syscalls.
---
---@class Stats
---
---@field public dev integer
---@field public mode integer
---@field public nlink integer
---@field public uid integer
---@field public gid integer
---@field public rdev integer
---@field public ino integer
---@field public size integer
---@field public blksize integer
---@field public blocks integer
---@field public flags integer
---@field public gen integer
---@field public atime st_time
---@field public mtime st_time
---@field public ctime st_time
---@field public birthtime st_time
---@field public type st_type
local Stats = {}

Stats.__index = Stats

--- Wraps stats returned by libuv.
---
---@param st? table
---@return Stats? stats
function Stats:wrap(st)
  if st == nil then
    return nil
  end

  setmetatable(st, self)

  return st
end

--- Checks if the file is a regular file.
---
---@return boolean file
function Stats:is_file()
  return self.type == 'file'
end

--- Checks if the file is a directory.
---
---@return boolean dir
function Stats:is_dir()
  return self.type == 'directory'
end

--- Checks if the file is a symbolic link.
---
---@return boolean link
function Stats:is_link()
  return self.type == 'link'
end

--- Checks if the file is a FIFO named pipe.
---
---@return boolean fifo
function Stats:is_fifo()
  return self.type == 'fifo'
end

--- Checks if the file is a socket.
---
---@return boolean socket
function Stats:is_socket()
  return self.type == 'socket'
end

--- Checks if the file is a character device.
---
---@return boolean char
function Stats:is_char_device()
  return self.type == 'char'
end

--- Checks if the file is a block device.
---
---@return boolean block
function Stats:is_block_device()
  return self.type == 'block'
end

return Stats
