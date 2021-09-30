---@alias st_type
---| "'file'" # A regular file.
---| "'directory'" # A directory.
---| "'link'" # A symbolic link.
---| "'fifo'" # A FIFO named pipe.
---| "'socket'" # A socket.
---| "'char'" # A character device.
---| "'block'" # A block device.

---@alias timespec { sec: integer, nsec: integer }

--- Stats returned by `stat` and `lstat` syscalls.
---
---@class Stat
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
---@field public atime timespec
---@field public mtime timespec
---@field public ctime timespec
---@field public birthtime timespec
---@field public type st_type
local Stat = {}

Stat.__index = Stat

--- Wraps stats returned by libuv.
---
---@param st? table
---@return Stat? stats
function Stat:wrap(st)
  if st == nil then
    return nil
  end
  return setmetatable(st, self)
end

--- Checks if the file is a regular file.
---
---@return boolean file
function Stat:is_file()
  return self.type == 'file'
end

--- Checks if the file is a directory.
---
---@return boolean dir
function Stat:is_dir()
  return self.type == 'directory'
end

--- Checks if the file is a symbolic link.
---
---@return boolean link
function Stat:is_link()
  return self.type == 'link'
end

--- Checks if the file is a FIFO named pipe.
---
---@return boolean fifo
function Stat:is_fifo()
  return self.type == 'fifo'
end

--- Checks if the file is a socket.
---
---@return boolean socket
function Stat:is_socket()
  return self.type == 'socket'
end

--- Checks if the file is a character device.
---
---@return boolean char
function Stat:is_char_device()
  return self.type == 'char'
end

--- Checks if the file is a block device.
---
---@return boolean block
function Stat:is_block_device()
  return self.type == 'block'
end

return Stat
