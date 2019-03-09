local function LoadAsset(assetName, path)
    return love.graphics.newFont(path)
end
gEngine.AssetLoader.RegisterLoader("font", LoadAsset)