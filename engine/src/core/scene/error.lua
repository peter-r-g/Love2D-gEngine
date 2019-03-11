local BASE = require.relative(..., "scene")

local SCENE = Class("Scene-Error", BASE)

function SCENE:Enter()
    BASE.Enter(self)
end

return SCENE