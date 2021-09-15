local opt = vim.opt

--------------------------------------------------
-- General
--------------------------------------------------

opt.autoread = true       -- Detect when a file is modified externally.
opt.history = 100         -- Set history size to 1000.
opt.modelines = 5         -- Scan 5 lines looking a modeline.

opt.hidden = true         -- Allow buffers with unsaved changes to be hidden.
opt.switchbuf = 'usetab'  -- Try to reuse windows/tabs when switching buffers.

opt.mouse = { a = true }  -- Enable mouse support.
opt.ttyfast = true        -- Faster redrawing.

opt.belloff = 'all'       -- Never ring bell, for any reason.
opt.visualbell = true     -- Stop beep for non-error bells.

--------------------------------------------------
-- Shell
--------------------------------------------------

do
  -- Use the 'SHELL' environment variable if it is present.
  local shell = os.getenv('SHELL')

  -- Fallbacks if 'SHELL' is not set.
  if shell == nil then
    if vim.fn.executable('zsh') then
      -- Use zsh if it can be found.
      shell = 'zsh'
    elseif vim.fn.executable('bash') then
      -- Try to fallback to bash.
      shell = 'bash'
    else
      -- If all else fails fallback to sh.
      shell = 'sh'
    end
  end

  -- Set shell to use for `!`, `:!`, `system()`, etc.
  opt.shell = shell
end

--------------------------------------------------
-- Wild menu
--------------------------------------------------

-- Show options as a menu list when tab completing, etc.
opt.wildmenu = true
-- Shell-like autocompletion to unambiguous portion.
opt.wildmode = {
  'longest:full',
  'full',
}
-- Patterns to ignore when expanding files.
opt.wildignore:append({
  '*.o',
  '*.so',
})
-- Substitute (<C-z>) for `wildchar` (<Tab>) in macros.
opt.wildcharm = string.byte('')

--------------------------------------------------
-- Splits
--------------------------------------------------

opt.splitbelow = true -- Open horizontal splits below current line.
opt.splitright = true -- Open vertical splits right of current window.
