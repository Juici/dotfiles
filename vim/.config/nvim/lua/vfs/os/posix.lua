local uv = vim.loop

local posix = {}

--- Returns the real user id.
---
---@return integer
function posix.getuid()
  return uv.getuid()
end

--- Returns the real group id.
---
---@return integer
function posix.getgid()
  return uv.getgid
end

return posix
