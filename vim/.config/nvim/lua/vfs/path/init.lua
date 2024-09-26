local process = require('vfs.process')

-- Character byte values.
local CHAR_FORWARD_SLASH = string.byte('/')
local CHAR_BACKWARD_SLASH = string.byte('\\')
local CHAR_DOT = string.byte('.')
local CHAR_COLON = string.byte(':')
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
local function normalize_string(path, allow_above_root, sep, is_sep)
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

--- Returns `true` if the given path is an absolute path.
---
---@param path string
---@return boolean
function win32.is_absolute(path)
  vim.validate {
    path = { path, 'string' },
  }

  local len = #path
  if len == 0 then
    return false
  end

  local code = path:byte(1)
  return is_sep(code)
      -- Possible device root.
      or (len > 2
          and is_win32_device_root(code)
          and path:byte(2) == CHAR_COLON
          and is_sep(path:byte(3)))
end

--- Resolves a sequence of paths or components into a normalized absolute path.
---
--- Empty components are ignored.
---
---@vararg string
---@return string
function win32.resolve(...)
  local n_args = select('#', ...)

  local resolved_device = ''
  local resolved_tail = ''
  local resolved_absolute = false

  for i = n_args, 0, -1 do
    local comp
    if i > 0 then
      comp = select(i, ...)

      vim.validate {
        path = { comp, 'string' },
      }

      if #comp == 0 then
        goto continue
      end
    elseif #resolved_device == 0 then
      comp = process.cwd()
    else
      -- Windows has the concept of drive-specific current working directories.
      -- If we've resolved a drive letter but not yet an absolute path, get cwd
      -- for that drive, or the process cwd if the drive cwd is not available.
      -- We're sure the device is not a UNC path at this points, because UNC
      -- paths are always absolute.
      comp = process.env['=' .. resolved_device]
      if comp == nil then
        comp = process.cwd()
      end

      -- Verify that a cwd was found and that it actually points to our drive.
      -- If not, default to the drive's root.
      if comp == nil
          or (comp:sub(1, 2):lower() ~= resolved_device:lower()
              and comp:byte(3) == CHAR_BACKWARD_SLASH) then
        comp = resolved_device .. '\\'
      end
    end

    local len = #comp
    local root_end = 0
    local device = ''
    local is_absolute = false

    local code = comp:byte(1)

    -- Try to match a root.
    if len == 1 then
      if is_sep(code) then
        -- `code` contains just a separator.
        root_end = 1
        is_absolute = true
      end
    elseif is_sep(code) then
      -- Possible UNC root.

      -- If we started with a separator, then we at least have an absolute path
      -- of some kind (UNC or otherwise).
      is_absolute = true

      if is_sep(comp:byte(2)) then
        -- Matched double separator at the beginning.
        local j = 3
        local last = j

        -- Match 1 or more non-separators.
        while j <= len and not is_sep(comp:byte(j)) do
          j = j + 1
        end

        if j <= len and j ~= last then
          local first_part = comp:sub(last, j - 1)
          -- Matched.
          last = j

          -- Match 1 or more separators.
          while j <= len and is_sep(comp:byte(j)) do
            j = j + 1
          end

          if j <= len and j ~= last then
            -- Matched.
            last = j

            -- Match 1 or more non-separators.
            while j <= len and not is_sep(comp:byte(j)) do
              j = j + 1
            end

            if j >= len or j ~= last then
              device = '\\\\' .. first_part .. '\\' .. comp:sub(last, j - 1)
              root_end = j - 1
            end
          end
        end
      else
        root_end = 1
      end
    elseif is_win32_device_root(code) and comp:byte(2) == CHAR_COLON then
      -- Possible device root.
      device = comp:sub(1, 2)
      root_end = 2

      if len > 2 and is_sep(comp:byte(3)) then
        -- Treat separator following drive name as an absolute path indictator.
        is_absolute = true
        root_end = 3
      end
    end

    if #device > 0 then
      if #resolved_device > 0 then
        if device:lower() ~= resolved_device:lower() then
          -- This path points to another device so it is not applicable.
          goto continue
        end
      else
        resolved_device = device
      end
    end

    if resolved_absolute then
      if #resolved_device > 0 then
        break
      end
    else
      resolved_tail = comp:sub(root_end + 1) .. '\\' .. resolved_tail
      resolved_absolute = is_absolute
      if is_absolute and #resolved_device > 0 then
        break
      end
    end

    ::continue::
  end

  -- At this point the path should be resolved to a full absolute path, but
  -- handle relative paths to be safe (in the case that `process.cwd()` fails).

  -- Normalise the tail path.
  resolved_tail = normalize_string(resolved_tail, not resolved_absolute, '\\', is_sep)

  if resolved_absolute then
    return resolved_device .. '\\' .. resolved_tail
  end

  local path = resolved_device .. resolved_tail
  if #path == 0 then
    path = '.'
  end
  return path
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
function win32.normalize(path)
  vim.validate {
    path = { path, 'string' },
  }

  local len = #path
  if len == 0 then
    return '.'
  end

  local root_end = 0
  local device
  local is_absolute = false

  local code = path:byte(1)

  -- Try to match a root.
  if len == 1 then
    -- `path` is just a single character, exit early to avoid unnecessary work.
    if is_posix_sep(code) then
      return '\\'
    else
      return path
    end
  end

  if is_sep(code) then
    -- Possible UNC root.

    -- If we started with a separator, then we at least have an absolute path
    -- of some kind (UNC or otherwise).
    is_absolute = true

    if is_sep(path:byte(2)) then
      -- Matched double separator at the beginning.
      local j = 3
      local last = j

      -- Match 1 or more non-separators.
      while j <= len and not is_sep(path:byte(j)) do
        j = j + 1
      end

      if j <= len and j ~= last then
        local first_part = path:sub(last, j - 1)
        -- Matched.
        last = j

        -- Match 1 or more separators.
        while j <= len and is_sep(path:byte(j)) do
          j = j + 1
        end

        if j <= len and j ~= last then
          -- Matched.
          last = j

          -- Match 1 or more non-separators.
          while j <= len and not is_sep(path:byte(j)) do
            j = j + 1
          end

          if j >= len then
            -- We matched a UNC root only.
            -- Return the normalised UNC root, since there is nothing left to
            -- process.
            return '\\\\' .. first_part .. '\\' .. path:sub(last) .. '\\'
          end

          if j ~= last then
            -- We matched a UNC root with leftovers.
            device = '\\\\' .. first_part .. '\\' .. path:sub(last, j - 1)
            root_end = j - 1
          end
        end
      end
    else
      root_end = 1
    end
  elseif is_win32_device_root(code) and path:byte(2) == CHAR_COLON then
    -- Possible device root.
    device = path:sub(1, 2)
    root_end = 2

    if len > 2 and is_sep(path:byte(3)) then
      -- Treat separator following drive name as an absolute path indictator.
      is_absolute = true
      root_end = 3
    end
  end

  local tail = ''
  if root_end < len then
    tail = normalize_string(path:sub(root_end + 1), not is_absolute, '\\', is_sep)
  end

  if is_absolute then
    tail = '\\' .. tail
  elseif #tail == 0 then
    tail = '.'
  end

  if device ~= nil then
    return device .. tail
  else
    return tail
  end
