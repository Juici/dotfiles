local path = require('vfs.path')
local fs = require('vfs.fs')

-- Tie-breaker index used in the event that multiple registrations happen in the
-- same file + line.
local callback_idx = 0

-- Prefix and suffix with are stripped from keys.
local PREFIX = juici.g.vim_dir .. path.sep
local SUFFIX = '.lua'

local function gen_fn_key(fn, storage)
  local info = debug.getinfo(fn, 'S')
  local key = info.short_src
  if fs.is_file(key) then
    key = fs.realpath(key)
  end

  -- Strip prefix from key.
  if vim.startswith(key, PREFIX) then
    key = key:sub(#PREFIX + 1)
  end
  -- Strip suffix from key.
  if vim.endswith(key, SUFFIX) then
    key = key:sub(1, #key - #SUFFIX)
  end

  -- Replace non-alphanumeric characters with '_' and prefix key with '_'.
  key = '_' .. key:gsub('%W', '_')
  -- Add the line number.
  key = key .. '_L' .. info.linedefined

  -- If the key is already in use, then append tie-breaker callback index.
  if storage[key] ~= nil then
    key = key .. '_' .. callback_idx
    -- Increment tie-breaker index.
    callback_idx = callback_idx + 1
  end

  return key
end

return gen_fn_key
