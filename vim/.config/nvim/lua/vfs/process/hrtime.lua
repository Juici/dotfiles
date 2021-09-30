local uv = vim.loop
local ffi = require('ffi')

local C = ffi.C

-- libuv should already be loaded by Neovim.
ffi.cdef [[
  uint64_t uv_hrtime();
]]

---@diagnostic disable: undefined-field


--- Returns the current high-resolution timestamp in seconds and nanoseconds,
--- where the nanoseconds part is the remaining part that cannot be represented
--- in second precision.
---
--- The timestamp is relative to an arbitrary time in the past, and not related
--- to the time of day and therefore not subject to clock drift.
local hrtime = {}

local mt = {}

---@return integer secs, integer nanos
mt.__call = function()
  local time = C.uv_hrtime()

  local secs = time / 1000000000ULL
  local nanos = time - secs * 1000000000ULL

  return tonumber(secs), tonumber(nanos)
end

mt.__index = {
  --- Returns the current high-resolution timestamp in nanoseconds.
  ---
  ---@return ffi.cdata* uint64_t
  bigint = function()
    return C.uv_hrtime()
  end,
  --- Returns the current high-resolution timestamp in nanoseconds with
  --- some precision loss.
  ---
  ---@return integer
  lossy = function()
    return uv.hrtime()
  end,
}

-- Make `hrtime` a readonly table.
mt.__newindex = function() end

return setmetatable(hrtime, mt)
