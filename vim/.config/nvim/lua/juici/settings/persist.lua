local path = require('vfs.path')
local fs = require('vfs.fs')

local opt = vim.opt

local tmp_dir = path.join(juici.g.vim_dir, 'tmp')

--------------------------------------------------
-- Backup files
--------------------------------------------------

opt.backup = false      -- Don't make backups before writing.
opt.writebackup = false -- Don't keep backups after writing.

opt.backupdir = {
  path.join(tmp_dir, 'backup'), -- Keep backup files out of the way (if `backup` is ever set).
  '.',                          -- Fallback.
}

--------------------------------------------------
-- Swap files
--------------------------------------------------

opt.swapfile = false  -- Don't create swap files.
opt.updatecount = 0   -- Don't create swap files.

opt.directory = {
  path.join(tmp_dir, 'swap'), -- Keep swap files out of the way (if `swapfile` is ever set).
  '.',                        -- Fallback.
}

-- Update swap files every 300ms if nothing is typed.
--
-- Note: This is also used for the `CursorHold` and `CursorHoldI` autocommands.
--       A longer `updatetime` leads to noticable delays and degrades the user
--       experience.
opt.updatetime = 300

--------------------------------------------------
-- Undo files
--------------------------------------------------

if juici.g.is_root then
  opt.undofile = false  -- Don't create root-owned temporary files.
else
  opt.undofile = true   -- Enable persistent undo files.

  opt.undodir = {
    path.join(tmp_dir, 'undo'), -- Keep undo files out of the way.
    '.',                        -- Fallback.
  }
end

--------------------------------------------------
-- Shada
--------------------------------------------------

if juici.g.is_root then
  opt.shada = ''          -- Don't create root owned temporary files.
  opt.shadafile = 'NONE'  -- Don't create root owned temporary files.
else
  local shada_file = path.join(tmp_dir, 'shada')

  --[[

  Default: !,'100,<50,s10,h

  - ! save/restore global variables (only all-uppercase variables)
  - '100 save/restore marks from last 100 files
  - <50 save/restore 50 lines from each register
  - s10 max item size 10KB
  - h do not save/restore 'hlsearch' setting

  --]]
  opt.shada = {
    '\'0',              -- Don't remember files with file marks.
    '<0',               -- Don't save registers.
    'f0',               -- Don't store file marks.
    'n' .. shada_file,  -- Keep shada file out of the way.
  }

  if fs.is_file(shada_file) and not fs.is_readable(shada_file) then
    juici.log.warn('shada file exists but is not readable: ' .. shada_file)
  end
end

--------------------------------------------------
-- Sessions
--------------------------------------------------

-- Keep view files out of the way.
opt.viewdir = path.join(tmp_dir, 'view')

-- Save/Restore only these options (with `:{mk,load}view`).
opt.viewoptions = {
  'cursor',
  'folds',
}
