local ffi = require('ffi')

local C = ffi.C

ffi.cdef [[
  typedef unsigned int uid_t;
  typedef unsigned int gid_t;

  uid_t getuid();
  uid_t geteuid();
  gid_t getgid();
  gid_t getegid();
]]

local posix = {}

--- Returns the real user id.
---
---@return integer
posix.getuid = C.getuid

--- Returns the effective user id.
---
---@return integer
posix.geteuid = C.geteuid

--- Returns the real group id.
---
---@return integer
posix.getgid = C.getgid

--- Returns the effective group id.
---
---@return integer
posix.getegid = C.getegid

return posix
