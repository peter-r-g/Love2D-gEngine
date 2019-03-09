local this = ...

require(string.gsub(this, "init$", "") .. "src.vendor.require")

_G.Class = require.relative(this, "src.vendor.middleClass")

local ENGINE_CLASS = Class("gEngine")

function ENGINE_CLASS:initialize()
    if _G._GetEngine then error("[gEngine] [FATAL] Tried to create an engine when one already exists!") end
    _G._GetEngine = function() return self end
    
    self.enabledModules = {}
    self.entityIdTick = 0
end

function ENGINE_CLASS:Load()
    require.relative(this, "src.utility.table")
    
    self.Config = require.relative(this, "config")
    
    self.Logger = require.relative(this, "src.core.logger")
    
    self.Color = require.relative(this, "src.data-types.color")
    self.Vector2 = require.relative(this, "src.data-types.vector2")
    self.JSON = require.relative(this, "src.vendor.json")
    
    if self.Config.useSteam then
        self.Steam = require("luasteam")
        self:EnableModule("Steam")
    end

    if self.Config.useMultiplayer then
        require.relative(this, "src.vendor.bitser")
        self.Multiplayer = require.relative(this, "src.vendor.sock")
        self:EnableModule("Multiplayer")
    end
    
    self.AssetLoader = require.relative(this, "src.core.asset-loader.asset-loader")
    require.relative(this, "src.core.asset-loader.asset-loaders")
    
    self.Event = require.relative(this, "src.core.event")
    self.Timer = require.relative(this, "src.core.timer")
    self.Input = require.relative(this, "src.core.input")
    
    self.SceneManager = require.relative(this, "src.core.scene.scene-manager")
    self.Scene = require.relative(this, "src.core.scene.scene")
    
    self.Entity = require.relative(this, "src.entities.base")
    
    if self:IsModuleEnabled("Steam") then
        self.Steam.init()
    end
    
    self.Event.Call("Engine.FinishedLoading", self)
end

function ENGINE_CLASS:Update(dt)
    if self:IsModuleEnabled("Steam") then
        self.Steam.runCallbacks()
    end
    
    self.Timer:Update(dt)
    
    self.SceneManager:Update(dt)
end

function ENGINE_CLASS:Draw() 
    self.SceneManager:Draw()
end

function ENGINE_CLASS:Quit()
    local shouldQuit = self:OnQuit() or self.Event.Call("Game.OnQuit", self)
    if shouldQuit then return true end
    
    self.Logger.DumpToFile()
    
    if self:IsModuleEnabled("Steam") then
        self.Steam.shutdown()
    end
end

function ENGINE_CLASS:KeyPressed(key, scanCode, isRepeat)
    self.Input:KeyPressed(key, scanCode, isRepeat)
end

function ENGINE_CLASS:KeyReleased(key, scanCode)
    self.Input:KeyReleased(key, scanCode, isRepeat)
end

function ENGINE_CLASS:MouseMoved(x, y, dx, dy, isTouch)
    self.SceneManager:MouseMoved(x, y, dx, dy, isTouch)
end

function ENGINE_CLASS:MousePressed(x, y, button, isTouch, presses)
    self.Input:MousePressed(x, y, button, isTouch, presses)
    self.SceneManager:MousePressed(x, y, button, isTouch, presses)
end

function ENGINE_CLASS:MouseReleased(x, y, button, isTouch, presses)
    self.Input:MouseReleased(x, y, button, isTouch, presses)
    self.SceneManager:MouseReleased(x, y, button, isTouch, presses)
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

function ENGINE_CLASS:GetNewEntityID()
    self.entityIdTick = self.entityIdTick + 1
    return self.entityIdTick
end

function ENGINE_CLASS:Warn(message)
    if self.Config.useWarnings then
        print("[gEngine] [WARNING] " .. message)
    end
end

function ENGINE_CLASS:Error(message)
    error("[gEngine] [ERROR] " .. message)
end

function ENGINE_CLASS:OnQuit() end
function ENGINE_CLASS:OnModuleEnabled(moduleName) end
function ENGINE_CLASS:OnModuleDisabled(moduleName) end

_G.gEngine = ENGINE_CLASS()
