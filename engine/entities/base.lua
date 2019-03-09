local ENTITY = Class("Entity-Base")

function ENTITY:initialize(name, ...)
    self.name = name or "Unknown"
    
    self.tags = {}
    
    self.parent = nil
    self.children = {}
    
    self.layer = 1
    
    self.paused = false
    self.hidden = false
    
    self:OnEntityCreated(...)
    gEngine.Event.Call("Entity.OnCreated", self)
end

function ENTITY:SetName(name)
    self.name = name
    
    gEngine.Event.Call("Entity.OnNameChanged", self, name)
end

function ENTITY:GetName()
    return self.name
end

function ENTITY:SetParent(parent)
    local oldParent = self.parent
    self.parent = parent
    
    self:OnParentChanged(oldParent, parent)
    gEngine.Event.Call("Entity.OnParentChanged", self, oldParent, parent)
end

function ENTITY:GetParent()
    return self.parent
end

function ENTITY:AddChild(child)
    self.children[child:GetID()] = child
    
    self:OnChildAdded(child)
    gEngine.Event.Call("Entity.OnChildAdded", self, child)
end

function ENTITY:RemoveChild(childId)
    self.children[childId] = nil
    
    self:OnChildRemoved(childId)
    gEngine.Event.Call("Entity.OnChildRemoved", self, childId)
end

function ENTITY:AddTag(tag)
    if self.tags[tag] == true then return end
    self.tags[tag] = true
    
    self:OnTagAdded(tag)
    gEngine.Event.Call("Entity.OnTagAdded", self, tag)
end

function ENTITY:HasTag(tag)
    return not not self.tags[tag]
end

function ENTITY:RemoveTag(tag)
    if self.tags[tag] == nil then return end
    self.tags[tag] = nil
    
    self:OnTagRemoved(tag)
    gEngine.Event.Call("Entity.OnTagRemoved", self, tag)
end

function ENTITY:GetTags()
    return self.tags
end

function ENTITY:SetDrawLayer(layerNum)
    local oldLayer = self.layer
    self.layer = layerNum
    
    self:OnDrawLayerChanged(oldLayer, layerNum)
    gEngine.Event.Call("Entity.OnDrawLayerChanged", self, oldLayer, layerNum)
end

function ENTITY:GetDrawLayer()
    return self.layer
end

function ENTITY:Destroy()
    self:OnEntityDestroyed()
    gEngine.Event.Call("Entity.OnDestroyed", self)
end

function ENTITY:Pause()
    self.paused = true

    self:OnPaused()
    gEngine.Event.Call("Entity.OnPaused", self)
end

function ENTITY:Unpause()
    self.paused = false

    self:OnUnpaused()
    gEngine.Event.Call("Entity.OnUnpaused", self)
end

function ENTITY:IsPaused()
    return self.paused
end

function ENTITY:Hide()
    self.hidden = true

    self:OnHidden()
    gEngine.Event.Call("Entity.OnHidden", self)
end

function ENTITY:Show()
    self.hidden = false
    
    self:OnShown()
    gEngine.Event.Call("Entity.OnShown", self)
end

function ENTITY:IsHidden()
    return self.hidden
end

function ENTITY:Disable()
    self:Pause()
    self:Hide()
end

function ENTITY:Enable()
    self:Unpause()
    self:Show()
end

function ENTITY:OnEntityCreated(...) end
function ENTITY:OnEntityDestroyed() end
function ENTITY:OnTagAdded(tag) end
function ENTITY:OnTagRemoved(tag) end
function ENTITY:OnDrawLayerChanged(oldLayer, newLayer) end
function ENTITY:OnPaused() end
function ENTITY:OnUnpaused() end
function ENTITY:OnHidden() end
function ENTITY:OnShown() end
function ENTITY:OnParentChanged(parent) end
function ENTITY:OnChildAdded(child) end
function ENTITY:OnChildRemoved(childId) end

function ENTITY:Update(dt) end
function ENTITY:Draw() end

return ENTITY