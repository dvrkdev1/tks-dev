TKS = TKS or {}
local mBlur = Material("pp/blurscreen")

function surface.TKS:Blur(x, y, w, h, iMultiplier)

    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(mBlur)

    for i = 1, 3 do

        mBlur:SetFloat("$blur", (i / 3) * (iMultiplier or 6))
        mBlur:Recompute()

        render.SetScissorRect(x, y, x + w, y + h, true)
            render.UpdateScreenEffectTexture()
            surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
        render.SetScissorRect(0, 0, 0, 0, false)

    end

end