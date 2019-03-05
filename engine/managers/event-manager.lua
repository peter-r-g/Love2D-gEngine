-- Localize variables
local Steam, Class, Timer = Steam, Class, Timer

local MANAGER = {}

-- Table to hold all of the events
MANAGER.events = {}

-- Function to "subscribe" to an event
-- This adds a callback to an event that will be executed when the event is called
function MANAGER:Subscribe(eventName, uniqueName, callback)
    -- If the event table does not yet exist then create it to prevent an error
    if self.events[eventName] == nil then self.events[eventName] = {} end
    -- Check to see if the subscription already exists
    if self.events[eventName][uniqueName] then error("Event Manager Subscribe(): Event with that unique name already exists!") end
    -- Add the subscription
    self.events[eventName][uniqueName] = callback
end

-- Function to "unsubscribe" to an event
-- This removes a callback from an event so that it no longer is executed
function MANAGER:Unsubscribe(eventName, uniqueName)
    -- Check if the subscription does not exist. If it doesn't then don't bother continuing
    if self.events[eventName] == nil then return end
    -- Remove the subscription
    self.events[eventName][uniqueName] = nil
end

-- Function to "call" an event
-- This will execute every callback under the event name and pass them all the variables provided to the function
function MANAGER:Call(eventName, ...)
    -- If the event table does not exist then ignore it
    if self.events[eventName] == nil then return end

    -- Loop through every callback
    for uniqueName, callback in pairs(self.events[eventName]) do
        -- Execute the callback and give them all of the variables provided
        local a, b, c, d, e, f = callback(unpack({...}))
        -- If "a" is set then a callback needs to provide information to the caller. So we stop and return the values
        if a then return a, b, c, d, e, f end
    end
    
    -- Just return nil if nothing happened
    return nil
end

-- Function that returns all events
function MANAGER:GetEvents()
    return self.events
end

return MANAGER