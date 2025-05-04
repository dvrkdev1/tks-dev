util.AddNetworkString("DvRk_safezone")
util.AddNetworkString("DvRk_safezone_delete")

DSafeZone = DSafeZone or {}
DSafeZone.Cache = DSafeZone.Cache or {}

hook.Add("EntityTakeDamage", "DvRk_safezones_god", function(ply, dmginfo)
    if ply:IsPlayer() and ply.DvRkInSafezone then
        dmginfo:SetDamage(0)
    end
end)

hook.Add("PlayerSpawnObject", "DvRk_safezones_nospawning", function(ply, model, skinNumber )
  if ply.DvRkInSafezone then
    return false
  end
end)

function DvRkSafezoneHandleSpawns()
    local res = sql.Query("CREATE TABLE IF NOT EXISTS DvRk_safezones(pos_one VARCHAR(200), pos_two VARCHAR(200))")
    if res == false then 
        error(sql.LastError())
    end

    res = sql.Query("SELECT *,rowid FROM DvRk_safezones")
    if res == false then
        error(sql.LastError())
    end

    if res and #res > 0 then
        for k,v in pairs(res) do
            p1 = Vector(v["pos_one"])
            p2 = Vector(v["pos_two"])
            local ent = ents.Create("DvRk_safezone")
            ent:SetPos( (p1 + p2) / 2 )
            ent.min = p1
            ent.max = p2
            ent:Spawn()
            ent:SetID(v["rowid"])
            ent:SetEID(ent:EntIndex())
            DSafeZone.Cache[v["rowid"]] = ent:EntIndex()
        end
    end
    print("[DvRk_safezones] Safezones spawned!")
    hook.Remove("PlayerInitialSpawn", "DvRk_safezone_init")
end

hook.Add("PlayerInitialSpawn", "DvRk_safezone_init", DvRkSafezoneHandleSpawns)
hook.Add("PostCleanupMap", "DvRk_safezone_init", DvRkSafezoneHandleSpawns)

function DvRkLeftSafezone(ply)
    ply.DvRkInSafezone = false
    net.Start("DvRk_safezone")
        net.WriteBool(false)
    net.Send(ply)
end

function DvRkEnteredSafezone(ply)
    ply.DvRkInSafezone = true
    net.Start("DvRk_safezone")
        net.WriteBool(true)
    net.Send(ply)
end

function DvRkSaveSafezone(posone, postwo)
    local res = sql.Query("INSERT INTO DvRk_safezones VALUES("..sql.SQLStr(posone)..", "..sql.SQLStr(postwo)..")")
    if res == false then 
        error(sql.LastError())
    end
    if res == nil then print("[DvRk_safezones] Safezone saved successfully!") end
  
    local ent = ents.Create("DvRk_safezone")
    ent:SetPos( (posone + postwo) / 2 )
    ent.min = posone
    ent.max = postwo
    ent:Spawn()

    res = sql.QueryRow("SELECT rowid FROM DvRk_safezones ORDER BY rowid DESC limit 1")
    if res == false then 
        error(sql.LastError())
    end
    ent:SetID(tonumber(res["rowid"]))
    ent:SetEID(ent:EntIndex())
    DSafeZone.Cache[res["rowid"]] = ent:EntIndex()
end

net.Receive("DvRk_safezone_delete", function(len, ply)
    if not ply:IsAdmin() and not ply:IsSuperAdmin() then return end
    local rowid = net.ReadString()
    if not tonumber(rowid) then return end
    res = sql.QueryRow("DELETE FROM DvRk_safezones WHERE rowid = "..rowid)
    if res == false then 
        error(sql.LastError())
    end
    print("[DvRk_safezones] Deleted safezone from DB")
    if DSafeZone.Cache[rowid] then
        local ent = ents.GetByIndex(DSafeZone.Cache[rowid])
        if ent and IsValid(ent) then ent:Remove() end
    end
    print("[DvRk_safezones] Deleted safezone from map")
end)

print("[DvRk_safezones] sv loaded")