end

--- Joins the given components using the platform-specific separator, then
--- normalizes the result.
---
--- Empty components are ignored. If the joined path is empty, then '.' will be
--- returned, representing the current working directory.
---
---@vararg string
---@return string
function win32.join(...)
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

  local path = table.concat(comps, '\\')

  -- Make sure the joined path doesn't start with 2 slashes, because
  -- `win32.normalize()` will mistake it for a UNC path.
  --
  -- This step is skipped when it is clear that the user intended to point at a
  -- UNC path. This is assumed when the first non-empty string argument starts
  -- with exactly 2 slashes, followed by at least 1 more non-slash character.
  --
  -- Note that for `win32.normalize()` to treat a path as a UNC path, it needs to
  -- have at least 2 components, so we don't filter for that here. This means
  -- that a user can use `win32.join()` to construct UNC paths from a server
  -- name and share name.
  -- eg. `path.join('//server', 'share')` -> '\\\\server\\share'
  local first_part = comps[1]

  local needs_replace = true
  local slash_count = 0

  if is_sep(first_part:byte(1)) then
    slash_count = slash_count + 1

    local first_len = #first_part
    if first_len > 1 and is_sep(first_part:byte(2)) then
      slash_count = slash_count + 1

      if first_len > 2 and is_sep(first_part:byte(3)) then
        slash_count = slash_count + 1
      else
        -- We matched a UNC path in the first part.
        needs_replace = false
      end
    end
  end

  if needs_replace then
    -- Find any more consecutive slashes we need to replace.
    local len = #path
    while slash_count < len and is_sep(path:byte(slash_count + 1)) do
      slash_count = slash_count + 1
    end

    -- Slice off slashes if needed.
    if slash_count >= 2 then
      -- This has the effect of removing leading slashes and add 1 leading
      -- slash.
      path = path:sub(slash_count)
    end
  end

  return win32.normalize(path)
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
function win32.relative(from, to)
  vim.validate {
    from = { from, 'string' },
    to = { to, 'string' },
  }

  if from == to then
    return ''
  end

  -- Resolve as absolute normalized paths.
  local from_orig = win32.resolve(from)
  local to_orig = win32.resolve(to)

  if from_orig == to_orig then
    return ''
  end

  -- Compare case-insensitively.
  from = from_orig:lower()
  to = to_orig:lower()

  if from == to then
    return ''
  end

  local from_len = #from
  -- Trim any leading backslashes.
  local from_start = 1
  while from_start < from_len and from:byte(from_start) == CHAR_BACKWARD_SLASH do
    from_start = from_start + 1
  end
  -- Trim trailing backslashes (applicable to UNC paths only).
  local from_end = from_len
  while from_start < from_end and from:byte(from_end) == CHAR_BACKWARD_SLASH do
    from_end = from_end - 1
  end
  from_len = from_end - from_start + 1

  local to_len = #to
  -- Trim any leading backslashes.
  local to_start = 1
  while to_start < to_len and to:byte(to_start) == CHAR_BACKWARD_SLASH do
    to_start = to_start + 1
  end
  -- Trim trailing backslashes (applicable to UNC paths only).
  local to_end = to_len
  while to_start < to_end and to:byte(to_end) == CHAR_BACKWARD_SLASH do
    to_end = to_end - 1
  end
  to_len = to_end - to_start + 1

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
    elseif from_code == CHAR_BACKWARD_SLASH then
      last_common_sep = i
    end

    i = i + 1
  end

  if i ~= len then
    if last_common_sep == -1 then
      -- We found a mismatch before the first common path separator was seen, so
      -- return the original `to`.
      return to_orig
    end
  else
    if to_len > len then
      if to:byte(to_start + i) == CHAR_BACKWARD_SLASH then
        -- We get here if `from` is the exact base path for `to`.
        -- eg. from = 'C:\\foo\\bar', to = 'C:\\foo\\bar\\baz'.
        return to:sub(to_start + i + 1)
      elseif i == 2 then
        -- We get here if `from` is the device root.
        -- eg. from = 'C:\\', to = 'C:\\foo\\bar'.
        return to:sub(to_start)
      end
    elseif from_len > len then
      if from:byte(from_start + i) == CHAR_BACKWARD_SLASH then
        -- We get here if `to` is the exact base path for `from`.
        -- eg. from = 'C:\\foo\\bar\\baz', to = 'C:\\foo\\bar'.
        last_common_sep = i
      elseif i == 2 then
        -- We get here if `to` is the device root.
        -- eg. from = 'C:\\foo\\bar', to = 'C:\\'.
        last_common_sep = 3
      end
    end

    if last_common_sep == -1 then
      last_common_sep = 0
    end
  end

  -- Generate the relative path based on the path difference between `to` and
  -- `from`.
  local base = {}
  for i = from_start + last_common_sep + 1, from_end do
    if i == from_end or from:byte(i) == CHAR_BACKWARD_SLASH then
      table.insert(base, '..')
    end
  end
  base = table.concat(base, '\\')

  to_start = to_start + last_common_sep

  -- Lastly append the rest of the `to` path that comes after the common path
  -- parts.
  if #base > 0 then
    return base .. to_orig:sub(to_start, to_end)
  end

  if to_orig:byte(to_start) == CHAR_BACKWARD_SLASH then
    to_start = to_start + 1
  end
  return to_orig:sub(to_start, to_end)
