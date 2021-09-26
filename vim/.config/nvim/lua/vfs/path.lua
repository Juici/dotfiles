local os = require('vfs.os')

-- Character byte values.
local CHAR_FORWARD_SLASH = string.byte('/')
local CHAR_BACKWARD_SLASH = string.byte('\\')
local CHAR_DOT = string.byte('.')
local CHAR_UPPERCASE_A = string.byte('A')
local CHAR_UPPERCASE_Z = string.byte('Z')
local CHAR_LOWERCASE_A = string.byte('a')
local CHAR_LOWERCASE_Z = string.byte('z')

local is_win32 = (function()
  if jit then
    return jit.os == 'Windows'
  else
    return package.config:sub(1, 1):byte() == CHAR_BACKWARD_SLASH
  end
end)()

local function is_sep(b)
  return b == CHAR_FORWARD_SLASH or b == CHAR_BACKWARD_SLASH
end

local function is_posix_sep(b)
  return b == CHAR_FORWARD_SLASH
end

local function is_win32_device_root(b)
  return (CHAR_UPPERCASE_A <= b and b <= CHAR_UPPERCASE_Z)
      or (CHAR_LOWERCASE_A <= b and b <= CHAR_LOWERCASE_Z)
end

--- Resolves '.' and '..' components in a path. Also skips repeated slashes.
---
--- The returned path will not begin with a separator, regardless of whether the
--- given path was absolute.
local function normalizeString(path, allow_above_root, sep, is_sep)
  local comps = {}
  local last_slash = 0
  local dots = 0
  local code

  for i = 1, #path + 1 do
    if i <= #path then
      code = path:byte(i)
    elseif is_sep(code) then
      break
    else
      code = CHAR_FORWARD_SLASH
    end

    if is_sep(code) then
      -- At a seperator, handle component.

      if last_slash == i - 1 or dots == 1 then
        -- Skip repeated slashes and current dir components.
        goto skip
      end

      if dots == 2 then
        -- Parent directory component.
        if comps[#comps] ~= '..' then
          table.remove(comps)

          last_slash = i
          dots = 0

          goto continue
        end

        if allow_above_root then
          table.insert(comps, '..')
        end
      else
        -- Regular path component.
        table.insert(comps, path:sub(last_slash + 1, i - 1))
      end

      ::skip::

      last_slash = i
      dots = 0
    elseif code == CHAR_DOT and dots ~= -1 then
      dots = dots + 1
    else
      dots = -1
    end

    ::continue::
  end

  return table.concat(comps, sep)
end

---@class ParsedPath
---@field public root string
---@field public dir string
---@field public file string
---@field public stem string
---@field public ext string

--------------------------------------------------
-- Windows
--------------------------------------------------

local win32 = {
  sep = '\\',
  delimiter = ';',
}

-- TODO: Windows paths.

--------------------------------------------------
-- Posix
--------------------------------------------------

local posix_cwd = (function()
  if is_win32 then
    -- Converts Windows backslash path separators to POSIX forward slashes and
    -- truncates any drive indicator.
    return function()
      local cwd = os.getcwd():gsub('\\', '/')
      local first_slash = cwd:find('/', 1, true)
      return cwd:sub(first_slash)
    end
  else
    -- Already on POSIX, no need for transformations.
    return os.getcwd
  end
end)()

-- TODO
local posix = {
  sep = '/',
  delimiter = ':',
}

--- Resolves a sequence of paths or components into a normalized absolute path.
---
---@vararg string
---@return string
function posix.resolve(...)
  local n_args = select('#', ...)

  local comps = {}
  local resolved_absolute = false

  -- Iterate from back to save time when args contains an absolute path.
  for i = n_args, 0, -1 do
    if resolved_absolute then
      break
    end

    local comp
    if i > 0 then
      comp = select(i, ...)
    else
      comp = posix_cwd()
    end

    vim.validate {
      path = { comp, 'string' },
    }

    -- Only add non-empty components.
    if #comp > 0 then
      table.insert(comps, 1, comp)

      resolved_absolute = comp:byte(1) == CHAR_FORWARD_SLASH
    end
  end

  -- Join path components.
  local path = table.concat(comps, '/')

  -- At this point the path should be an absolute path, but handle relative
  -- paths to be safe (in the case that `getcwd` fails).

  path = normalizeString(path, not resolved_absolute, '/', is_posix_sep)

  if resolved_absolute then
    return '/' .. path
  end

  if #path > 0 then
    return path
  else
    return '.'
  end
end

--- Normalizes the given path, resolving '.' and '..' components.
---
--- When multiple, sequential separator characters are found, they are replaced
--- with a single instance of the platform-specific separator.
---
--- If the path is empty, then '.' is returned, representing the current working
--- directory.
---
---@param path string
---@return string
function posix.normalize(path)
  vim.validate {
    path = { path, 'string' },
  }

  if #path == 0 then
    return '.'
  end

  local is_absolute = path:byte(1) == CHAR_FORWARD_SLASH

  -- Normalize the path.
  path = normalizeString(path, not is_absolute, '/', is_posix_sep)

  if #path == 0 then
    if is_absolute then
      return '/'
    else
      return '.'
    end
  end

  if is_absolute then
    return '/' .. path
  else
    return path
  end
end

--- Returns `true` if the given path is an absolute path.
---
---@param path string
---@return boolean
function posix.is_absolute(path)
  vim.validate {
    path = { path, 'string' },
  }
  return #path > 0 and path:byte(1) == CHAR_FORWARD_SLASH
end

--- Joins the given components using the platform-specific separator, then
--- normalizes the result.
---
--- Empty components are ignored. If the joined path is empty, then '.' will be
--- returned, representing the current working directory.
---
---@vararg string
---@return string
function posix.join(...)
  local n_args = select('#', ...)
  if n_args == 0 then
    return '.'
  end

  local comps = {}
  for i = 1, n_args do
    local arg = select(i, ...)

    vim.validate {
      path = { arg, 'string' },
    }

    if #arg > 0 then
      table.insert(comps, arg)
    end
  end

  if #comps == 0 then
    return '.'
  end

  local path = table.concat(comps, '/')
  return posix.normalize(path)
end

--- Returns the relative path from `from` to `to`, based on the current working
--- directory.
---
--- If `from` and `to` both resolve to the same path, then an empty string is
--- returned. If an empty string is passed as `from` or `to`, the current
--- working directory will be used instead of the empty string.
---
---@param from string
---@param to string
---@return string
function posix.relative(from, to)
  vim.validate {
    from = { from, 'string' },
    to = { to, 'string' },
  }

  if from == to then
    return ''
  end

  -- Resolve as absolute normalized paths.
  from = posix.resolve(from)
  to = posix.resolve(to)

  if from == to then
    return ''
  end

  local from_start = 2
  local from_end = #from
  local from_len = from_end - 1

  local to_start = 2
  local to_len = #to - 1

  local len
  if from_len < to_len then
    len = from_len
  else
    len = to_len
  end

  -- Compare the paths to find the longest common path from the root.
  local last_common_sep = -1
  local i = 0
  while i < len do
    local from_code = from:byte(from_start + i)
    if from_code ~= to:byte(to_start + i) then
      break
    elseif from_code == CHAR_FORWARD_SLASH then
      last_common_sep = i
    end

    i = i + 1
  end

  if i == len then
    if to_len > len then
      if to:byte(to_start + i) == CHAR_FORWARD_SLASH then
        -- We get here if `from` is the exact base path for `to`.
        -- eg. from = '/foo/bar', to = '/foo/bar/baz'.
        return to:sub(to_start + i + 1)
      elseif i == 0 then
        -- We get here if `from` is the root.
        -- eg. from = '/', to = '/foo/bar'.
        return to:sub(to_start)
      end
    elseif from_len > len then
      if from:byte(from_start + i) == CHAR_FORWARD_SLASH then
        -- We get here if `to` is the exact base path for `from`.
        -- eg. from = '/foo/bar/baz', to = '/foo/bar'.
        last_common_sep = i
      elseif i == 0 then
        -- We get here if `to` is the root.
        -- eg. from = '/foo/bar', to = '/'.
        last_common_sep = 0
      end
    end
  end

  local base = {}
  for i = from_start + last_common_sep + 1, from_end do
    if i == from_end or from:byte(i) == CHAR_FORWARD_SLASH then
      table.insert(base, '..')
    end
  end
  base = table.concat(base, '/')

  return base .. to:sub(to_start + last_common_sep)
end

--- Returns the parent directory of the given path, similar to the Unix
--- `dirname`.
---
--- Trailing separators are ignored. This function is ignorant to the underlying
--- filesystem and will not take into account relative paths or symbolic links.
---
---@param path string
---@return string
function posix.parent(path)
  vim.validate {
    path = { path, 'string' }
  }

  local is_absolute = path:byte(1) == CHAR_FORWARD_SLASH

  local p_end = -1
  local skip_slash = true

  for i = #path, 2, -1 do
    if path:byte(i) == CHAR_FORWARD_SLASH then
      if not skip_slash then
        p_end = i - 1
        break
      end
    else
      -- We saw the first non-separator.
      skip_slash = false
    end
  end

  if p_end == -1 then
    if is_absolute then
      return '/'
    else
      return '.'
    end
  end

  if is_absolute and p_end == 1 then
    return '//'
  end

  return path:sub(1, p_end)
end

function posix.file_name(path)
  vim.validate {
    path = { path, 'string' },
  }

  local p_start = 1
  local p_end = -1
  local skip_slash = true

  for i = #path, 1, -1 do
    if path:byte(i) == CHAR_FORWARD_SLASH then
      if not skip_slash then
        p_start = i + 1
        break
      end
    elseif p_end == -1 then
      -- We saw the first non-separator, mark this as the end of the file name.
      skip_slash = false
      p_end = i
    end
  end

  -- No file component.
  if p_end == -1 then
    return ''
  end

  return path:sub(p_start, p_end)
end

function posix.file_stem(path)
  vim.validate {
    path = { path, 'string' },
  }

  local p_start = 1
  local p_dot = -1
  local p_end = -1
  local skip_slash = true

  -- Track the state of characters we see before the first dot and after any
  -- separator we find.
  local state = 0

  for i = #path, 1, -1 do
    local code = path:byte(i)

    if code == CHAR_FORWARD_SLASH then
      if not skip_slash then
        p_start = i + 1
        break
      end
    elseif p_end == -1 then
      -- We saw the first non-separator, mark this as the end of the file name.
      skip_slash = false
      p_end = i
    end

    if code == CHAR_DOT then
      -- If this is the first dot we've seen, mark it as the start of the
      -- extension.
      if p_dot == -1 then
        p_dot = i
      elseif state ~= 1 then
        state = 1
      end
    elseif p_dot ~= -1 then
      -- We saw a non-dot and non-separator before the dot, so there is a good
      -- chance at having a non-empty extension.
      state = -1
    end
  end

  -- No file component.
  if p_end == -1 then
    return ''
  end

  if p_dot == -1
      -- We saw a non-dot character immediately before the dot.
      or state == 0
      -- The (right-most) trimmed component is exactly '..'.
      or (state == 1
          and p_dot == p_end
          and p_dot == p_start + 1) then
    return path:sub(p_start, p_end)
  else
    return path:sub(p_start, p_dot - 1)
  end
end

--- Returns the extension of the path, from the last occurrence of the '.'
--- character to the end of the string in the last component of the path.
---
--- If there is no '.' in the last component of the path, or if there are no '.'
--- characters other than the first character of the file name, then an empty
--- string is returned.
---
---@param path string
---@return string
function posix.extension(path)
  vim.validate {
    path = { path, 'string' },
  }

  local p_start = 1
  local p_dot = -1
  local p_end = -1
  local skip_slash = true

  -- Track the state of characters we see before the first dot and after any
  -- separator we find.
  local state = 0

  for i = #path, 1, -1 do
    local code = path:byte(i)

    if code == CHAR_FORWARD_SLASH then
      if not skip_slash then
        p_start = i + 1
        break
      end
    elseif p_end == -1 then
      -- We saw the first non-separator, mark this as the end of the file name.
      skip_slash = false
      p_end = i
    end

    if code == CHAR_DOT then
      -- If this is the first dot we've seen, mark it as the start of the
      -- extension.
      if p_dot == -1 then
        p_dot = i
      elseif state ~= 1 then
        state = 1
      end
    elseif p_dot ~= -1 then
      -- We saw a non-dot and non-separator before the dot, so there is a good
      -- chance at having a non-empty extension.
      state = -1
    end
  end

  if p_dot == -1 or p_end == -1
      -- We saw a non-dot character immediately before the dot.
      or state == 0
      -- The (right-most) trimmed component is exactly '..'.
      or (state == 1
          and p_dot == p_end
          and p_dot == p_start + 1) then
    return ''
  end

  return path:sub(p_dot, p_end)
end

--- Returns a table with entries for the significant components of the given
--- path.
---
---@param path string
---@return ParsedPath
function posix.parse(path)
  vim.validate {
    path = { path, 'string' },
  }

  local parsed = {
    root = '',
    dir = '',
    file = '',
    stem = '',
    ext = '',
  }

  local is_absolute = path:byte(1) == CHAR_FORWARD_SLASH
  local p_start
  if is_absolute then
    parsed.root = '/'
    p_start = 2
  else
    p_start = 1
  end

  local p_file = 1
  local p_dot = -1
  local p_end = -1
  local skip_slash = true

  -- Track the state of characters we see before the first dot and after any
  -- separator we find.
  local state = 0

  for i = #path, p_start, -1 do
    local code = path:byte(i)

    if code == CHAR_FORWARD_SLASH then
      if not skip_slash then
        p_file = i + 1
        break
      end
    elseif p_end == -1 then
      -- We saw the first non-separator, mark this as the end of the file name.
      skip_slash = false
      p_end = i
    end

    if code == CHAR_DOT then
      -- If this is the first dot we've seen, mark it as the start of the
      -- extension.
      if p_dot == -1 then
        p_dot = i
      elseif state ~= 1 then
        state = 1
      end
    elseif p_dot ~= -1 then
      -- We saw a non-dot and non-separator before the dot, so there is a good
      -- chance at having a non-empty extension.
      state = -1
    end
  end

  if p_end ~= -1 then
    if p_file > 1 then
      p_start = p_file
    end

    parsed.file = path:sub(p_start, p_end)

    if p_dot == -1
        -- We saw a non-dot character immediately before the dot.
        or state == 0
        -- The (right-most) trimmed component is exactly '..'.
        or (state == 1
            and p_dot == p_end
            and p_dot == p_file + 1) then
      parsed.stem = parsed.file
    else
      parsed.stem = path:sub(p_start, p_dot - 1)
      parsed.ext = path:sub(p_dot, p_end)
    end
  end

  if p_file > 1 then
    parsed.dir = path:sub(1, p_file - 2)
  elseif is_absolute then
    parsed.dir = '/'
  end

  return parsed
end

--------------------------------------------------
-- Module
--------------------------------------------------

win32.win32 = win32
win32.posix = posix

posix.win32 = win32
posix.posix = posix

if is_win32 then
  return win32
else
  return posix
end
