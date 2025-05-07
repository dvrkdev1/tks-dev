TKS = TKS or {}

-- Perform a benchmark test to see which method is faster
function TKS:benchmark(iIterations, ...)

    local tTests = {...}
    local tResults = {}

    -- Do each benchmark
    for i = 1, #tTests do

        local iStart = SysTime()

        for _ = 1, iIterations do
            tTests[i]()
        end

        tResults[i] = {SysTime() - iStart, i}

    end

    -- Sort from fastest to slowest
    table.sort(tResults, function(a, b) return a[1] < b[1] end)

    -- Print how much slower the test was from the fastest test
    for i = 1, #tResults do
        print("Test " .. tResults[i][2] .. " was " .. math.Round((tResults[i][1] - tResults[1][1]) / tResults[i][1] * 100, 2) .. "% slower than the fastest test" .. " (" .. math.Round(tResults[i][1], 4) .. " seconds)")
    end

end