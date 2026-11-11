local map = vim.keymap.set

-- Bind <C-a> and <C-e> to navigate to the start/end of the line.
map("c", "<C-a>", "<Home>")
map("c", "<C-e>", "<End>")

-- Bind <C-BS> to delete word backward.
map("c", "<C-BS>", "<C-w>")
map("c", "<C-h>", "<C-w>")

-- Bind <C-Del> to delete word forward.
do
    -- Use `vim.regex` to support `[:keyword:]`.
    local re = vim.regex("\\%#=2\\v^\\s*%(\\k+|[^[:keyword:][:space:]]+)?")

    map("c", "<C-Del>", function()
        local buf = vim.fn.getcmdline()
        local pos = vim.fn.getcmdpos()

        -- If at end of buffer then do nothing.
        if pos > #buf then
            return ""
        end

        local left = buf:sub(1, pos - 1)
        local right = buf:sub(pos)

        local _, del = re:match_str(right)
        right = right:sub(del + 1)

        return [[<C-\>e']] .. left .. right .. [['<CR>]]
    end, { expr = true })
end
