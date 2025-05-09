AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function SWEP:PrimaryAttack()

    local tWeapons = weapons.GetList()
    local tWeapon

    local pOwner = self:GetOwner()

    -- DANS TON NET.RECEIVE
    -- pOwner:SetNW2String("WantedSWEPClass", "suiton_crocs_eau")

    for k,v in pairs(tWeapons) do

        if v.ClassName == pOwner:GetNW2String("WantedSWEPClass", sHoldType) then

            tWeapon = v
            break

        end

    end

    if tWeapon then

        table.Merge(self, tWeapon)
        tWeapon.PrimaryAttack(self)

    end

end

function SWEP:SecondaryAttack()
    return
end