local uv = vim.uv

local util = require("juici.util")

local THRESHOLD_PWD_WIDTH = 20
local THRESHOLD_FILE_WIDTH = 20

function vim.g.juici_title()
    local prog = vim.v.progname

    local cwd = uv.cwd() or vim.fn.getcwd()
    local home = os.getenv("HOME") or uv.os_homedir() or vim.fn.expand("~")

    local cwd_f = cwd

    -- Resolve the working directory with tilde notation.
    if cwd_f:sub(1, #home) == home then
        cwd_f = "~" .. cwd_f:sub(#home + 1)
    end

    -- Shorten directory names for paths if they exceed the threshold.
    if #cwd_f > THRESHOLD_PWD_WIDTH then
        cwd_f = vim.fn.pathshorten(cwd_f)
    end

    local s = cwd_f .. " - " .. prog

    local file = util.file_path()
    if file ~= "" then
        -- Resolve the file name replative to the working directory and fallback to
        -- tilde notation if not inside working directory path.
        if file:sub(1, #cwd) == cwd then
            file = "." .. file:sub(#cwd + 1)
        elseif file:sub(1, #home) == home then
            file = "~" .. file:sub(#home + 1)
        end

        -- Shorten directory names for paths if they exceed the threshold.
        if #file > THRESHOLD_FILE_WIDTH then
            file = vim.fn.pathshorten(file)
        end

        s = s .. " (" .. file .. ")"
    end

    return s
end

-- Enable terminal title integration.
vim.opt.title = true
vim.opt.titlestring = "%{v:lua.vim.g.juici_title()}"
