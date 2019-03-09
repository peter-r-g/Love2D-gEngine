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

return MANAGER