end

--- Returns the parent directory of the given path. Similar to the Unix
--- `dirname`.
---
--- Trailing separators are ignored. This function is ignorant to the underlying
--- filesystem and will not take into account relative paths or symbolic links.
---
---@param path string
---@return string
function win32.parent(path)
  vim.validate {
    path = { path, 'string' }
  }

  local len = #path
  if len == 0 then
    return '.'
  end

  local root_end = 0
  local offset = 1

  local code = path:byte(1)

  if len == 1 then
    if is_sep(code) then
      -- `path` is just a separator, exit early to avoid unnecessary work.
      return path
    else
      -- `path` is a single non-separator character, parent is current working
      -- directory.
      return '.'
    end
  end

  -- Try to match a root.
  if is_sep(code) then
    -- Possible UNC root.
    root_end = 1
    offset = root_end + 1

    if is_sep(path:byte(2)) then
      -- Matched double separator at the beginning.
      local j = 3
      local last = j

      -- Match 1 or more non-separators.
      while j <= len and not is_sep(path:byte(j)) do
        j = j + 1
      end

      if j <= len and j ~= last then
        -- Matched.
        last = j

        -- Match 1 or more separators.
        while j <= len and is_sep(path:byte(j)) do
          j = j + 1
        end

        if j <= len and j ~= last then
          -- Matched.
          last = j

          -- Match 1 or more non-separators.
          while j <= len and not is_sep(path:byte(j)) do
            j = j + 1
          end

          if j >= len then
            -- We matched a UNC root only.
            return path
          end

          if j ~= last then
            -- We matched a UNC root with leftovers.

            -- Offset by 1 to include the separator after the UNC root to treat
            -- it as a "normal root" on top of a UNC root.
            root_end = j
            offset = root_end + 1
          end
        end
      end
    end
  elseif is_win32_device_root(code) and path:byte(2) == CHAR_COLON then
    -- Possible device root.
    if len > 2 and is_sep(path:byte(3)) then
      root_end = 3
    else
      root_end = 2
    end

    offset = root_end + 1
  end

  local p_end = -1
  local skip_slash = true

  for i = len, offset, -1 do
    if is_sep(path:byte(i)) then
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
    if root_end == 0 then
      return '.'
    end
    p_end = root_end
  end

  return path:sub(1, p_end)
