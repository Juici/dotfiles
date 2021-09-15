local path = {}

if package.config:sub(1, 1) == '/' then
  path = require('juici.path.posix')
else
  path = require('juici.path.windows')
end

-- Checks if the path is relative.
function path.isrelative(p)
  return not path.isabsolute(p)
end

-- Resolves symlinks and normalises the path.
function path.realpath(p)
  p = vim.fn.resolve(p)
  return path.normalize(p)
end

return path
