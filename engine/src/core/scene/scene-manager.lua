local MANAGER = {}

local scenes = {}
local activeScene = nil

local eventsEnabled = false

function MANAGER:Init(gEngine)
    engine = gEngine
    
    eventsEnabled = gEngine:IsModuleEnabled("Event")
end

function MANAGER.AddScene(scene)
    if scenes[scene:GetName()] then gEngine:Warn("Module: \"Scene\", AddScene(): Tried to add a scene with a name that is already registered!") return end
    
    scenes[scene:GetName()] = scene
    
    gEngine.Event.Call("SceneManager.SceneAdded", scene)
end

function MANAGER.ChangeScene(sceneName)
    if scenes[sceneName] == nil then gEngine:Error("Module: \"Scene\", ChangeScene(): Tried to change to a scene that doesn't exist!") return end
    
    if activeScene then
        gEngine.Event.Call("SceneManager.PreSceneExit", activeState)
        activeScene:Exit()
        gEngine.Event.Call("SceneManager.PostSceneExit", activeState)
    end
    
    activeScene = scenes[sceneName]
    
    gEngine.Event.Call("SceneManger.PreSceneEnter", activeState)
    activeScene:Enter()
    gEngine.Event.Call("SceneManager.PostSceneEnter", activeState)
end

function MANAGER.GetActiveScene()
    return activeScene
end

function MANAGER:Update(dt)
    if activeScene then
        if activeScene:IsPaused() then
            activeScene:PausedUpdate(dt)
        else
            activeScene:Update(dt)
        end
    end
end

function MANAGER:Draw()
    if activeScene then
        activeScene:Draw()
    end
end

function MANAGER:MouseMoved(x, y, dx, dy, isTouch)
    local activeScene = MANAGER:GetActiveScene()
    
    if activeScene then
        local uiEntities = activeScene:GetEntitiesByTag("UI")
        
        if uiEntities and table.count(uiEntities) > 0 then
            local currentTarget = nil
            
            for entityId, entity in pairs(uiEntities) do
                if not entity:IsHidden() and entity:IsMouseInArea(x, y) then
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
end

function MANAGER:MousePressed(x, y, button, isTouch, presses)
    local activeScene = MANAGER:GetActiveScene()
    
    if activeScene then
        local uiEntities = activeScene:GetEntitiesByTag("UI")
        
        if uiEntities and table.count(uiEntities) > 0 then
            local currentTarget = nil
            
            for entityId, entity in pairs(uiEntities) do
                if not entity:IsHidden() and entity:IsMouseInArea(x, y) then
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
end

function MANAGER:MouseReleased(x, y, button, isTouch, presses)
    local activeScene = MANAGER:GetActiveScene()
    
    if activeScene then
        local uiEntities = activeScene:GetEntitiesByTag("UI")
        
        if uiEntities and table.count(uiEntities) > 0 then
            local currentTarget = nil
            
            for entityId, entity in pairs(uiEntities) do
                if not entity:IsHidden() and entity:IsMouseInArea(x, y) then
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
end

return MANAGER