end

--- Returns the last portion of the path, with any leading directory components
--- removed. Similar to the Unix `basename`.
---
---@param path string
---@return string
function win32.file_name(path)
  vim.validate {
    path = { path, 'string' },
  }

  local p_start = 1
  local p_end = -1
  local skip_slash = true

  -- Check for a drive letter prefix, so as to not mistake the following
  -- separator as an extra separator at the end of the path that can be
  -- discarded.
  if #path >= 2 and is_win32_device_root(path:byte(1)) and path:byte(2) == CHAR_COLON then
    p_start = 3
  end

  for i = #path, 1, -1 do
    if is_sep(path:byte(i)) then
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

--- Returns the stem (non-extension) portion of the file name.
---
---@param path string
---@return string
---
---@see win32.file_name
function win32.file_stem(path)
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

  -- Check for a drive letter prefix, so as to not mistake the following
  -- separator as an extra separator at the end of the path that can be
  -- discarded.
  if #path >= 2 and is_win32_device_root(path:byte(1)) and path:byte(2) == CHAR_COLON then
    p_start = 3
  end

  for i = #path, p_start, -1 do
    local code = path:byte(i)

    if is_sep(code) then
      if not skip_slash then
        p_start = i + 1
        break
      end
      goto continue
    end

    if p_end == -1 then
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

    ::continue::
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
  end

  return path:sub(p_start, p_dot - 1)
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
function win32.extension(path)
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

  -- Check for a drive letter prefix, so as to not mistake the following
  -- separator as an extra separator at the end of the path that can be
  -- discarded.
  if #path >= 2 and is_win32_device_root(path:byte(1)) and path:byte(2) == CHAR_COLON then
    p_start = 3
  end

  for i = #path, p_start, -1 do
    local code = path:byte(i)

    if is_sep(code) then
      if not skip_slash then
        p_start = i + 1
        break
      end
      goto continue
    end

    if p_end == -1 then
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

    ::continue::
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
function win32.parse(path)
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

  local len = #path
  if len == 0 then
    return parsed
  end

  local code = path:byte(1)

  if len == 1 then
    -- `path` is just a single character, exit early to avoid unnecessary work.
    if is_sep(code) then
      parsed.root = path
      parsed.dir = path
    else
      parsed.file = path
      parsed.stem = path
    end

    return parsed
  end

  local root_end = 0

  -- Try to match a root.
  if is_sep(code) then
    -- Possible UNC root.
    root_end = 1

    if is_sep(path:byte(2)) then
      -- Matched double separator at the beginning.
      local j = 3
      local last = j

      -- Match 1 or more non-separators.
      while j <= len and not is_sep(path:byte(j)) do
        j = j + 1
      end

      if j <= len and j ~= last then
        -- Matched.
        last = j

        -- Match 1 or more separators.
        while j <= len and is_sep(path:byte(j)) do
          j = j + 1
        end

        if j <= len and j ~= last then
          -- Matched.
          last = j

          -- Match 1 or more non-separators.
          while j <= len and not is_sep(path:byte(j)) do
            j = j + 1
          end

          if j >= len then
            -- We matched a UNC root only.
            root_end = len
          elseif j ~= last then
            -- We matched a UNC root with leftovers.
            root_end = j
          end
        end
      end
    end
  elseif is_win32_device_root(code) and path:byte(2) == CHAR_COLON then
    -- Possible device root.
    if len <= 2 then
      -- `path` is just a drive root, exit early to avoid unnecessary work.
      parsed.root = path
      parsed.dir = path
      return parsed
    end

    if is_sep(path:byte(3)) then
      if len == 3 then
        -- `path` is just a drive root, exit early to avoid unnecessary work.
        parsed.root = path
        parsed.dir = path
        return parsed
      end

      root_end = 3
    else
      root_end = 2
    end
  end

  if root_end > 0 then
    parsed.root = path:sub(1, root_end)
  end

  local p_start = root_end + 1
  local p_dot = -1
  local p_end = -1
  local skip_slash = true

  -- Track the state of characters we see before the first dot and after any
  -- separator we find.
  local state = 0

  -- Get non dir info.
  for i = #path, p_start, -1 do
    local code = path:byte(i)

    if is_sep(code) then
      -- If we reached a separator that was not part of the separators at the
      -- end of the string, then stop.
      if not skip_slash then
        p_start = i + 1
        break
      end
      goto continue
    end

    if p_end == -1 then
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

    ::continue::
  end

  if p_end ~= -1 then
    parsed.file = path:sub(p_start, p_end)

    if p_dot == -1
        -- We saw a non-dot character immediately before the dot.
        or state == 0
        -- The (right-most) trimmed component is exactly '..'.
        or (state == 1
            and p_dot == p_end
            and p_dot == p_start + 1) then
      parsed.stem = parsed.file
    else
      parsed.stem = path:sub(p_start, p_dot - 1)
      parsed.ext = path:sub(p_dot, p_end)
    end
  end

  -- If the directory is the root, then use the entire root as the `dir`,
  -- including the trailing slash if any. Otherwise remove the trailing slash.
  if p_start > 1 and p_start ~= root_end + 1 then
    parsed.dir = path:sub(1, p_start - 2)
  else
    parsed.dir = parsed.root
  end

  return parsed
