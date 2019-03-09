local BASE = require.relative(..., "base")

local ENTITY = Class("Entity-UIPanel", BASE)

function ENTITY:OnEntityCreated(pos, size, color, drawMode)
    BASE.OnEntityCreated(self, pos)
    
    self.size = size or gEngine.Vector2(10, 10)
    self.color = color or gEngine.Color.White
    self.drawMode = drawMode or "fill"
end

function ENTITY:IsMouseInArea(x, y)
    return self.pos.x < x and self.pos.y < y and self.pos.x + self.size.x > x and self.pos.y + self.size.y > y
end

function ENTITY:SetSize(size)
    self.size = size
    
    for childId, child in pairs(self.children) do
        child:OnParentSizeChanged(size)
    end
end

function ENTITY:GetSize()
    return self.size
end

function ENTITY:GetCenter()
    return gEngine.Vector2(self.pos.x + (self.size.x / 2), self.pos.y + (self.size.y / 2))
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
    love.graphics.rectangle(self.drawMode, self.pos.x, self.pos.y, self.size.x, self.size.y)
end 

return ENTITY