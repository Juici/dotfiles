local path = {}

function path.dirname(p)
  return vim.fn.fnamemodify(p, ':h')
end

return path
