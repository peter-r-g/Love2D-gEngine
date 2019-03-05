-- Localize variables
local Steam, Class, Timer, EventManager, InputManager = Steam, Class, Timer, EventManager, InputManager

local MANAGER = {}

-- Table to hold all gamestates
MANAGER.gamestates = {}
-- Variables to hold the current running gamestate
MANAGER.activeState = nil

-- Function to add a gamestate to the manager
function MANAGER:AddGamestate(gamestate)
    -- Add the gamestate to the manager and index it by its name
    self.gamestates[gamestate:GetName()] = gamestate
    -- Call an event to let the game know that a gamestate was added
    EventManager:Call("GamestateManager.OnGamestateAdded",  gamestate)
end

-- Function to switch to a new gamestate
function MANAGER:Switch(name)
    -- If the gamestate does not exist then get out
    if self.gamestates[name] == nil then error("Gamestate Manager Switch(): Name is not associated with a valid gamestate!") end
    local activeState = self:GetActiveState()
    
    -- If there is a current active state then exit from it and run some events for the game to know about
    if activeState then
        EventManager:Call("GamestateManager.PreGamestateExit", activeState)
        activeState:Exit()
        EventManager:Call("GamestateManager.PostGamestateExit", activeState)
    end

    -- Set the new active state
    self.activeState = self.gamestates[name]
    
    -- Run events to let the game know that the gamestate is now entering
    EventManager:Call("GamestateManager.PreGamestateEnter", self.activeState)
    -- Run the gamestates enter function
    self.activeState:Enter()
    EventManager:Call("GamestateManager.PostGamestateEnter", self.activeState)
end

-- Function to return the current active state
function MANAGER:GetActiveState()
    return self.activeState
end

-- Function to update the current active state
function MANAGER:Update(dt)
    local activeState = self:GetActiveState()

    if activeState then
        -- If its paused then we don't want to run the default update so that it looks like its paused. We'll run PausedUpdate
        -- instead in case the gamestate wants to do something special while paused like a pause menu
        if activeState:IsPaused() then
            activeState:PausedUpdate(dt)
        else
            activeState:Update(dt)
        end
    end
end

-- Function to draw the current active state
function MANAGER:Draw()
    local activeState = self:GetActiveState()

    if activeState then
        activeState:Draw()
    end
end

EventManager:Subscribe("MouseMoved", "UI.CheckMousePosition", function(x, y, dx, dy, isTouch)
    local activeState = MANAGER:GetActiveState()
    
    if activeState then
        local uiEntities = activeState:GetEntitiesByTag("UI")
        
        if uiEntities and table.count(uiEntities) > 0 then
            local currentTarget = nil
            
            for entityId, entity in pairs(uiEntities) do
                if entity:IsVisible() and entity:IsMouseInArea(x, y) then
                    if currentTarget == nil then
                       currentTarget = entity
                    else
                        if entity:GetDrawLayer() > currentTarget:GetDrawLayer() then
                            currentTarget = entity
                        end
                    end
                else
                    if entity:IsHovered() and not entity:IsClicked() then
                        entity.isHovered = false
                        entity:OffHovered()
                    end
                end
            end
            
            if currentTarget and not currentTarget:IsHovered() and not currentTarget:IsClicked() then
                currentTarget.isHovered = true
                currentTarget:OnHovered(x, y, dx, dy, isTouch)
            end
        end
    end
end)

EventManager:Subscribe("MousePressed", "UI.CheckMouseClick", function(x, y, button, isTouch, presses)
    local activeState = MANAGER:GetActiveState()
    
    if activeState then
        local uiEntities = activeState:GetEntitiesByTag("UI")
        
        if uiEntities and table.count(uiEntities) > 0 then
            local currentTarget = nil
            
            for entityId, entity in pairs(uiEntities) do
                if entity:IsVisible() and entity:IsMouseInArea(x, y) then
                    if currentTarget == nil then
                       currentTarget = entity
                    else
                        if entity:GetDrawLayer() > currentTarget:GetDrawLayer() then
                            currentTarget = entity
                        end
                    end
                end
            end
            
            if currentTarget then
                if currentTarget:IsHovered() then
                    currentTarget.isHovered = false
                    currentTarget:OffHovered()
                end
                currentTarget.isClicked = true
                currentTarget:OnClicked(x, y, dx, dy, isTouch)
            end
        end
    end
end)

EventManager:Subscribe("MouseReleased", "UI.CheckMouseClick", function(x, y, button, isTouch, presses)
    local activeState = MANAGER:GetActiveState()
    
    if activeState then
        local uiEntities = activeState:GetEntitiesByTag("UI")
        
        if uiEntities and table.count(uiEntities) > 0 then
            local currentTarget = nil
            
            for entityId, entity in pairs(uiEntities) do
                if entity:IsVisible() and entity:IsMouseInArea(x, y) then
                    if currentTarget == nil then
                       currentTarget = entity
                    else
                        if entity:GetDrawLayer() > currentTarget:GetDrawLayer() then
                            currentTarget = entity
                        end
                    end
                else
                    if entity:IsClicked() then
                        entity.isClicked = false
                        entity:OffClicked()
                    end
                end
            end
            
            if currentTarget and currentTarget:IsClicked() then
                currentTarget.isClicked = false
                currentTarget:OffClicked(x, y, dx, dy, isTouch)
                currentTarget:DoClick(x, y, dx, dy, isTouch)
            end
        end
    end
end)

return MANAGER