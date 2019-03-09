local BASE = require.relative(..., "panel")

local ENTITY = Class("Entity-UIButton", BASE)

function ENTITY:OnEntityCreated(pos, size, color, drawMode, text, font, textColor)
    BASE.OnEntityCreated(self, pos, size, color, drawMode)
    
    self.text = text or "Click me!"
    self.font = font or gEngine.AssetLoader.Load("font", "DefaultFont", "assets/trebuchet.ttf", 12)
    self.textColor = textColor or gEngine.Color.Black
    self.textPos = gEngine.Vector2(0, 0)
    
    self.textObj = love.graphics.newText(self.font, self.text)
    
    self:UpdateTextPosition()
end

function ENTITY:UpdateTextPosition()
    local newTextPosx, newTextPosy = self:GetCenter()
    newTextPosx = newTextPosx - (self.textObj:getWidth() / 2)
    newTextPosy = newTextPosy - (self.textObj:getHeight() / 2)
    newTextPosx, newTextPosy = newTextPosx - self.pos.x, newTextPosy - self.pos.y
    self.textPos = gEngine.Vector2(newTextPosx, newTextPosy)
end

function ENTITY:SetText(text)
    self.text = text
    self.textObj:set(text)
    self:UpdateTextPosition()
    
    gEngine.Event.Call("Entity.OnTextChanged", self, text)
end

function ENTITY:GetText()
    return self.text
end

function ENTITY:SetFont(font)
    self.font = font
    self.textObj:setFont(font)
    self:UpdateTextPosition()
    
    gEngine.Event.Call("Entity.OnFontChanged", self, font)
end

function ENTITY:GetFont()
    return self.font
end

function ENTITY:SetTextColor(color)
    self.textColor = color
    
    gEngine.Event.Call("Entity.OnTextColorChanged", self, color)
end

function ENTITY:GetTextColor()
    return self.textColor
end

function ENTITY:Draw()
    BASE.Draw(self)
    
    love.graphics.setColor(self.textColor.r, self.textColor.g, self.textColor.b, self.textColor.a)
    love.graphics.draw(self.textObj, self.pos.x + self.textPos.x, self.pos.y + self.textPos.y)
end

return ENTITY