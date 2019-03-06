local this = ...

require(string.gsub(this, "init$", "") .. "utility.require")

_G.Class = require.relative(this, "utility.middleClass")

local ENGINE_CLASS = Class("gEngine")

function ENGINE_CLASS:initialize()
    self.enabledModules = {}
    
    require.relative(this, "utility.table")
    
    self.Config = require.relative(this, "config")
    
    if self.Config.useColor then
        self.Color = require.relative(this, "modules.data-types.color")
        self:EnableModule("Color")
    end
    
    if self.Config.useVector2 then
        self.Vector2 = require.relative(this, "modules.data-types.vector2")
        self:EnableModule("Vector2")
    end

    if self.Config.useSteam then
        self.Steam = require.relative("binaries.luasteam")
        self:EnableModule("Steam")
    end

    if self.Config.useMultiplayer then
        require.relative(this, "modules.multiplayer.bitser")
        require.relative(this, "modules.multiplayer.sock")
        self:EnableModule("Multiplayer")
    end
    
    if self.Config.useEvent then
        self.Event = require.relative(this, "modules.event")
        self.Event:Init(self)
        self:EnableModule("Event")
    end
    
    if self.Config.useTimer then
        self.Timer = require.relative(this, "modules.timer")
        self.Timer:Init(self)
        self:EnableModule("Timer")
    end
    
    if self.Config.useInput then
        self.Input = require.relative(this, "modules.input")
        self.Input:Init(self)
        self:EnableModule("Input")
    end
    
    if self.Config.useScene then
        self.SceneManager = require.relative(this, "modules.scene.scene-manager")
        self.Scene = require.relative(this, "modules.scene.scene")
        self:EnableModule("Scene")
    end
    
    if self:IsModuleEnabled("Event") then
        self.Event.Call("OnEngineInitialized", self)
    end
end

function ENGINE_CLASS:Load()
    if self:IsModuleEnabled("Event") then
        self.Event.Call("OnEngineStartedLoading", self)
    end
    
    if self:IsModuleEnabled("Steam") then
        self.Steam.init()
    end
    
    if self:IsModuleEnabled("Event") then
        self.Event.Call("OnEngineFinishedLoading", self)
    end
end

function ENGINE_CLASS:Update(dt)
    if self:IsModuleEnabled("Steam") then
        self.Steam.runCallbacks()
    end
    
    if self:IsModuleEnabled("Timer") then
        self.Timer:Update(dt)
    end
    
    if self:IsModuleEnabled("Scene") then
        self.SceneManager:Update(dt)
    end
end

function ENGINE_CLASS:Draw() 
    if self:IsModuleEnabled("Scene") then
        self.SceneManager:Draw()
    end
end

function ENGINE_CLASS:Quit()
    local shouldQuit = self:OnQuit() or self.Event.Call("OnGameQuit", self)
    if shouldQuit then return true end
    
    if self:IsModuleEnabled("Steam") then
        self.Steam.shutdown()
    end
end

function ENGINE_CLASS:KeyPressed(key, scanCode, isRepeat)
    if self:IsModuleEnabled("Input") then
        self.Input:KeyPressed(key, scanCode, isRepeat)
    end
end

function ENGINE_CLASS:KeyReleased(key, scanCode)
    if self:IsModuleEnabled("Input") then
        self.Input:KeyReleased(key, scanCode, isRepeat)
    end
end

function ENGINE_CLASS:MousePressed(x, y, button, isTouch, presses)
    if self:IsModuleEnabled("Input") then
        self.Input:MousePressed(x, y, button, isTouch, presses)
    end
end

function ENGINE_CLASS:MouseReleased(x, y, button, isTouch, presses)
    if self:IsModuleEnabled("Input") then
        self.Input:MouseReleased(x, y, button, isTouch, presses)
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

return ENGINE_CLASS()
