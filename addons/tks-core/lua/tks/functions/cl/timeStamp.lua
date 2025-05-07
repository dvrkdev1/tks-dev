TKS = TKS or {}

local tFormat = {
    {
        iMultiplier = 60 * 60 * 24,
        sName = "jour"
    },
    {
        iMultiplier = 60 * 60,
        sName = "heure"
    },
    {
        iMultiplier = 60,
        sName = "minute"
    },
    {
        iMultiplier = 1,
        sName = "seconde"
    }
}

function TKS:FormatTime(iTime)
    local sFinal = "Il y a"
    for _, t in ipairs(tFormat) do
        local iValue = math.floor(iTime / t.iMultiplier)
        iTime = iTime % t.iMultiplier
        sFinal = ("%s %" .. (t.sName ~= "jour" and "02" or "") .. "d %s"):format(sFinal, iValue, t.sName .. (iValue > 1 and "s" or ""))
    end
    return sFinal
end