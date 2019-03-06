local engine = nil

local EVENT = {}

local events = {}

function EVENT:Init(gEngine)
    engine = gEngine
end

function EVENT.Subscribe(eventName, uniqueName, callback)
    if events[eventName] == nil then events[eventName] = {} end
    if events[eventName][uniqueName] then engine:Warn("Module: \"Event\", Subscribe(): An event with that unique name already exists!") return end
    
    events[eventName][uniqueName] = callback
end

function EVENT.Unsubscribe(eventName, uniqueName)
    if events[eventName] == nil then engine:Warn("Module: \"Event\", Unsubscribe(): Tried to unsubscribe from an event with a unique name that doesn't exist!") return end
    
    events[eventName][uniqueName] = nil
end

function EVENT.Call(eventName, ...)
    if events[eventName] == nil then engine:Warn("Module: \"Event\", Call(): Tried to call an event that doesn't exist!") return end
    
    for uniqueName, callback in pairs(events[eventName]) do
        local a, b, c, d, e, f = callback(...)
        
        if a then return a, b, c, d, e, f end
    end
    
    return nil
end

return EVENT