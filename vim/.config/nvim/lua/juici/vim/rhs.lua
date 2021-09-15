-- Convenience wrapper around `nvim_replace_termcodes(...)`, for use when
-- defining expression mappings.
--
-- Converts the string representation of a mapping RHS into the internal
-- representation (eg. '<Tab>' -> '\t').
local function rhs(s)
  return vim.api.nvim_replace_termcodes(s, true, true, true)
end

return rhs
