local this = ...

require(string.gsub(this, "load$", "") .. "vendor.require")

_G.Class = require.relative(this, "vendor.middleClass")
local ENGINE_CLASS = Class("gEngine")

function ENGINE_CLASS:initialize()
    self.enabledModules = {}
    self.Config = require.relative(this, "config")
    
    require.relative(this, "utility.table")

    if self.Config.useSteam then
        self.Steam = require("luasteam")
        self:EnableModule("Steam")
    end

    if self.Config.useMultiplayer then
        require.relative(this, "vendor.bitser")
        require.relative(this, "vendor.sock")
        self:EnableModule("Multiplayer")
    end

    self.Color = require.relative(this, "type.color")
    self.Vector2 = require.relative(this, "type.vector2")
end

function ENGINE_CLASS:Load()
    if self:IsModuleEnabled("Steam") then
        self.Steam.init()
    end
end

function ENGINE_CLASS:Update(dt)
    if self:IsModuleEnabled("Steam") then
        self.Steam.runCallbacks()
    end
end

function ENGINE_CLASS:Draw() end

function ENGINE_CLASS:Quit()
    local shouldQuit = self:OnQuit()
    if shouldQuit then return true end
    
    if self:IsModuleEnabled("Steam") then
        self.Steam.shutdown()
    end
end

function ENGINE_CLASS:EnableModule(moduleName)
    self.enabledModules[moduleName] = true
    self:OnModuleEnabled(moduleName)
end

function ENGINE_CLASS:DisableModule(moduleName)
    self.enabledModules[moduleName] = false
    self:OnModuleDisabled(moduleName)
end

function ENGINE_CLASS:IsModuleEnabled(moduleName)
    return self.enabledModules[moduleName] or false
end

function ENGINE_CLASS:OnQuit() end
function ENGINE_CLASS:OnModuleEnabled(moduleName) end
function ENGINE_CLASS:OnModuleDisabled(moduleName) end

return ENGINE_CLASS()
