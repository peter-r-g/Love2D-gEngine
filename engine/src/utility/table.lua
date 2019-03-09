-- Returns the count of all elements inside a table
function table.count(t)
    local count = 0
    for _, _ in pairs(t) do
        count = count + 1
    end
    return count
end

-- Prints a table. Simple as that
function table.print(tbl, indent)
	if not indent then indent = 0 end
    for k, v in pairs(tbl) do
        formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            -- These are a part of middle class and causes an infinite print
            if k ~= "__declaredMethods" and k ~= "__instanceDict" then
                print(formatting)
                table.print(v, indent+1)
            end
        elseif type(v) == "boolean" then
            print(formatting .. tostring(v))   
        elseif type(v) == "function" then
            print(formatting .. tostring(v))
        elseif type(v) == "userdata" then
            print(formatting .. tostring(v))
        else
            print(formatting .. v)
        end
    end
end