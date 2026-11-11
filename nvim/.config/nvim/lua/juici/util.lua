local uv = vim.uv

local M = {}

--- Returns true if we are running in VI mode.
function M.is_vi()
    return vim.v.progname == "vi"
end

--- Returns true if we are running as root.
function M.is_root()
    return uv.getuid() == 0
end

--- Returns true if the terminal is the Linux console.
function M.is_linux_console()
    return vim.env.TERM == "linux"
end

--- Returns path to the currently open file or directory.
function M.file_path()
    if vim.opt.filetype == "netrw" then
        -- The directory open in the current buffer.
        return vim.b.netrw_curdir
    else
        -- The file open in the current buffer.
        return vim.api.nvim_buf_get_name(0)
    end
end

return M
