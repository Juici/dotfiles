if jit then
  return jit.os == 'Windows'
else
  return package.config:sub(1, 1) == '\\'
end
