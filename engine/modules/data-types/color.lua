local COLOR = Class("Color")

function COLOR:initialize(r, g, b, a)
    self[1] = r or 1
    self[2] = g or 1
    self[3] = b or 1
    self[4] = a or 1

    self._isColorClass = true
end

function COLOR:Clone()
    return self(self[1], self[2], self[3], self[4])
end

function COLOR:Set(r, g, b, a)
    if type(r) == "table" and r._isColorClass then
        self[1] = r[1]
        self[2] = r[2]
        self[3] = r[3]
        self[4] = r[4]
    else
        self[1] = r
        self[2] = g
        self[3] = b
        self[4] = a
    end
end

function COLOR:Get(mode)
    if mode == "table" then
        return {["r"] = self[1], ["g"] = self[2], ["b"] = self[3], ["a"] = self[4]}
    else
        return self[1], self[2], self[3], self[4]
    end
end

function COLOR.__eq(lhs, rhs)
	return lhs[1] == rhs[1] and lhs[2] == rhs[2] and lhs[3] == rhs[3] and lhs[4] == rhs[4]
end

function COLOR.__index(color, key)
	if key == "r" then
		return color[1]
	elseif key == "g" then
		return color[2]
	elseif key == "b" then
		return color[3]
	elseif key == "a" then
		return color[4]
	end
end

function COLOR:__tostring()
	return "Color: r=" .. self[1] .. ", g=" .. self[2] .. ", b=" .. self[3] .. ", a=" .. self[4]
end

function COLOR.__concat(value1, value2)
	if type(value1) == "table" and value1._isColorClass then
		return value1:__tostring()..value2
	else
		return value1..value2:__tostring()
	end
end

COLOR.static.Black = COLOR(0, 0, 0, 1)
COLOR.static.White = COLOR(1, 1, 1, 1)
COLOR.static.Red = COLOR(1, 0, 0, 1)
COLOR.static.Green = COLOR(0, 1, 0, 1)
COLOR.static.Blue = COLOR(0, 0, 1, 1)
COLOR.static.Transparent = COLOR(0, 0, 0, 0)

return COLOR
