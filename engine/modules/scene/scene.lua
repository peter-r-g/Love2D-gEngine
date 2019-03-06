local GAMESTATE = Class("Gamestate-Base")

local engine = nil

function GAMESTATE:Init(gEngine)
    engine = gEngine
end

function GAMESTATE:initialize(name, ...)
    self.name = name or error("Gamestate-Base: Constructor was not given a name")
    self.entities = {}
    self.taggedEntities = {}
    self.drawLayers = {}
        
    self._internalIdTick = 0
    self.paused = false
    
    self:OnGamestateCreated(...)
end

function GAMESTATE:GetName()
    return self.name
end

function GAMESTATE:_GetNewID()
    self._internalIdTick = self._internalIdTick + 1
    return self._internalIdTick
end

function GAMESTATE:Enter()
    if engine:IsModuleEnabled("Event") then
        engine.Event.Subscribe("Object.OnTagAdded", "Gamestate.UpdateEntityTags", function(entity, tag)
            if self.taggedEntities[tag] == nil then self.taggedEntities[tag] = {} end
            self.taggedEntities[tag][entity:GetID()] = entity
        end)
        engine.Event.Subscribe("Object.OnTagRemoved", "Gamestate.UpdateEntityTags", function(entity, tag)
            self.taggedEntities[tag][entity:GetID()] = nil
        end)
        engine.Event.Subscribe("Object.OnDrawLayerChanged", "Gamestate.UpdateDrawLayerTable", function(entity, oldLayer, newLayer)
            self.drawLayers[oldLayer][entity:GetID()] = nil
            
            if self.drawLayers[newLayer] == nil then self.drawLayers[newLayer] = {} end
            self.drawLayers[newLayer][entity:GetID()] = entity
        end)
    end
end

function GAMESTATE:Exit()
    self.entities = {}
    self.taggedEntities = {}
    self._internalIdTick = 0

    engine.Event.Unsubscribe("Object.OnTagAdded", "Gamestate.UpdateEntityTags")
    engine.Event.Unsubscribe("Object.OnTagRemoved", "Gamestate.UpdateEntityTags")
    engine.Event.Unsubscribe("Object.OnDrawLayerChanged", "Gamestate.UpdateDrawLayerTable")
end

function GAMESTATE:Update(dt)
    for id, entity in pairs(self.entities) do
        if not entity:IsPaused() then
            entity:update(dt)
        end
    end
end

function GAMESTATE:Draw()
    for layerNum, entityTbl in ipairs(self.drawLayers) do
        for entityId, entity in pairs(entityTbl) do
            if entity:IsVisible() then
                entity:Draw()
            end
        end
    end
end

function GAMESTATE:GetEntity(id)
    return self.entities[id]
end

function GAMESTATE:GetEntityByName(name)
    for id, entity in pairs(self.entities) do
        if entity.name == name then
            return entity
        end
    end
end

function GAMESTATE:GetEntitiesByTag(tag)
    return self.taggedEntities[tag]
end

function GAMESTATE:GetEntities()
    return self.entities
end

function GAMESTATE:AddEntity(entity)
    entity.id = self:_GetNewID()
    entity.GetID = function(ent) return ent.id end
    
    self.entities[entity:GetID()] = entity
    
    for _, tag in pairs(entity:GetTags()) do
        if self.taggedEntities[tag] == nil then self.taggedEntities[tag] = {} end
        self.taggedEntities[tag][entity:GetID()] = entity
    end
    
    if self.drawLayers[entity:GetDrawLayer()] == nil then self.drawLayers[entity:GetDrawLayer()] = {} end
    self.drawLayers[entity:GetDrawLayer()][entity:GetID()] = entity
    
    self:OnEntityAdded(entity:GetID(), entity)
    engine.Event.Call("Gamestate.OnEntityAdded", self, entity)
end

function GAMESTATE:RemoveEntity(id)
    local entity = self.entities[id]
    if entity then
        entity.id = nil
        entity.GetID = nil
        
        for tag, _ in pairs(entity:GetTags()) do
            if not self.taggedEntities[tag] == nil then
                self.taggedEntities[tag][entity:GetID()] = nil
            end
        end
        
        self.drawLayers[entity:GetDrawLayer()][entity:GetID()] = nil
        
        self:OnEntityRemoved(id, entity)
        engine.Event.Call("Gamestate.OnEntityRemoved", self, id, entity)
        
        self.entities[id] = nil
    end
end

function GAMESTATE:Pause()
    self.paused = true
    
    self:OnPaused()
    engine.Event.Call("Gamestate.OnGamestatePaused", self)
end

function GAMESTATE:Unpause()
    self.paused = false
    
    self:OnUnpaused()
    engine.Event.Call("Gamestate.OnGamestateUnpaused", self)
end

function GAMESTATE:IsPaused()
    return self.paused
end

function GAMESTATE:OnGamestateCreated(...) end
function GAMESTATE:OnEntityAdded(id, entity) end
function GAMESTATE:OnEntityRemoved(id, entity) end
function GAMESTATE:OnWindowResized(w, h) end
function GAMESTATE:OnPaused() end
function GAMESTATE:OnUnpaused() end

function GAMESTATE:PausedUpdate(dt) end

return GAMESTATE