-- Gets the file that calls this function.
local function source_file()
  local src = debug.getinfo(2, 'S').source

  -- If the source a file, it starts with '@'.
  if src:sub(1, 1) == '@' then
    return src:sub(2)
  end

  return nil
end

return source_file
