TKS = TKS or {}
file = file or {}

-- Same as write, but with recursive folder creation
function file.TKS:WriteRecursive(sPath, xData)

    local sFolder = string.GetPathFromFilename(sPath)
    local sBuffer = ""

    for s in string.gmatch(sFolder, "[^/]+") do
        sBuffer = sBuffer .. s .. "/"
        file.CreateDir(sBuffer)
    end

    return file.Write(sPath, x)

end