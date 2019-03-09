local BASE = require.relative(..., "base")

local ENTITY = Class("Entity-UIRadioButton", BASE)

function ENTITY:OnEntityCreated(pos, outerRadius, innerRadius, outerColor, innerColor, outerDrawMode, innerDrawMode, active)
    BASE.OnEntityCreated(self, pos)
    
    self.outerRadius = outerRadius or 10
    self.innerRadius = innerRadius or 5
    
    self.outerColor = outerColor or gEngine.Color.White
    self.innerColor = innerColor or gEngine.Color.Black
    
    self.outerDrawMode = outerDrawMode or "fill"
    self.innerDrawMode = innerDrawMode or "fill"
    
    self.active = active or false
end

function ENTITY:IsMouseInArea(x, y)
    return self.pos.x - self.outerRadius < x and self.pos.x + self.outerRadius > x and self.pos.y - self.outerRadius < y and self.pos.y + self.outerRadius > y
end

function ENTITY:SetOuterRadius(radius)
    self.outerRadius = radius
end

function ENTITY:GetOuterRadius()
    return self.outerRadius
end

function ENTITY:SetInnerRadius(radius)
    self.innerRadius = radius
end

function ENTITY:GetInnerRadius()
    return self.innerRadius
end

function ENTITY:SetOuterColor(color)
    self.outerColor = color
end

function ENTITY:GetOuterColor()
    return self.outerColor
end

function ENTITY:SetInnerColor(color)
    self.innerColor = color
end

function ENTITY:GetInnerColor()
    return self.innerColor
end

function ENTITY:SetOuterDrawMode(drawMode)
    self.outerDrawMode = drawMode
end

function ENTITY:GetOuterDrawMode()
    return self.outerDrawMode
end

function ENTITY:SetInnerDrawMode(drawMode)
    self.innerDrawMode = drawMode
end

function ENTITY:GetInnerDrawMode()
    return self.innerDrawMode
end

function ENTITY:SetActive(active)
    self.active = active
end

function ENTITY:IsActive()
    return self.active
end

function ENTITY:Draw()
    love.graphics.setColor(self.outerColor.r, self.outerColor.g, self.outerColor.b, self.outerColor.a)
    love.graphics.circle(self.outerDrawMode, self.pos.x, self.pos.y, self.outerRadius)
    
    if self.active then
        love.graphics.setColor(self.innerColor.r, self.innerColor.g, self.innerColor.b, self.innerColor.a)
        love.graphics.circle(self.innerDrawMode, self.pos.x, self.pos.y, self.innerRadius)
    end
end

function ENTITY:DoClick(this)
    if self.active then
        self:SetActive(false)
    else
        self:SetActive(true)
    end
end

return ENTITY