local path = require('vfs.path')

local packer = juici.packer

local initialized = false

local plugins = {}

function plugins.load()
  if not initialized then
    packer.init {
      compile_path = path.join(juici.g.vim_dir, 'plugin/packer_compiled.lua'),
      display = {
        open_fn = require('packer.util').float,
      }
    }
    initialized = true
  end
  packer.reset()

  local use = packer.use

  -- Packer can manage itself.
  use { 'wbthomason/packer.nvim', opt = true }

  -- Status line.
  use {
    'nvim-lualine/lualine.nvim',
    config = 'juici.statusline.load()',
    event = 'VimEnter',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
  }
end

-- TODO: Recompile on file modified or hash changed.
function plugins.recompile()
  -- Reload this file.
  plugins = juici.reload('juici', 'plugins')
  -- Reload plugins.
  plugins.load()

  -- Get hash of this file to represent state.


  -- Recompile lazy-loader code.
  packer.compile()
end

return plugins
