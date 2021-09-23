local ok, config = pcall(require, 'nvim-treesitter.configs')
if not ok then
  return
end

config.setup {
  highlight = {
    enable = true,
    disable = {},
  },
}
