local engine = nil

local TIMER = {}

local timers = {}

function TIMER:Init(gEngine)
    engine = gEngine
end

function TIMER.Simple(seconds, callback, ...)
    local timerTbl = {}
    timerTbl.timer = seconds
    timerTbl.repeats = 0
    timerTbl.callback = callback
    timerTbl.args = {...}
    
    table.insert(timers, timerTbl)
end

function TIMER.Create(uniqueName, seconds, repeats, callback, ...)
    if timers[uniqueName] then engine:Warn("Module: \"Timer\", Create(): Tried to create a timer with a unique name that is already in use!") return end
    
    local timerTbl = {}
    timerTbl.timer = seconds
    timerTbl.time = seconds
    timerTbl.repeats = repeats
    timerTbl.callback = callback
    timerTbl.paused = false
    timerTbl.args = {...}
    
    timers[uniqueName] = timerTbl
end

function TIMER.Destroy(uniqueName)
    if timers[uniqueName] == nil then engine:Warn("Module: \"Timer\", Destroy(): Tried to destroy a timer that doesn't exist!") return end
    
    timers[uniqueName] = nil
end

function TIMER.GetTimers()
    return timers
end

function TIMER.GetTimeLeft(uniqueName)
    if timers[uniqueName] == nil then engine:Warn("Module: \"Timer\", GetTimeLeft(): Tried to get the time left in a timer that doesn't exist!") return nil end
    
    return timers[uniqueName].timer
end

function TIMER.GetTimerProgress(uniqueName)
    if timers[uniqueName] == nil then engine:Warn("Module: \"Timer\", GetTimerProgress(): Tried to get the progress in a timer that doesn't exist!") return nil end
    
    return (timers[uniqueName].timer / timers[uniqueName].time) * 100
end

function TIMER.PauseTimer(uniqueName)
    if timers[uniqueName] == nil then engine:Warn("Module: \"Timer\", PauseTimer(): Tried to pause a timer that doesn't exist!") return end
    
    timers[uniqueName].paused = true
end

function TIMER.UnpauseTimer(uniqueName)
    if timers[uniqueName] == nil then engine:Warn("Module: \"Timer\", UnpauseTimer(): Tried to unpause a timer that doesn't exist!") return end
    
    timers[uniqueName].paused = false
end

function TIMER:Update(dt)
    for uniqueName, timerTbl in pairs(timers) do
        if not timerTbl.paused then
            timerTbl.timer = timerTbl.timer - dt
            
            if timerTbl.timer <= 0 then
                timerTbl.callback(unpack(timerTbl.args))
                
                if timerTbl.repeats > 0 then
                    timerTbl.repeats = timerTbl.repeats - 1
                end
                
                if timerTbl.repeats == 0 then
                    timerTbl = nil
                else
                    timerTbl.timer = timerTbl.time
                end
            end
        end
    end
end

return TIMER