local path = {}

if package.config:sub(1, 1) == '/' then
  path = require('path.posix')
else
  path = require('path.windows')
end

-- Returns true if the path is relative.
function path.is_relative(p)
  return not path.is_absolute(p)
end

return path
