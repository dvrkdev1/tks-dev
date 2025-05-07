TKS = TKS or {}

print([[

    --------------------------------
    |             DvRk             |
    |          TKS - 2025          |
    |          Version 1.0         |
    --------------------------------

]])

local fcLoadFiles = function(sPath, sLocation, sType)

    local tFiles = file.Find(sPath .. "/*.lua", "LUA")
    if not tFiles or #tFiles == 0 then

        MsgC(Color(255, 0, 0), "[TKS - Error] No " .. sLocation .. " files found in " .. sPath .. "\n")
        return

    end

    for _, sFileName in ipairs(tFiles) do

        local sFullPath = sPath .. "/" .. sFileName

        if sType == "SHARED" then

            if SERVER then AddCSLuaFile(sFullPath) end
            include(sFullPath)

        elseif sType == "CLIENT" then

            if SERVER then AddCSLuaFile(sFullPath) end
            if CLIENT then include(sFullPath) end

        elseif sType == "SERVER" then

            if SERVER then include(sFullPath) end

        end

        local cColor = sType == "SHARED" and Color(255, 0, 0) or sType == "CLIENT" and Color(255, 196, 0) or Color(0, 102, 255)
        MsgC(cColor, "[TKS - " .. sLocation .. "] [" .. sType .. "] " .. sFileName .. "\n")

    end

end

local fcLoadCoreFunctions = function()

    fcLoadFiles("tks/functions/sh", "functions", "SHARED")
    fcLoadFiles("tks/functions/cl", "functions", "CLIENT")
    fcLoadFiles("tks/functions/sv", "functions", "SERVER")

end

local fcLoadModules = function(sBaseDir)

    sBaseDir = sBaseDir or "tks/modules"

    local _, tFolders = file.Find(sBaseDir .. "/*", "LUA")
    if not tFolders or #tFolders == 0 then

        MsgC(Color(255, 0, 0), "[TKS - Error] No folders found in " .. sBaseDir .. "\n")
        return

    end

    for _, sFolder in ipairs(tFolders) do

        MsgC(Color(255, 0, 0), "[TKS - Debug] Checking folder: " .. sFolder .. "\n")
        fcLoadFiles(sBaseDir .. "/" .. sFolder .. "/shared", "modules", "SHARED")
        fcLoadFiles(sBaseDir .. "/" .. sFolder .. "/client", "modules", "CLIENT")
        fcLoadFiles(sBaseDir .. "/" .. sFolder .. "/server", "modules", "SERVER")

    end

end

fcLoadCoreFunctions()
fcLoadModules()

PrintTable(TKS)
MsgC(Color(251, 255, 0), "[TKS - LoadCore] Finished loading !!\n")