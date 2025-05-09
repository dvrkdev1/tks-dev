TKS.Intro = TKS.Intro or {}

local tLoadingMaterials = {}
for i = 1, 6 do
    tLoadingMaterials[i] = Material("uitks/loading/loading_" .. i .. ".png", "smooth")
end

local iCurrentMatIndex = 1
local iChangeInterval = 0.1
local iTimeAccumulator = 0

function TKS.Intro:ShowFrame()

    if IsValid(vFrame) then return end

    vFrame = vgui.Create("DFrame")
    vFrame:SetSize(ScrW(), ScrH())
    vFrame:Center()
    vFrame:SetTitle("")
    vFrame:ShowCloseButton(true)
    vFrame:SetDraggable(false)
    vFrame:SetSizable(false)
    vFrame:SetAlpha(0)
    vFrame:AlphaTo(255, 0.5, 0)
    vFrame:MakePopup()
    function vFrame:Paint(w, h)

        surface.SetMaterial(TKS.Intro.Config.Materials["back"])
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(0, 0, w, h)

        iTimeAccumulator = iTimeAccumulator + FrameTime()
        if iTimeAccumulator >= iChangeInterval then
            iTimeAccumulator = 0
            iCurrentMatIndex = (iCurrentMatIndex % #tLoadingMaterials) + 1
        end

        surface.SetMaterial(tLoadingMaterials[iCurrentMatIndex])
        surface.SetDrawColor(255, 255, 255)
        surface.DrawTexturedRect(TKS.X(1820), TKS.Y(965), TKS.X(93), TKS.Y(126))

    end

    local vNextBtn = vgui.Create("DButton", vFrame)
    vNextBtn:SetSize(TKS.X(179), TKS.Y(179))
    vNextBtn:SetPos(TKS.X(865), TKS.Y(520))
    vNextBtn:SetText("")
    function vNextBtn:Paint(w, h)

        if self:IsHovered() then

            surface.SetMaterial(TKS.Intro.Config.Materials["next"])
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawTexturedRect(0, 0, w, h)

        else

            surface.SetMaterial(TKS.Intro.Config.Materials["next"])
            surface.SetDrawColor(255, 255, 255, 150)
            surface.DrawTexturedRect(0, 0, w, h)

        end

    end
    function vNextBtn:OnCursorEntered()

        surface.PlaySound(TKS.Intro.Config.Sound["hover"])

    end
    function vNextBtn:DoClick()

        surface.PlaySound(TKS.Intro.Config.Sound["click"])

        if IsValid(vFrame) then

            vFrame:AlphaTo(0, 0.5, 0, function()

                vFrame:Remove()

            end)

        end

    end

end

hook.Add("InitPostEntity", "TKS:Intro:OpenFrameOnSpawn", function()

    TKS.Intro:ShowFrame()

end)

concommand.Add("tks_intro", function()

    TKS.Intro:ShowFrame()

end)