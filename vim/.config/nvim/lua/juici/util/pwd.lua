local path = juici.path

-- Gets the path to the current working directory.
--
-- Prefers to use 'PWD' environment variable, to preserve symlinks.
local function pwd()
  local p = os.getenv('PWD')
  if p == nil then
    p = path.getcwd()
  end
  return p
end

return pwd
