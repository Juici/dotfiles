--------------------------------------------------
-- General
--------------------------------------------------

vim.opt.autoread = true -- Detect when a file is modified externally.
vim.opt.history = 1000 -- Set history size to 1000.
vim.opt.modelines = 5 -- Scan 5 lines looking a modeline.

vim.opt.hidden = true -- Allow buffers with unsaved changes to be hidden.
vim.opt.switchbuf = "usetab" -- Try to reuse windows/tabs when switching buffers.

vim.opt.mouse = { a = true } -- Enable mouse support.
vim.opt.ttyfast = true -- Faster redrawing.

vim.opt.belloff = "all" -- Never ring bell, for any reason.
vim.opt.visualbell = true -- Stop beep for non-error bells.

--------------------------------------------------
-- Shell
--------------------------------------------------

do
    -- Use the 'SHELL' environment variable if it is present.
    local shell = vim.env.SHELL

    -- Fallbacks if 'SHELL' is not set.
    if shell == nil then
        if vim.fn.executable("zsh") == 1 then
            -- Use zsh if it can be found.
            shell = "zsh"
        elseif vim.fn.executable("bash") == 1 then
            -- Try to fallback to bash.
            shell = "bash"
        else
            -- If all else fails fallback to sh.
            shell = "sh"
        end
    end

    -- Set shell to use for `!`, `:!`, `system()`, etc.
    vim.opt.shell = shell
end

--------------------------------------------------
-- Wild menu
--------------------------------------------------

-- Show options as a menu list when tab completing, etc.
vim.opt.wildmenu = true
-- Shell-like autocompletion to unambiguous portion.
vim.opt.wildmode = { "longest:full", "full" }
-- Patterns to ignore when expanding files.
vim.opt.wildignore:append({ "*.o", "*.so" })
-- Substitute (<C-z>) for `wildchar` (<Tab>) in macros.
vim.opt.wildcharm = vim.keycode("<C-z>"):byte()

--------------------------------------------------
-- Splits
--------------------------------------------------

vim.opt.splitbelow = true -- Open horizontal splits below current line.
vim.opt.splitright = true -- Open vertical splits right of current window.
