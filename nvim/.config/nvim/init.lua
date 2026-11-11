-- Enable the experimental loader if available.
if vim.loader then
    vim.loader.enable()
end

--------------------------------------------------
-- Globals
--------------------------------------------------

-- Make sure to setup `mapleader` and `maplocalleader` before loading lazy.nvim
-- so that mappings are correct.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

--------------------------------------------------
-- Configs
--------------------------------------------------

require("config.general")
require("config.appearance")
require("config.editing")
require("config.persist")

--------------------------------------------------
-- Plugins
--------------------------------------------------

if vim.o.loadplugins and not require("load_plugins") then
    vim.notify("Plugin loading disabled. Press any key to continue...", vim.log.levels.WARN)
    vim.fn.getchar()
end

--------------------------------------------------
-- Footer
--------------------------------------------------

--[[

After this file is sourced, plugin code will be evaluated (eg. './plugin/*').
After which files will be evaluated from './after/*'. See `:scriptnames` for a
list of all scripts, in evaluation order.

Launch Neovim with `nvim --startuptime nvim.log` for profiling info.

To see all leader mappings, including those from plugins:

    nvim -c 'map <Leader>'
    nvim -c 'map <LocalLeader>'

--]]
