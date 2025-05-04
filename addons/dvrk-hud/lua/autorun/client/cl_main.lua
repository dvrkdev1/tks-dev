local RX = RX or function(x) return x / 1920 * ScrW() end
local RY = RY or function(y) return y / 1080 * ScrH() end

surface.CreateFont("DHud:Nick", {
    font = "Montserrat Bold",
    size = RX(20),
    weight = 500,
})

surface.CreateFont("DHud:Health", {
    font = "Montserrat Bold",
    size = RX(18),
    weight = 500,
})

local function DrawStencilMask(fcMask, fcRender, bInvert)

    if not isfunction(fcMask) or not isfunction(fcRender) then return end

    render.ClearStencil()
    render.SetStencilEnable(true)

    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)

    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(bInvert and STENCILOPERATION_REPLACE or STENCILOPERATION_KEEP)
    render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilReferenceValue(1)

    fcMask()

    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(bInvert and STENCILOPERATION_REPLACE or STENCILOPERATION_KEEP)
    render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilReferenceValue(bInvert and 0 or 1)

    fcRender()

    render.SetStencilEnable(false)
    render.ClearStencil()

end

local iHealthLerp = 0
hook.Add("HUDPaint", "DHud:Player", function()

    local iHealth = LocalPlayer():Health()
    local iMaxHealth = LocalPlayer():GetMaxHealth()
    local sNick = LocalPlayer():GetName()

    iHealthLerp = Lerp(FrameTime() * 1.7, iHealthLerp, iHealth / iMaxHealth)

    surface.SetMaterial(Material("uitks/hud/back.png", "smooth"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(RX(18), RY(15), RX(370), RY(141))

    surface.SetMaterial(Material("uitks/hud/icon.png", "smooth"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRectRotated(RX(105), RY(90), RX(112), RY(112), -10 + (math.sin(CurTime() * 2 ) * 5))

    draw.SimpleText(sNick, "DHud:Nick", RX(170), RY(68.5), Color(255, 255, 255, 140), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    DrawStencilMask(function()

        surface.SetMaterial(Material("uitks/hud/health_bar.png", "smooth"))
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(RX(170), RY(80), RX(219), RY(20))

    end, function()

        surface.SetMaterial(Material("uitks/hud/health_bar.png", "smooth"))
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(RX(170), RY(80), RX(219) * iHealthLerp, RY(20))

    end)

    draw.SimpleText(iHealth .. "HP", "DHud:Health", RX(172), RY(88.5), Color(255, 255, 255, 80), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

end)

local tHideElement = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true,
    ["DarkRP_HUD"] = true,
    ["DarkRP_EntityDisplay"] = true,
    ["DarkRP_LocalPlayerHUD"] = true,
    ["DarkRP_Hungermod"] = true,
    ["DarkRP_Agenda"] = true,
    ["DarkRP_LockdownHUD"] = true,
    ["DarkRP_ArrestedHUD"] = true,
    ["DarkRP_ChatReceivers"] = true,
}

hook.Add("HUDShouldDraw", "DHud:ShouldDraw", function(sName)
    if tHideElement[sName] then return false end
end)