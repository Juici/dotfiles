local log = {}

-- Logs info message.
function log.info(msg)
  vim.api.nvim_echo({{ msg }}, true, {})
end

-- Logs warning message.
function log.warn(msg)
  vim.api.nvim_echo({{ msg, 'WarningMsg' }}, true, {})
end

-- Logs error message.
function log.err(msg)
  vim.api.nvim_echo({{ msg, 'ErrorMsg' }}, true, {})
end

return log
