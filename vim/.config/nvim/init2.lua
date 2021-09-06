require('juici')

juici.g.config = debug.getinfo(1, 'S').source:sub(2)

-- Don't load plugins as vi.
if vim.v.progname then
  vim.opt.loadplugins = false
end