end

--------------------------------------------------
-- Posix
--------------------------------------------------

local posix_cwd = (function()
  if is_win32 then
    -- Converts Windows backslash path separators to POSIX forward slashes and
    -- truncates any drive indicator.
    return function()
      local cwd = process.cwd():gsub('\\', '/')
      local first_slash = cwd:find('/', 1, true)
      return cwd:sub(first_slash)
    end
  else
    -- Already on POSIX, no need for transformations.
    return process.cwd
  end
end)()

local posix = {
  sep = '/',
  delimiter = ':',
}

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

--- Resolves a sequence of paths or components into a normalized absolute path.
---
--- Empty components are ignored.
---
---@vararg string
---@return string
function posix.resolve(...)
  local n_args = select('#', ...)

  local comps = {}
  local is_absolute = false

  -- Iterate from back to save time when args contains an absolute path.
  for i = n_args, 0, -1 do
    if is_absolute then
      break
    end

    local comp
    if i > 0 then
      comp = select(i, ...)

      vim.validate {
        path = { comp, 'string' },
      }
    else
      comp = posix_cwd()
    end

    -- Only add non-empty components.
    if #comp > 0 then
      table.insert(comps, 1, comp)

      is_absolute = comp:byte(1) == CHAR_FORWARD_SLASH
    end
  end

  -- Join path components.
  local path = table.concat(comps, '/')

  -- At this point the path should be an absolute path, but handle relative
  -- paths to be safe (in the case that `process.cwd()` fails).

  path = normalize_string(path, not is_absolute, '/', is_posix_sep)

  if is_absolute then
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
  path = normalize_string(path, not is_absolute, '/', is_posix_sep)

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
  for j = from_start + last_common_sep + 1, from_end do
    if j == from_end or from:byte(j) == CHAR_FORWARD_SLASH then
      table.insert(base, '..')
    end
  end

  return table.concat(base, '/') .. to:sub(to_start + last_common_sep)
end

--- Returns the parent directory of the given path. Similar to the Unix
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

--- Returns the last portion of the path, with any leading directory components
--- removed. Similar to the Unix `basename`.
---
---@param path string
---@return string
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

--- Returns the stem (non-extension) portion of the file name.
---
---@param path string
---@return string
---
---@see posix.file_name
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
  if #path == 0 then
    return parsed
  end

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
