local process = require('vfs.process')

local hrtime = process.hrtime.bigint

local function warmup(fn, ms)
  local co = coroutine.create(function()
    local n = 1
    while true do
      fn()
      coroutine.yield(n)
      n = n + 1
    end
  end)

  local run
  local n

  local timeout = 1000000ULL * ms
  local start = hrtime()
  repeat
    run, n = coroutine.resume(co)
  until not run or hrtime() - start >= timeout

  return n
end

local function bench(fn)
  -- Run GC before warmup.
  collectgarbage('collect')

  -- Warmup and estimate the number of iterations in 2 seconds.
  local n_iter = warmup(fn, 200) * 10

  -- Run GC after warmup and before benchmarking.
  collectgarbage('collect')

  local start = hrtime()
  for _ = 1, n_iter do
    fn()
  end
  local dur = hrtime() - start
  local per = dur / n_iter

  local unit = 'ns'
  if per > 1000ULL then
    per = per / 1000ULL
    unit = 'µs'
  end
  if per > 1000ULL then
    per = per / 1000ULL
    unit = 'ms'
  end
  if per > 1000ULL then
    per = per / 1000ULL
    unit = 's'
  end

  print(string.format("%d%s (%d iters)", tonumber(per), unit, n_iter))
end

local function timeit(fn)
  -- Disable GC.
  collectgarbage('stop')
  -- Wrap bench in a pcall to make sure we restart GC.
  pcall(bench, fn)
  -- Restart GC.
  collectgarbage('restart')
end

return timeit
