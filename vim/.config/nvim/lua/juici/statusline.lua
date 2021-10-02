local lualine = require('lualine')
local path = require('vfs.path')

local strwidth = vim.api.nvim_strwidth
local winwidth = vim.api.nvim_win_get_width

--------------------------------------------------
-- Options
--------------------------------------------------

local options = {
  icons_enabled = not juici.g.is_linux_console,
  component_separators = { left = '', right = '' },
  section_separators = { left = '', right = '' },
  disabled_filetypes = {},
}

--------------------------------------------------
-- File name
--------------------------------------------------

local filename
do
  --local lock
  --if icons_enabled then
  --  lock = ''  -- LOCK OUTLINE (U+F840).
  --else
  --  lock = '[R]'
  --end

  -- Cached file path, this is updated everytime `cond` is called and thus is
  -- set before every `display` call.
  local file_path

  local function display()
    local file = file_path

    local width = winwidth(0)
    if width < 70 then
      -- If the window width is less than 70, just display the file name.
      file = path.file_name(file)
    else
      -- Get relative path from current working directory or home directory.
      file = vim.fn.fnamemodify(file_path, ':~:.')

      -- If the window width is less than 90, or the path takes up more than
      -- 40% of the width, then shorten the path displayed.
      if width < 90 or strwidth(file) > width * 0.4 then
        -- Shorten the directory names displayed in the path.
        file = vim.fn.pathshorten(file)
      end
    end

    local s = { file }
    --if vim.bo.modifiable and vim.bo.readonly then
    --  -- We only consider a file readonly if it is modifiable but marked
    --  -- readonly. This excludes things like 'help' and 'netrw'.
    --  table.insert(s, lock)
    --end
    if vim.bo.modified then
      table.insert(s, '*')
    end
    return table.concat(s, ' ')
  end

  local function has_file_path()
    file_path = juici.util.file_path()
    return #file_path > 0
  end

  filename = {
    display,
    cond = has_file_path,
    separator = {
      right = options.section_separators.left,
    }
  }
end

local readonly
do
  local lock
  if options.icons_enabled then
    lock = ''  -- LOCK OUTLINE (U+F840).
  else
    lock = 'R'
  end

  local function display()
    return lock
  end

  local function is_readonly()
    -- We only consider a file readonly if it is modifiable but marked readonly.
    -- This excludes things like 'help' and 'netrw'.
    return vim.bo.modifiable and vim.bo.readonly
  end

  readonly = {
    display,
    cond = is_readonly,
    color = {
      -- TODO: Get these values programatically and make a highlight group.
      fg = '#282c34',
      bg = '#e06c75',
    },
    separator = {
      right = options.section_separators.left,
    },
  }
end

--------------------------------------------------
-- File format
--------------------------------------------------

local fileformat
do
  local table = {
    unix = 'LF',
    dos = 'CRLF',
    mac = 'CR',
  }

  local function display()
    return table[vim.bo.fileformat]
  end

  local function is_not_lf()
    return vim.bo.fileformat ~= 'unix'
  end

  fileformat = {
    display,
    cond = is_not_lf,
  }
end

--------------------------------------------------
-- File encoding
--------------------------------------------------

local fileencoding = {
  'encoding',
  cond = function()
    return vim.bo.fileencoding ~= 'utf-8'
  end
}

--------------------------------------------------
-- Diagnostics
--------------------------------------------------

local diagnostics = {
  'diagnostics',
  sources = { 'nvim_lsp', 'coc' },
  sections = { 'error', 'warn', 'info', 'hint' },
  update_in_insert = false,
}

if options.icons_enabled then
  diagnostics.symbols = {
    error = ' ', -- CLOSE CIRCLE OUTLINE (U+F659).
    warn = ' ',  -- ALERT OUTLINE (U+F529).
    info = ' ',  -- INFORMATION OUTLINE (U+F7FC).
    hint = ' ',  -- LIGHTBULB OUTLINE (U+F835).
  }
else
  diagnostics.symbols = {
    error = 'E',
    warn = 'W',
    info = 'I',
    hint = 'H',
  }
end

--------------------------------------------------
-- Lualine
--------------------------------------------------

local config = {
  options = options,
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { filename, readonly },
    lualine_c = { diagnostics },
    lualine_x = { fileencoding, fileformat, 'filetype' },
    lualine_y = {
      { 'branch', icon = '' },
    },
    lualine_z = { 'location' },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  extensions = {},
}

return {
  load = function()
    vim.opt.showmode = false
    lualine.setup(config)
  end
}
