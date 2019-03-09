local ASSETLOADER = {}

local assets = {}
local loaders = {}
local isVolatile = false

function ASSETLOADER.Load(assetType, assetName, ...)
    if assets[assetName] then return assets[assetName] end
    
    assetType = string.lower(assetType)
    
    if loaders[assetType] then
        local asset = loaders[assetType](assetName, ...)
        if not isVolatile then
            assets[assetName] = asset
            return assets[assetName]
        end
        return asset
    end
end

function ASSETLOADER.AddAsset(assetName, asset)
    assets[assetName] = asset
end

function ASSETLOADER.RemoveAsset(assetName)
    assets[assetName] = nil
end

function ASSETLOADER.SetVolatile(volatile)
    isVolatile = volatile
end

function ASSETLOADER.IsVolatile()
    return isVolatile
end

function ASSETLOADER.ClearAssets()
    assets = {}
end

function ASSETLOADER.RegisterLoader(assetType, loaderFunc)
    loaders[assetType] = loaderFunc
end

return ASSETLOADER