--- @type LazySpec
return {
    {
        "neovim/nvim-lspconfig",
        event = "LazyFile",
        opts = function()
            --- @class LspOpts
            local ret = {}
            return ret
        end,
        --- @param opts LspOpts
        config = function(_, opts) end,
    },
}
