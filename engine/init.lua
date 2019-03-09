local this = ...

require(string.gsub(this, "init$", "") .. "vendor.require")

_G.Class = require.relative(this, "vendor.middleClass")

local ENGINE_CLASS = Class("gEngine")

function ENGINE_CLASS:initialize()
    if _G._GetEngine then error("[gEngine] [FATAL] Tried to create an engine when one already exists!") end
    _G._GetEngine = function() return self end
    
    self.enabledModules = {}
end

function ENGINE_CLASS:Load()
    require.relative(this, "utility.table")
    
    self.Config = require.relative(this, "config")
    
    self.Color = require.relative(this, "modules.data-types.color")
    self.Vector2 = require.relative(this, "modules.data-types.vector2")
    
    if self.Config.useSteam then
        self.Steam = require.relative(this, "binaries.luasteam")
        self:EnableModule("Steam")
    end

    if self.Config.useMultiplayer then
        require.relative(this, "vendor.bitser")
        require.relative(this, "vendor.sock")
        self:EnableModule("Multiplayer")
    end
    
    self.Event = require.relative(this, "modules.event")
    self.Timer = require.relative(this, "modules.timer")
    self.Input = require.relative(this, "modules.input")
    
    self.SceneManager = require.relative(this, "modules.scene.scene-manager")
    self.Scene = require.relative(this, "modules.scene.scene")
    
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

function ENGINE_CLASS:MousePressed(x, y, button, isTouch, presses)
    self.Input:MousePressed(x, y, button, isTouch, presses)
end

function ENGINE_CLASS:MouseReleased(x, y, button, isTouch, presses)
    self.Input:MouseReleased(x, y, button, isTouch, presses)
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
