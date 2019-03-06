_G.gEngine = require("engine.init")

function love.load()
    gEngine:Load()
end

function love.update(dt)
    gEngine:Update(dt)
end

function love.draw()
    gEngine:Draw()
end

function love.quit()
    gEngine:Quit()
end
