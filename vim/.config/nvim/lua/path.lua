local path = {}

local DIR_SEP = package.config:sub(1, 1)

path.sep = DIR_SEP

local function last_sep(p)
  for i = p:len(), 1, -1 do
    if p:sub(i, i) == DIR_SEP then
      return i
    end
  end
  return 0
end

-- Returns the directory component and file component of the path.
local function split(p)
  local len = p:len()

  -- Remove trailing `/` characters if path is not a single `/`.
  while len > 1 and p:sub(len, len) == DIR_SEP do
    len = len - 1
  end
  p = p:sub(1, len)

  -- Check if path is just a single `/`.
  if p == DIR_SEP then
    return '/', '/'
  end

  -- Search for last index of `/`.
  for i = len, 1, -1 do
    -- If we find a `/`, then the dir is the path up to the last `/` and the
    -- file is the content following the last `/`.
    if p:sub(i, i) == DIR_SEP then
      return p:sub(1, math.max(i - 1, 1)), p:sub(i + 1)
    end
  end

  -- If there is no separator then the whole path is the file name.
  return '.', p
end

-- Returns the directory component of a path.
function path.dirname(p)
  local dir, _ = split(p)
  return dir
end

-- Returns the file component of a path.
function path.filename(p)
  local _, file = split(p)
  return file
end

function path.ancestors(p)
  -- Remove trailing `/` characters if path is not a single `/`.
  do
    local len = p:len()
    while len > 1 and p:sub(len, len) == DIR_SEP do
      len = len - 1
    end
    p = p:sub(1, len)
  end

  return coroutine.wrap(function()
    while p:len() > 0 do
      -- Check if path is just a single `/`.
      if p == DIR_SEP then
        coroutine.yield('/')
        break
      end

      coroutine.yield(p)

      local sep = last_sep(p)
      if sep == 0 then
        break
      else
        p = p:sub(1, math.max(sep - 1, 1))
      end
    end
  end)
end

function path.normalize(p)
  -- TODO
  return vim.fn.fnamemodify(p, ':p')
end

function path.realpath(p)
  -- TODO
  return vim.loop.fs_realpath(p)
end

return path
