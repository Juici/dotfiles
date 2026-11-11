local lazy_root = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")

do
    local lazy_plugin = vim.fs.joinpath(lazy_root, "lazy.nvim")

    local stat = vim.uv.fs_stat(lazy_plugin)
    if stat == nil then
        vim.notify("Installing lazy.nvim...", vim.log.levels.INFO)

        local lazy_repo = "https://github.com/folke/lazy.nvim.git"
        local ok, proc_or_err =
            pcall(vim.system, { "git", "clone", "--filter=blob:none", "--branch=stable", lazy_repo, lazy_plugin })

        if not ok then
            vim.notify("Failed to start git program.", vim.log.levels.ERROR)
            return false
        end

        local r = proc_or_err:wait()

        if r.code ~= 0 then
            vim.notify("Failed to clone lazy.nvim:\n" .. r.stderr, vim.log.levels.ERROR)
            return false
        end
    elseif stat.type ~= "directory" then
        vim.notify("'" .. lazy_plugin .. "' exists, but is not a directory.", vim.log.levels.ERROR)
        return false
    end

    vim.opt.rtp:prepend(lazy_plugin)
end

-- Add support for the LazyFile event.
do
    local Event = require("lazy.core.handler.event")

    Event.mappings.LazyFile = { id = "LazyFile", event = { "BufReadPost", "BufNewFile", "BufWritePre" } }
end

require("lazy").setup("plugins", {
    root = lazy_root,
    spec = { { import = "plugins" } },
    install = { colorscheme = { "onedark" } },
    checker = { enabled = true },
    rocks = { enabled = false },
})

return true
