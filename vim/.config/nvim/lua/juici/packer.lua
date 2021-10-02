-- Bootstrap packer.

local path = require('vfs.path')

local PACKER_REPO = 'https://github.com/wbthomason/packer.nvim'

local data_dir = vim.fn.stdpath('data')
local install_path = path.join(data_dir, 'site/pack/packer/opt/packer.nvim')

if not path.isdir(install_path) then
  -- Install path is not a directory.
  if path.exists(install_path) then
    -- A file exists at the install path, which will prevent bootstrapping.
    error('unexpected file at packer install path: ' .. install_path)
  end


  -- Clone the packer repository.
  vim.fn.system({ 'git', 'clone', '--depth=1', PACKER_REPO, install_path})
end

-- Add packer to the `runtimepath` and source files.
vim.cmd('packadd packer.nvim')

return require('packer')
