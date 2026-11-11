--- @type LazySpec
return {
    "navarasu/onedark.nvim",
    -- Make sure to load colorscheme first.
    lazy = false,
    priority = 1000,
    opts = {
        style = "dark",
        term_colors = false,
        colors = {
            white = "#e6e6e6",
            black = "#3f4451",
            grey = "#4f5666",
            red = "#e06c75",
            dark_red = "#be5046",
        },
    },
    init = function()
        vim.cmd("colorscheme onedark")
    end,
}
