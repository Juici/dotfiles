require('juici')

local path = require('vfs.path')
local fs = require('vfs.fs')

-- Don't load plugins as vi.
if juici.g.is_vi then
  vim.opt.loadplugins = false
end

-- Load settings.
juici.settings.load()

--------------------------------------------------
-- Globals
--------------------------------------------------

-- Speed up start by not searching for python executable.
do
  local python = '/usr/bin/python3'
  if fs.is_file(python) and fs.is_readable(python) then
    vim.g.python3_host_prog = python
  end
end

-- Map leaders.
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Extension -> filetype mappings.
vim.g.filetype_pl = 'prolog'

--------------------------------------------------
-- Overrides
--------------------------------------------------

-- Load local configuration overrides.
do
  local overrides = {
    path.join(juici.g.vim_dir, 'init.local.vim'),
    path.join(juici.g.vim_dir, 'init.local.lua'),
  }
  for _, override in ipairs(overrides) do
    if fs.is_file(override) and fs.is_readable(override) then
      vim.cmd('source ' .. override)
    end
  end
end

--------------------------------------------------
-- Legacy (TODO: Remove)
--------------------------------------------------

vim.g.vim_dir = juici.g.vim_dir
vim.g.linux_console = juici.g.is_linux_console

-- Load settings the need to be loaded before plugins.
vim.call('juici#settings#load_settings')

-- Load plugins.
if vim.o.loadplugins then
  vim.call('juici#plugins#load')
end

--------------------------------------------------
-- Plugins
--------------------------------------------------

if vim.o.loadplugins then
  juici.plugins.load()
end

-- Automatic, language-dependent indentation, syntax coloring and other
-- functionality.
--
-- This must come after plugin loading.
vim.cmd('filetype indent plugin on')
vim.cmd('syntax on')

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
