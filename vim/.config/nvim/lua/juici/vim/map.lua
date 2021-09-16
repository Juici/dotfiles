juici.g.map_callbacks = {}

local function map(mode, lhs, rhs, opts)
  opts = opts or {}

  -- Verify `rhs` type and convert to function callback if necessary.
  do
    local rhs_type = type(rhs)
    if rhs_type == 'function' then
      local key = juici.util.gen_fn_key(rhs, juici.g.map_callbacks)
      juici.g.map_callbacks[key] = rhs
      rhs = 'v:lua.juici.g.map_callbacks.' .. key .. '()'
    elseif rhs_type ~= "string" then
      error('unsupported rhs type: ' .. rhs_type)
    end
  end

  local buffer = opts.buffer
  opts.buffer = nil
  if buffer == true then
    vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, opts)
  else
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
  end

  return {
    dispose = function()
      if buffer == true then
        vim.api.nvim_buf_del_keymap(0, mode, lhs)
      else
        vim.api.nvim_del_keymap(mode, lhs)
      end
      juici.g.map_callbacks[key] = nil
    end
  }
end

return map
