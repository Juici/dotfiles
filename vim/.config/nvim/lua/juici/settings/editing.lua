local opt = vim.opt

--------------------------------------------------
-- Indentation
--------------------------------------------------

do
  local tab_size = 4

  opt.shiftwidth = tab_size -- Spaces per tab, when shifting.
  opt.tabstop = tab_size    -- Spaces per tab.
end

if juici.g.is_vi then
  opt.softtabstop = -1  -- Use `shiftwidth` for <Tab>/<BS> at end of line.
end

opt.expandtab = true    -- Use spaces instead of tabs.
opt.smarttab = true     -- <Tab>/<BS> through tab sized whitespace.
opt.shiftround = true   -- Always indent by a multiple of `shiftwidth`.
opt.autoindent = true   -- Maintain indentation of current line.

--------------------------------------------------
-- Line wrapping
--------------------------------------------------

-- Allow unrestricted backspacing in insert mode.
opt.backspace = {
  'indent', -- Allow backspacing over autoindent.
  'eol',    -- Allow backspacing over line breaks.
  'nostop', -- Allow backspacing over the start of insert.
}

opt.textwidth = 80  -- Hard wrap at 80 columns.

--------------------------------------------------
-- Formatting
--------------------------------------------------

opt.formatoptions:append({
  n = true,  -- Smart auto-indenting in numbered lists.
  j = true,  -- Remove comment leader when joining comment lines.
})

--------------------------------------------------
-- Navigation
--------------------------------------------------

-- Set which characters can cross line boundaries.
opt.whichwrap = {
  b = true,     -- <BS>    (Normal and Visual)
  s = true,     -- <Space> (Normal and Visual)
  h = true,     -- 'h'     (Normal and Visual)
  l = true,     -- 'l'     (Normal and Visual)
  ['<'] = true, -- <Left>  (Normal and Visual)
  ['>'] = true, -- <Right> (Normal and Visual)
  ['['] = true, -- <Left>  (Insert and Replace)
  [']'] = true, -- <Right> (Insert and Replace)
  ['~'] = true, -- '~'     (Normal)
}

-- Allow cursor to move where there is no text in visual block mode.
opt.virtualedit = 'block'

opt.scrolloff = 3     -- Start scrolling 3 lines before edge of viewport.
opt.sidescrolloff = 3 -- Start scrolling 3 columns before edge of viewport.
