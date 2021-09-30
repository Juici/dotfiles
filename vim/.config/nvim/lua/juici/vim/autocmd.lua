juici.g.autocmd_callbacks = {}

local function string_or_table(v)
  local t = type(v)
  return t == 'string' or t == 'table'
end

local function string_or_function(v)
  local t = type(v)
  return t == 'string' or t == 'function'
end

local function optional_table(v)
  return v == nil or type(v) == 'table'
end

local function autocmd(event, pattern, cmd, opts)
  vim.validate {
    event = { event, string_or_table, 'string or table' },
    pattern = { pattern, string_or_table, 'string or table' },
    cmd = { cmd, string_or_function, 'string or function' },
    opts = { opts, optional_table, 'optional table' },
  }

  opts = opts or {}

  -- If `event` is a list of events then join them into a string.
  if type(event) == 'table' then
    event = table.concat(event, ',')
  end
  -- If `pattern` is a list of patterns then join them into a string.
  if type(event) == 'table' then
    pattern = table.concat(pattern, ',')
  end

  -- Verify `cmd` type and convert to function callback if necessary.
  do
    local cmd_type = type(cmd)
    if cmd_type == 'function' then
      local key = juici.util.gen_fn_key(cmd, juici.g.autocmd_callbacks)
      juici.g.autocmd_callbacks[key] = cmd
      cmd = 'lua juici.g.autocmd_callbacks.' .. key .. '()'
    end
  end

  local args = { 'autocmd', event, pattern }
  if opts.buffer then
    table.insert(args, '<buffer>')
  end
  if opts.once then
    table.insert(args, '++once')
  end
  if opts.nested then
    table.insert(args, '++nested')
  end

  vim.api.nvim_command(table.concat(args, ' '))
end

return autocmd
