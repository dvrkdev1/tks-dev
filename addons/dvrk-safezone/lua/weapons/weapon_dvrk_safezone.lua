local RX = RX or function(x) return x / 1920 * ScrW() end
local RY = RY or function(y) return y / 1080 * ScrH() end

AddCSLuaFile()

SWEP.Author = "DvRk"
SWEP.Instructions = "Set Safezones"
SWEP.Spawnable = true
SWEP.AdiMinOnly = true

SWEP.UseHands = true
SWEP.Category = "DvRK - Safezones"

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.PrintName = "SafezoneTool"
SWEP.Slot = 0
SWEP.SlotPos = 1
SWEP.DrawAmmo = false

SWEP.pos_one = nil
SWEP.pos_two = nil
SWEP.vFrame = nil
SWEP.deployed = false

function SWEP:Initialize()
    self:SetHoldType("pistol")
end

function SWEP:Deploy()

    hook.Add("PostDrawOpaqueRenderables", "DSafeZone:Display", function()

        if not self.pos_one then return end

        local Col = COLOR_BLACK

        local vStart = self.pos_one
        local vEnd = self.pos_two or LocalPlayer():GetEyeTrace().HitPos

        local iMin = Vector(math.Min(vStart.x, vEnd.x), math.Min(vStart.y, vEnd.y), math.Min(vStart.z, vEnd.z))
        local iMax = Vector(math.Max(vStart.x, vEnd.x), math.Max(vStart.y, vEnd.y), math.Max(vStart.z, vEnd.z))

        local vB1, vB2, vB3, vB4 = Vector(iMin.x, iMin.y, iMin.z), Vector(iMin.x, iMax.y, iMin.z), Vector(iMax.x, iMax.y, iMin.z), Vector(iMax.x, iMin.y, iMin.z)
        local vT1, vT2, vT3, vT4 = Vector(iMin.x, iMin.y, iMax.z), Vector(iMin.x, iMax.y, iMax.z), Vector(iMax.x, iMax.y, iMax.z), Vector(iMax.x, iMin.y, iMax.z)

        render.DrawLine(vB1, vB2, Col, true)
        render.DrawLine(vB2, vB3, Col, true)
        render.DrawLine(vB3, vB4, Col, true)
        render.DrawLine(vB4, vB1, Col, true)
        render.DrawLine(vT1, vT2, Col, true)
        render.DrawLine(vT2, vT3, Col, true)
        render.DrawLine(vT3, vT4, Col, true)
        render.DrawLine(vT4, vT1, Col, true)
        render.DrawLine(vB1, vT1, Col, true)
        render.DrawLine(vB2, vT2, Col, true)
        render.DrawLine(vB3, vT3, Col, true)
        render.DrawLine(vB4, vT4, Col, true)

    end)

    return true

end

function SWEP:Holster()

    self.deployed = false
    self.pos_one = nil
    self.pos_two = nil

    hook.Remove("PostDrawOpaqueRenderables", "DSafeZone:Display")
    return true

end

function SWEP:OnRemove()
    return true
end

function SWEP:Think()
end

function SWEP:PrimaryAttack()
    self.pos_one = self:GetOwner():GetEyeTrace().HitPos
end

function SWEP:SecondaryAttack()

    self.pos_two = self:GetOwner():GetEyeTrace().HitPos

    if SERVER then DvRkSaveSafezone(self.pos_one, self.pos_two) end

    self.pos_one = nil
    self.pos_two = nil

end

function SWEP:FireAnimationEvent(event)
    return true
end

if SERVER then return end

function SWEP:Think()

    if not self.deployed then

        self:Deploy()
        self.deployed = true

    end

end

function SWEP:DrawHUD()

    draw.RoundedBox(5, 5, ScrH() / 2.58, RX(316), RY(90), Color(19, 19, 19, 255))

    draw.SimpleText("Leftclick = place first point", "DSafeZone:TextHelp", 10, ScrH() / 2.5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

    draw.SimpleText("Rightclick = place second point & save", "DSafeZone:TextHelp", 10, ScrH() / 2.5 + 20, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

    draw.SimpleText("Reload = Open menu to delete safezones", "DSafeZone:TextHelp", 10, ScrH() / 2.5 + 40, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

end

function SWEP:Reload()

    if SERVER then return end

    if IsValid(self.vFrame) then return end

    self.vFrame = vgui.Create("DFrame")
    self.vFrame:SetTitle("Safezone Menu")
    self.vFrame:SetSize(RX(400), RY(300))
    self.vFrame:ShowCloseButton(false)
    self.vFrame:SetAlpha(0)
    self.vFrame:AlphaTo(255, 0.5, 0)
    self.vFrame:Center()
    self.vFrame:MakePopup()
    function self.vFrame:Paint(w, h)

        draw.RoundedBox(5, 0, 0, w, h, Color(19, 19, 19))
        draw.RoundedBox(0, 1, 1, w - 2, h - 2, Color(36, 36, 36))

    end

    local vClose = vgui.Create("DButton", self.vFrame)
    vClose:SetPos(RX(400 - 32), RY(2))
    vClose:SetSize(RX(30), RY(20))
    vClose:SetText("X")
    vClose:SetTextColor(Color(255, 0, 0))
    function vClose:Paint(w, h)

        draw.RoundedBox(0, 0, 0, w, h, Color(47, 49, 54))
        if self.Hovered then draw.RoundedBox(0, 0, 0, w, h, Color(66, 70, 77)) end

    end
    vClose.DoClick = function()

        self.vFrame:AlphaTo(0, 0.5, 0, function()
            self.vFrame:Close()
        end)

    end

    local vHelpText = nil
    local sText = {"Click to delete!", "How To: Go to the safezone you want to delete", "click on the one with the smallest distance to you!"}

    for k, v in pairs(sText) do

        vHelpText = vgui.Create("DLabel", self.vFrame)
        vHelpText:SetFont("DSafeZone:TextHelp2")
        vHelpText:SetText(v)
        vHelpText:SetTextColor(Color(255, 255, 255))
        vHelpText:SetContentAlignment(5)
        vHelpText:DockMargin(1, 1, 1, 1)
        vHelpText:Dock(TOP)

    end

    local DScrollPanel = vgui.Create("DScrollPanel", self.vFrame)
    DScrollPanel:Dock(FILL)

    local tSafezones = {}
    for k, v in ipairs(ents.FindByClass("DvRk_safezone")) do

        table.insert(tSafezones, v)

    end

    for k, v in pairs(tSafezones) do

        local vZoneBtn = DScrollPanel:Add("DButton")
        vZoneBtn:SetText("  " .. v:GetID() .. " - Distance to zone: " .. v:GetPos():Distance(LocalPlayer():GetPos()))
        vZoneBtn.id = v:GetID()
        vZoneBtn.ent = v
        vZoneBtn:DockMargin(1, 1, 1, 1)
        vZoneBtn:SetTextColor(Color(255, 255, 255))
        vZoneBtn:Dock(TOP)
        vZoneBtn:SetContentAlignment(4)
        function vZoneBtn:Paint(w, h)

            draw.RoundedBox(0, 0, 0, w, h, Color(47, 49, 54))
            if self.Hovered then draw.RoundedBox(0, 0, 0, w, h, Color(66, 70, 77)) end

        end
        vZoneBtn.DoClick = function(s)

            net.Start("DvRk_safezone_delete")
                net.WriteString(s.id)
            net.SendToServer()

            self.vFrame:Close()

        end

    end

end