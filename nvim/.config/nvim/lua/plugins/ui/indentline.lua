--- @type LazySpec
return {
    "lukas-reineke/indent-blankline.nvim",
    event = "LazyFile",
    main = "ibl",
    --- @type ibl.config
    opts = {
        indent = {
            char = "▏", -- LEFT ONE EIGTH BLOCK (U+258F)
        },
        scope = { show_start = false, show_end = false },
        exclude = {
            filetypes = {
                "help",
                "lazy",
                "notify",
            },
        },
    },
}
