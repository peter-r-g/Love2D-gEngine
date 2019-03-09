local LOGGER = {}

local oldPrint = print

_G.print = function(...)
    oldPrint(...)
    LOGGER.Log(...)
end

local log = {}

function LOGGER.Log(...)
    local items = {...}
    
    local logString = ""
    for i=1, #items do
        logString = logString .. tostring(items[i]) .. "\t"
    end
    
    table.insert(log, logString .. "\r\n")
end

function LOGGER.Empty()
    log = {}
end

function LOGGER.DumpToFile()
    local fileString = ""
    for i=1, #log do
        fileString = fileString .. log[i]
    end
    
    local fileName = os.date("gEngine-dump.%Y.%m.%d-%H.%M.%S%p.log", os.time())
    
    local curIdentity = love.filesystem.getIdentity()
    love.filesystem.setIdentity("gEngine")
    
    local success, message = love.filesystem.write(fileName, fileString)
    if success then
        love.filesystem.setIdentity(curIdentity)
        LOGGER.Empty()
    else
        gEngine:Warn("Logger: Failed to dump log to file!")
        LOGGER.DumpToFile()
    end
end

return LOGGER