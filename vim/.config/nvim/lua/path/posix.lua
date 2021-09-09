local path = {}

local SEP = '/'
local EXT_SEP = '.'
local CUR_DIR = '.'
local PAR_DIR = '..'
local PATH_SEP = ':'

path.sep = SEP
path.extsep = EXT_SEP
path.curdir = CUR_DIR
path.pardir = PAR_DIR
path.pathsep = PATH_SEP

-- Gets the current working directory.
function path.getcwd()
  return vim.loop.cwd()
end

-- Checks if the path exists.
function path.exists(p)
  return vim.loop.fs_stat(p) ~= nil
end

-- Checks if the path is absolute.
function path.isabsolute(p)
  return p:sub(1, 1) == SEP
end

-- Checks if the path is a regular file.
function path.isfile(p)
  local st = vim.loop.fs_stat(p)
  return st ~= nil and st.type == 'file'
end

-- Checks if the path is a directory.
function path.isdir(p)
  local st = vim.loop.fs_stat(p)
  return st ~= nil and st.type == 'directory'
end

-- Checks if the path is a symbolic link.
function path.islink(p)
  local st = vim.loop.fs_lstat(p)
  return st ~= nil and st.type == 'link'
end

-- Joins two or more path components.
function path.join(p, ...)
  local n = select('#', ...)
  for i = 1, n do
    local comp = select(i, ...)
    if vim.startswith(comp, SEP) then
      p = comp
    elseif vim.endswith(p, SEP) then
      p = p .. comp
    else
      p = p .. SEP .. comp
    end
  end
  return p
end

-- Removes trailing '/' characters if path is not a single '/'.
local function strip_trailing_sep(p)
  local len = #p
  while len > 1 and p:sub(len, len) == SEP do
    len = len - 1
  end
  return p:sub(1, len)
end

-- Splits the path into the directory component and file component of the path.
local function split(p)
  p = strip_trailing_sep(p)

  -- Check if path is just a single '/'.
  if p == SEP then
    return SEP, SEP
  end

  -- Search for last index of '/'.
  for i = #p, 1, -1 do
    -- If we find a '/', then the dir is the path up to the last '/' and the
    -- file is the content following the last '/'.
    if p:sub(i, i) == SEP then
      return p:sub(1, math.max(i - 1, 1)), p:sub(i + 1)
    end
  end

  -- If there is no separator then the whole path is the file name.
  return CUR_DIR, p
end

-- Returns the directory component of a path.
function path.parent(p)
  local dir, _ = split(p)
  return dir
end

-- Returns the file component of a path.
function path.filename(p)
  local _, file = split(p)
  return file
end

-- Normalises path components and returns an absolute path.
function path.normalize(p)
  if #p == 0 then
    return path.getcwd()
  end

  if not path.isabsolute(p) then
    p = path.join(path.getcwd(), p)
  end

  local initial_slashes = 0
  if vim.startswith(p, SEP) then
    initial_slashes = 1

    -- POSIX allows one or two initial slashes, but treats three or more as a
    -- single slash.
    -- (see http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap04.html#tag_04_13)
    if vim.startswith(p, SEP:rep(2)) and not vim.startswith(p, SEP:rep(3)) then
      initial_slashes = 2
    end
  end

  local comps = {}
  for comp in vim.gsplit(p, SEP, true) do
    if #comp == 0 or comp == CUR_DIR then
      goto continue
    end

    if comp ~= PAR_DIR or (initial_slashes == 0 and #comps == 0) or (#comps > 0 and comps[#comps] == PAR_DIR) then
      table.insert(comps, comp)
    else
      table.remove(comps)
    end

    ::continue::
  end

  p = table.concat(comps, SEP)
  if initial_slashes > 0 then
    p = SEP:rep(initial_slashes) .. p
  end

  if #p == 0 then
    p = path.getcwd()
  end
  return p
end

return path
