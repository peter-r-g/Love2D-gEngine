local BASE = require.relative(..., "base")

local ENTITY = Class("Entity-Positioned", BASE)

function ENTITY:OnEntityCreated(pos)
    BASE.OnEntityCreated(self)
    
    self.pos = pos or gEngine.Vector2(0, 0)
end

function ENTITY:SetPos(pos)
    self.pos = pos
    
    for childId, child in pairs(self.children) do
        child:OnParentPosChanged(pos)
    end
end

function ENTITY:GetPos()
    return self.pos
end

function ENTITY:OnParentPosChanged(pos)
    self:SetPos(self.pos + pos)
end

return ENTITY