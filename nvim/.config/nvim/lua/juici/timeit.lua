local ffi = require("ffi")

-- stylua: ignore
ffi.cdef [[
    uint64_t uv_hrtime();
]]

--- @type fun(): integer
local hrtime = ffi.C.uv_hrtime

---@param fn function
---@param ms integer
---@return integer
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

---@param fn function
local function bench(fn)
    -- Run GC before warmup.
    collectgarbage("collect")

    -- Warmup and estimate the number of iterations in 2 seconds.
    local n_iter = warmup(fn, 200) * 10

    -- Run GC after warmup and before benchmarking.
    collectgarbage("collect")

    local start = hrtime()
    for _ = 1, n_iter do
        fn()
    end
    local dur = hrtime() - start
    local per = dur / n_iter

    local ns = per % 1000ULL
    local us = (per / 1000ULL) % 1000ULL
    local ms = (per / 1000000ULL) % 1000ULL
    local s = per / 1000000000ULL

    local parts = {}
    if s > 0ULL then
        table.insert(parts, string.format("%ds", s))
    end
    if ms > 0ULL then
        table.insert(parts, string.format("%dms", ms))
    end
    if us > 0ULL then
        table.insert(parts, string.format("%dµs", us))
    end
    if ns > 0ULL then
        table.insert(parts, string.format("%dns", ns))
    end

    print(string.format("%s (%d iters)", table.concat(parts, " "), n_iter))
end

local function timeit(fn)
    -- Disable GC.
    collectgarbage("stop")
    -- Wrap bench in a pcall to make sure we restart GC.
    pcall(bench, fn)
    -- Restart GC.
    collectgarbage("restart")
end

return timeit
