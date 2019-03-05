_G.Class = require("engine.vendor.middleClass")
_G.gEngine = Class("gEngine")
_G.gEngine.static.Config = require("engine.config")

function gEngine:Load()
    require("engine.utility.table")

    if self.Config.useSteam then
        require("luasteam")
    end

    if self.Config.useMultiplayer then
        require("engine.vendor.bitser")
        require("engine.vendor.sock")
    end

    self.Color = require("engine.type.color")
    self.Vector2 = require("engine.type.vector2")
end

function gEngine:Update(dt)

end

function gEngine:Draw()

end

function gEngine:Quit()

end
