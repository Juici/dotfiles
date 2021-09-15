local opt = vim.opt

--------------------------------------------------
-- General
--------------------------------------------------

opt.lazyredraw = true     -- Don't bother updating screen during macro playback.
opt.cursorline = false    -- Don't highlight current line.
opt.showmatch = true      -- Show matching brackets, etc.
opt.linebreak = true      -- Wrap long lines at characters in `breakat`.
opt.inccommand = 'split'  -- Live preview of substitution results.

opt.laststatus = 2        -- Always show status line.
opt.cmdheight = 2         -- Set command bar height, with space for longer messages.

opt.pumblend = 10         -- Pseudo-transparency for popup-menu.
opt.winblend = 10         -- Pseudo-transparency for floating windows.

if not juici.g.is_linux_console then
  -- Use guifg/guibg instead of ctermfg/ctermbg in terminal.
  opt.termguicolors = true
end

--------------------------------------------------
-- Gutter
--------------------------------------------------

opt.number = true         -- Show line numbers.
opt.relativenumber = true -- Show relative line numbers in gutter.
opt.signcolumn = 'number' -- Merge signcolumn with line number column.

--------------------------------------------------
-- Fill chars and folding
--------------------------------------------------

opt.fillchars = {
  vert = '│',       -- BOX DRAWINGS LIGHT VERTICAL (U+2502).
  fold = '·',       -- MIDDLE DOT (U+00B7).
  diff = '·',       -- MIDDLE DOT (U+00B7).

  -- Suppress ~ at EndOfBuffer.
  eob = ' ',        -- SPACE (U+0020).
}

opt.foldmethod = 'marker'               -- Fold based on markers.
opt.foldcolumn = '1'                    -- Fold column size.
opt.foldtext = 'v:lua.juici.foldtext()' -- Custom fold text formatting.

opt.diffopt:append('foldcolumn:0')      -- Don't show folds in diff view.

--------------------------------------------------
-- Whitespace
--------------------------------------------------

opt.list = true -- Show whitespace.

do
  local listchars = {
    nbsp = '⊘',     -- CIRCLED DIVISION SLASH (U+2298).
    tab = '·',     -- TRIANGLE RIGHT (U+F44A) + MIDDLE DOT (U+00B7).
    extends = '»',  -- RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00BB).
    precedes = '«', -- LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00AB).
    trail = '•',    -- BULLET (U+2022).
  }

  if juici.g.is_linux_console then
    listchars.nbsp = '°'   -- DEGREE SIGN (U+00B0).
    listchars.tab = '>·'   -- GREATER-THAN SIGN (U+003E) + MIDDLE DOT (U+00B7).
  end

  opt.listchars = listchars
end

if juici.g.is_linux_console then
  opt.showbreak = '↳ ' -- DOWNWARDS ARROW WITH TIP RIGHTWARDS (U+21B3) + SPACE (U+0020).
end

--------------------------------------------------
-- Messages
--------------------------------------------------

opt.shortmess:append({
  A = true, -- Ignore annoying swapfile messages.
  I = true, -- No splash screen.
  O = true, -- File-read message overwrites previous.
  T = true, -- Truncate non-file messages in middle.
  W = true, -- Don't echo '[w]'/'[written]' when writing a file.
  a = true, -- Abbreviated messages (eg. '[RO]' instead of '[readonly]').
  c = true, -- Completion messages.
  o = true, -- Overwrite file-written messages.
  t = true, -- Truncate file messages at start.
})

--------------------------------------------------
-- Cursor
--------------------------------------------------

opt.guicursor = {
  'a:blinkon0-Cursor/lCursor',  -- Disable blinking and set colour.
  'n-v-c:block',                -- Normal mode.
  'i-ci-ve:ver25',              -- Insert mode.
  'r-cr:hor20',                 -- Replace mode.
  'o:hor50',                    -- Operator-pending mode.
}
