-- Checks if vim is being run as root.

return vim.loop.getuid() == 0
