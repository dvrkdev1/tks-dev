local tLoadingMaterials = {}
for i = 1, 6 do
    tLoadingMaterials[i] = Material("uitks/loading/loading_" .. i .. ".png", "smooth")
end

local iCurrentMatIndex = 1
local iChangeInterval = 0.1
local iTimeAccumulator = 0

local animStartX = TKS.X(250)
local animEndX = TKS.X(945)
local animDuration = 2.8
local animTime = 0

function TKS.Jutsu:Show()
    local vFrame = vgui.Create("DFrame")
    if not IsValid(vFrame) then return end

    vFrame:SetSize(TKS.X(1024), TKS.Y(486))
    vFrame:SetPos(20, -500)
    vFrame:SetTitle("")
    vFrame:ShowCloseButton(true)
    vFrame:SetDraggable(false)
    vFrame:SetSizable(false)
    vFrame:SetAlpha(0)
    vFrame:AlphaTo(255, 0.5, 0)
    vFrame:MoveTo(TKS.X(445), TKS.Y(290), 0.5, 0, 0.5)
    vFrame:MakePopup()

    function vFrame:Paint(w, h)
        Derma_DrawBackgroundBlur(self)

        surface.SetMaterial(TKS.Jutsu.Config.Material["back"])
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(0, 0, w, h)

        iTimeAccumulator = iTimeAccumulator + FrameTime()
        if iTimeAccumulator >= iChangeInterval then
            iTimeAccumulator = 0
            iCurrentMatIndex = (iCurrentMatIndex % #tLoadingMaterials) + 1
        end

        animTime = animTime + FrameTime()
        if animTime > animDuration then
            animTime = 0
        end
        local progress = animTime / animDuration
        local posX = Lerp(progress, animStartX, animEndX)

        surface.SetMaterial(tLoadingMaterials[iCurrentMatIndex])
        surface.SetDrawColor(255, 255, 255)
        surface.DrawTexturedRect(posX, TKS.Y(360), TKS.X(60), TKS.Y(80))
    end
end

hook.Add("PlayerButtonDown", "TKS:Jutsu:Show", function(pPlayer, vKey)
    if vKey != KEY_F2 then return end
    if CLIENT and not IsFirstTimePredicted() then return end
    TKS.Jutsu:Show()
end)
