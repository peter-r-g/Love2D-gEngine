local entityFolder = string.gsub(..., "ui.base$", "")

local BASE = require(entityFolder .. "positioned-entity")

local ENTITY = Class("Entity-UIBase", BASE)

function ENTITY:OnEntityCreated(pos)
    BASE.OnEntityCreated(self, pos)
    
    self:AddTag("UI")
    
    self.isClicked = false
    self.isHovered = false
end

function ENTITY:IsHovered()
    return self.isHovered
end

function ENTITY:IsClicked()
    return self.isClicked
end

function ENTITY:IsMouseInArea(x, y) end

function ENTITY:OffHovered() end
function ENTITY:OnHovered() end
function ENTITY:OffClicked() end
function ENTITY:OnClicked() end
function ENTITY:DoClick() end

return ENTITY