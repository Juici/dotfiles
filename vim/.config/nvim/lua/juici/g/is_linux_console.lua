-- If the terminal is the basic linux console.
return vim.startswith(os.getenv('TERM'), 'linux')
