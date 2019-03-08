local MANAGER = {}

local scenes = {}
local activeState = nil

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
    
    if activeState then
        gEngine.Event.Call("SceneManager.PreSceneExit", activeState)
        activeState:Exit()
        gEngine.Event.Call("SceneManager.PostSceneExit", activeState)
    end
    
    activeState = scenes[sceneName]
    
    gEngine.Event.Call("SceneManger.PreSceneEnter", activeState)
    activeState:Enter()
    gEngine.Event.Call("SceneManager.PostSceneEnter", activeState)
end

function MANAGER.GetActiveState()
    return activeState
end

function MANAGER:Update(dt)
    if activeState then
        if activeState:IsPaused() then
            activeState:PausedUpdate(dt)
        else
            activeState:Update(dt)
        end
    end
end

function MANAGER:Draw()
    if activeState then
        activeState:Draw()
    end
end

return MANAGER