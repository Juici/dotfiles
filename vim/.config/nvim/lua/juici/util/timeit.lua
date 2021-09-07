local N_EXEC = 100000

local function timeit(fn)
  local start = os.clock()
  for _ = 1, N_EXEC do
    fn()
  end
  local dur = os.clock() - start
  return dur / N_EXEC
end

return timeit
