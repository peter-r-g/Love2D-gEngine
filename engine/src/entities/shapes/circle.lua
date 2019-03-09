local entityFolder = string.gsub(..., "shapes.circle$", "")

local BASE = require(entityFolder .. "positioned-entity")

local ENTITY = Class("Entity-Circle", BASE)

function ENTITY:OnEntityCreated(pos, radius, color, mode)
    BASE.OnEntityCreated(self, pos)
    
    self.radius = radius or 1
    self.color = color or gEngine.Color(1, 1, 1, 1)
    self.drawMode = mode or "fill"
end

function ENTITY:SetRadius(radius)
    self.radius = radius
    
    for childId, child in pairs(self.children) do
        child:OnParentRadiusChanged(radius)
    end
end

function ENTITY:GetRadius()
    return self.radius
end

function ENTITY:SetColor(color)
    self.color = color
    
    for childId, child in pairs(self.children) do
        child:OnParentColorChanged(color)
    end
end

function ENTITY:GetColor()
    return self.color
end

function ENTITY:SetDrawMode(mode)
    self.drawMode = mode
end

function ENTITY:GetDrawMode()
    return self.drawMode
end

function ENTITY:Draw()
    love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
    love.graphics.circle(self.drawMode, self.pos.x, self.pos.y, self.radius)
end 

return ENTITY