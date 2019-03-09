require("engine.init")

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

function love.keypressed(key, scanCode, isRepeat)
    gEngine:KeyPressed(key, scanCode, isRepeat)
end

function love.keyreleased(key, scanCode)
    gEngine:KeyReleased(key, scanCode)
end

function love.mousemoved(x, y, dx, dy, isTouch)
    gEngine:MouseMoved(x, y, dx, dy, isTouch)
end

function love.mousepressed(x, y, button, isTouch, presses)
    gEngine:MousePressed(x, y, button, isTouch, presses)
end

function love.mousereleased(x, y, button, isTouch, presses)
    gEngine:MouseReleased(x, y, button, isTouch, presses)
end