TKS = TKS or {}
table = table or {}

-- Check if 2 tables have the same values
function table.TKS:Compare(tOne, tTwo)

    tTwo = table.Copy(tTwo)

    for xIndex, xValue in pairs(tOne) do

        if istable(xValue) and istable(tTwo[xIndex]) then
            return table.Compare(xValue, tTwo[xIndex])
        elseif tTwo[xIndex] ~= xValue then
            return false
        end

        tTwo[xIndex] = nil

    end

    return table.Count(tTwo) == 0

end