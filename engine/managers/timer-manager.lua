-- Localize variables
local Steam, Class = Steam, Class

local TIMER = {}

-- Table to hold all timers
TIMER.timers = {}

-- Function to create a one time use function
function TIMER:Simple(seconds, callback, ...)
    -- Setup the timer table
    local timerTable = {}
    -- Set the time
    timerTable.time = seconds
    -- Do not repeat since it is a one time simple timer
    timerTable.repeats = 0
    -- Set the callback
    timerTable.callback = callback
    -- Keep hold of any args that were provided
    timerTable.args = {...}
    
    -- Add the timer to the table
    table.insert(self.timers, timerTable)
end

-- Function to create an advanced timer
function TIMER:Create(uniqueName, seconds, repeats, callback, ...)
    -- If a timer already exists with that name then stop
    if not self.timers[uniqueName] == nil then return end
    
    -- Setup the timer table
    local timerTable = {}
    -- Set the time
    timerTable.time = seconds
    -- Keep track of a seperate time variable for when we need to restart the timer
    timerTable.originalTime = seconds
    -- Set the amount of repeats
    timerTable.repeats = repeats
    -- Set the callback
    timerTable.callback = callback
    -- Flag for if the timer is currently paused
    timerTable.paused = false
    -- Keep hold of any args that were provided
    timerTable.args = {...}
    
    -- Add the timer to the table
    self.timers[uniqueName] = timerTable
end

-- Function that destroys an advanced timer. This also has the possibility to destroy a simple timer but is harder to do correctly
function TIMER:Destroy(uniqueName)
    self.timers[uniqueName] = nil
end

-- Function that returns all of the timers
function TIMER:GetTimers()
    return self.timers
end

-- Function that returns the time left in a timer
function TIMER:GetTimeLeft(uniqueName)
    if self.timers[uniqueName] == nil then return nil end
    return self.timers[uniqueName].time
end

-- Function that returns the progress of the timer
function TIMER:GetTimerProgress(uniqueName)
   if self.timers[uniqueName] == nil then return nil end
   return (self.timers[uniqueName].time / self.timers[uniqueName].originalTime) * 100
end

-- Function that pauses a timer
function TIMER:PauseTimer(uniqueName)
    if self.timers[uniqueName] == nil then return end
    self.timers[uniqueName].paused = true
end

-- Function that unpauses a timer
function TIMER:UnpauseTimer(uniqueName)
    if self.timers[uniqueName] == nil then return end
    self.timers[uniqueName].paused = false
end

-- Function that updates all the timers time and executes the callback if the timer is reached
-- It will then remove the timer after if it doesn't have repeats left
function TIMER:Update(dt)
    -- Loop every timer
    for uniqueName, timerTable in pairs(self:GetTimers()) do
        -- If the timer is paused then just don't bother
        if not timerTable.paused then
            -- Take away dt
            timerTable.time = timerTable.time - dt
                
            -- The timer has finished
            if timerTable.time <= 0 then
                -- Run the callback and give the args we stored earlier
                timerTable.callback(unpack(timerTable.args))
                
                -- Update the repeats
                if timerTable.repeats > 0 then
                    timerTable.repeats = timerTable.repeats - 1
                end
                    
                -- If there are no repeats left then remove the timer
                if timerTable.repeats == 0 then
                    timerTable = nil
                else
                    -- Reset the timer
                    timerTable.time = timerTable.originalTime
                end
            end
        end
    end
end

return TIMER