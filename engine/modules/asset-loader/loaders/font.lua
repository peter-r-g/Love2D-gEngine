local function LoadAsset(assetName, a, b, c)
    return love.graphics.newFont(a, b, c)
end
gEngine.AssetLoader.RegisterLoader("font", LoadAsset)