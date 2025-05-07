TKS = TKS or {}

function TKS:DrawStencilMask(fcMask, fcRender, bInvert)

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