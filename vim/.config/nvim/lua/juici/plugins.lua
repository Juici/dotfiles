local path = require('vfs.path')

local packer = juici.packer

local initialized = false

local plugins = {}

-- TODO: Split these into separate modules?

local function appearance()
  local use = packer.use

  -- Colour scheme.
  use { 'joshdick/onedark.vim' }

  -- Status line.
  use {
    'nvim-lualine/lualine.nvim',
    config = 'juici.statusline.load()',
    event = 'VimEnter',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
  }
end

local function general()
  local use = packer.use

  -- Support for `.editorconfig` files.
  use { 'editorconfig/editorconfig-vim' }

  -- Indent guides.
  use { 'Yggdroot/indentLine' }

  -- Enhanced terminal features.
  use { 'wincent/terminus' }

  -- Git wrapper.
  use { 'tpope/vim-fugitive' }
end

local function syntax()
  local use = packer.use

  -- Enhanced syntax.
  use { 'sheerun/vim-polyglot' }

  -- Use treesitter for syntax highlighting.
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
end

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

  appearance()
  general()
  syntax()

  -- CoC
  --use { 'neoclide/coc.nvim', branch = 'release' }
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
