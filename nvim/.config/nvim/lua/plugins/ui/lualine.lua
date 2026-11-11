local util = require("juici.util")

local strwidth = vim.api.nvim_strwidth
local winwidth = vim.api.nvim_win_get_width

--------------------------------------------------
-- Options
--------------------------------------------------

local options = {
    theme = "onedark",
    icons_enabled = not util.is_linux_console(),
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
}

--------------------------------------------------
-- Filename
--------------------------------------------------

local filename
do
    -- Cached file path, this is updated everytime `cond` is called and thus is
    -- set before every `display` call.
    local file_path --- @type string

    local function display()
        local file = file_path

        local width = winwidth(0)
        if width < 70 then
            -- If the window width is less than 70, just display the file name.
            file = vim.fs.basename(file)
        else
            -- Get relative path from current working directory or home directory.
            file = vim.fn.fnamemodify(file_path, ":~:.") -- TODO: Write a custom function for this.

            -- If the window width is less than 90, or the path takes up more than
            -- 40% of the width, then shorten the path displayed.
            if width < 90 or strwidth(file) > width * 0.4 then
                -- Shorten the directory names displayed in the path.
                file = vim.fn.pathshorten(file)
            end
        end

        if vim.bo.modified then
            return file .. " *"
        end
        return file
    end

    local function has_file_path()
        file_path = util.file_path()

        -- Ignore empty file path.
        return #file_path > 0
    end

    filename = {
        display,
        cond = has_file_path,
        separator = {
            right = options.section_separators.left,
        },
    }
end

--------------------------------------------------
-- Readonly
--------------------------------------------------

local readonly
do
    local lock
    if options.icons_enabled then
        lock = "󰍁" -- nf-md-lock_outline
    else
        lock = "R"
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
            fg = "#282c34",
            bg = "#e06c75",
        },
        separator = {
            right = options.section_separators.left,
        },
    }
end

--------------------------------------------------
-- Diagnostics
--------------------------------------------------

local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn", "info", "hint" },
    update_in_insert = false,
}

if options.icons_enabled then
    diagnostics.symbols = {
        error = "󰅚 ", -- nf-md-close_circle_outline
        warn = "󰀪 ", -- nf-md-alert_outline
        info = "󰋽 ", -- nf-md-information_outline
        hint = "󰌶 ", -- nf-md-lightbulb_outline
    }
else
    diagnostics.symbols = {
        error = "E",
        warn = "W",
        info = "I",
        hint = "H",
    }
end

--------------------------------------------------
-- File format
--------------------------------------------------

local fileformat
do
    local table = {
        unix = "LF",
        dos = "CRLF",
        mac = "CR",
    }

    local function display()
        return table[vim.bo.fileformat]
    end

    local function is_not_lf()
        return vim.bo.fileformat ~= "unix"
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
    "encoding",
    cond = function()
        local enc = vim.bo.fileencoding
        return #enc > 0 and enc ~= "utf-8"
    end,
}

--------------------------------------------------
-- Lualine
--------------------------------------------------

local config = {
    options = options,
    sections = {
        lualine_a = { "mode" },
        lualine_b = { filename, readonly },
        lualine_c = { diagnostics },
        lualine_x = { fileencoding, fileformat, "filetype" },
        lualine_y = { { "branch", icon = "" } },
        lualine_z = { "location" },
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

--- @type LazySpec
return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = config,
    init = function()
        vim.opt.showmode = false
    end,
}
