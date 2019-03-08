local GAMESTATE = Class("Scene-Base")

function GAMESTATE:initialize(name, ...)
    self.name = name or error("Scene-Base: Constructor was not given a name")
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
    gEngine.Event.Subscribe("Entity.OnTagAdded", "Scene.UpdateEntityTags", function(entity, tag)
        if self.taggedEntities[tag] == nil then self.taggedEntities[tag] = {} end
        self.taggedEntities[tag][entity:GetID()] = entity
    end)
    gEngine.Event.Subscribe("Entity.OnTagRemoved", "Scene.UpdateEntityTags", function(entity, tag)
        self.taggedEntities[tag][entity:GetID()] = nil
    end)
    gEngine.Event.Subscribe("Entity.OnDrawLayerChanged", "Scene.UpdateDrawLayerTable", function(entity, oldLayer, newLayer)
        self.drawLayers[oldLayer][entity:GetID()] = nil
            
        if self.drawLayers[newLayer] == nil then self.drawLayers[newLayer] = {} end
        self.drawLayers[newLayer][entity:GetID()] = entity
    end)
end

function GAMESTATE:Exit()
    self.entities = {}
    self.taggedEntities = {}
    self._internalIdTick = 0

    gEngine.Event.Unsubscribe("Entity.OnTagAdded", "Scene.UpdateEntityTags")
    gEngine.Event.Unsubscribe("Entity.OnTagRemoved", "Scene.UpdateEntityTags")
    gEngine.Event.Unsubscribe("Entity.OnDrawLayerChanged", "Scene.UpdateDrawLayerTable")
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
    gEngine.Event.Call("Scene.OnEntityAdded", self, entity)
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
        gEngine.Event.Call("Scene.OnEntityRemoved", self, id, entity)
        
        self.entities[id] = nil
    end
end

function GAMESTATE:Pause()
    self.paused = true
    
    self:OnPaused()
    gEngine.Event.Call("Scene.OnGamestatePaused", self)
end

function GAMESTATE:Unpause()
    self.paused = false
    
    self:OnUnpaused()
    gEngine.Event.Call("Scene.OnGamestateUnpaused", self)
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