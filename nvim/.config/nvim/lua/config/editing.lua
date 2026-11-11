local util = require("juici.util")

--------------------------------------------------
-- Indentation
--------------------------------------------------

do
    local tab_size = 4

    vim.opt.shiftwidth = tab_size -- Spaces per tab, when shifting.
    vim.opt.tabstop = tab_size -- Spaces per tab.
end

if util.is_vi() then
    vim.opt.softtabstop = -1 -- Use `shiftwidth` for <Tab>/<BS> at end of line.
end

vim.opt.expandtab = true -- Use spaces instead of tabs.
vim.opt.smarttab = true -- <Tab>/<BS> through tab sized whitespace.
vim.opt.shiftround = true -- Always indent by a multiple of `shiftwidth`.
vim.opt.autoindent = true -- Maintain indentation of current line.

--------------------------------------------------
-- Line wrapping
--------------------------------------------------

-- Allow unrestricted backspacing in insert mode.
vim.opt.backspace = {
    "indent", -- Allow backspacing over autoindent.
    "eol", -- Allow backspacing over line breaks.
    "nostop", -- Allow backspacing over the start of insert.
}

vim.opt.textwidth = 80 -- Hard wrap at 80 columns.

--------------------------------------------------
-- Formatting
--------------------------------------------------

vim.opt.formatoptions:append({
    n = true, -- Smart auto-indenting in numbered lists.
    j = true, -- Remove comment leader when joining comment lines.
})

--------------------------------------------------
-- Navigation
--------------------------------------------------

-- Set which characters can cross line boundaries.
vim.opt.whichwrap = {
    b = true, -- <BS>    (Normal and Visual)
    s = true, -- <Space> (Normal and Visual)
    h = true, -- 'h'     (Normal and Visual)
    l = true, -- 'l'     (Normal and Visual)
    ["<"] = true, -- <Left>  (Normal and Visual)
    [">"] = true, -- <Right> (Normal and Visual)
    ["["] = true, -- <Left>  (Insert and Replace)
    ["]"] = true, -- <Right> (Insert and Replace)
    ["~"] = true, -- '~'     (Normal)
}

-- Allow cursor to move where there is no text in visual block mode.
vim.opt.virtualedit = "block"

vim.opt.scrolloff = 3 -- Start scrolling 3 lines before edge of viewport.
vim.opt.sidescrolloff = 3 -- Start scrolling 3 columns before edge of viewport.
