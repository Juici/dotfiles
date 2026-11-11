local fs = require("juici.fs")
local util = require("juici.util")

local state_dir = vim.fn.stdpath("state")

-- TODO: Clean up files older than 30 days.

--------------------------------------------------
-- Backup files
--------------------------------------------------

vim.opt.backup = false -- Don't make backups before writing.
vim.opt.writebackup = false -- Don't keep backups after writing.

vim.opt.backupdir = {
    vim.fs.joinpath(state_dir, "backup"), -- Keep backup files out of the way (if `backup` is ever set).
    ".", -- Fallback.
}

--------------------------------------------------
-- Swap files
--------------------------------------------------

vim.opt.swapfile = false -- Don't create swap files.
vim.opt.updatecount = 0 -- Don't create swap files.

vim.opt.directory = {
    vim.fs.joinpath(state_dir, "swap"), -- Keep swap files out of the way (if `swapfile` is ever set).
    ".", -- Fallback.
}

-- Update swap files every 300ms if nothing is typed.
--
-- Note: This is also used for the `CursorHold` and `CursorHoldI` autocommands.
--       A longer `updatetime` leads to noticable delays and degrades the user
--       experience.
vim.opt.updatetime = 300

--------------------------------------------------
-- Undo files
--------------------------------------------------

if util.is_root() then
    vim.opt.undofile = false -- Don't create root-owned temporary files.
else
    vim.opt.undofile = true -- Enable persistent undo files.

    vim.opt.undodir = {
        vim.fs.joinpath(state_dir, "undo"), -- Keep undo files out of the way.
        ".", -- Fallback.
    }
end

--------------------------------------------------
-- Shada
--------------------------------------------------

if util.is_root() then
    vim.opt.shada = "" -- Don't create root owned temporary files.
    vim.opt.shadafile = "NONE" -- Don't create root owned temporary files.
else
    local shada_file = vim.fs.joinpath(state_dir, "shada")

    --[[

    Default: !,'100,<50,s10,h

    - ! save/restore global variables (only all-uppercase variables)
    - '100 save/restore marks from last 100 files
    - <50 save/restore 50 lines from each register
    - s10 max item size 10KB
    - h do not save/restore 'hlsearch' setting

  --]]
    vim.opt.shada = {
        "'0", -- Don't remember files with file marks.
        "<0", -- Don't save registers.
        "f0", -- Don't store file marks.
        "n" .. shada_file, -- Keep shada file out of the way.
    }

    if fs.is_file(shada_file) and not fs.is_readable(shada_file) then
        vim.notify("shada file exists but is not readable: " .. shada_file, vim.log.levels.WARN)
    end
end

--------------------------------------------------
-- Sessions
--------------------------------------------------

-- Keep view files out of the way.
vim.opt.viewdir = vim.fs.joinpath(state_dir, "view")

-- Save/Restore only these options (with `:{mk,load}view`).
vim.opt.viewoptions = {
    "cursor",
    "folds",
}
