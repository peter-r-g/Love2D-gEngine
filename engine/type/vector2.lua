local VECTOR2 = Class("Vector2")

function VECTOR2:initialize(x, y)
    self[1] = x or 0
    self[2] = y or 0

    self._isVectorClass = true
end

function VECTOR2:Clone()
    return self(self[1], self[2])
end

function VECTOR2:Set(x, y)
    if type(x) == "table" and x._isVectorClass then
        self[1] = x[1]
        self[2] = x[2]
    else
        self[1] = x
        self[2] = y
    end
end

function VECTOR2:Get(mode)
    if mode == "table" then
        return {["x"] = self[1], ["y"] = self[2]}
    else
        return self[1], self[2]
    end
end

function VECTOR2:Floor()
	self[1] = math.floor(self[1])
	self[2] = math.floor(self[2])
end

function VECTOR2:Ceil()
	self[1] = math.ceil(self[1])
	self[2] = math.ceil(self[2])
end

function VECTOR2.__add(lhs, rhs)
	if type(lhs) == "table" and lhs._isVectorClass and type(rhs) and rhs._isVectorClass then
        return VECTOR2(lhs[1] + rhs[1], lhs[2] + rhs[2])
    end
end

function VECTOR2.__sub(lhs, rhs)
    if type(lhs) == "table" and lhs._isVectorClass and type(rhs) and rhs._isVectorClass then
        return self(lhs[1] - rhs[1], lhs[2] - rhs[2])
    end
end

function VECTOR2.__mul(lhs, rhs)
    if type(lhs) == "table" and lhs._isVectorClass and type(rhs) and rhs._isVectorClass then
        return self(lhs[1] * rhs[1], lhs[2] * rhs[2])
    end
end

function VECTOR2.__div(lhs, rhs)
    if type(lhs) == "table" and lhs._isVectorClass and type(rhs) and rhs._isVectorClass then
        return self(lhs[1] / rhs[1], lhs[2] / rhs[2])
    end
end

function VECTOR2.__mod(lhs, rhs)
    if type(lhs) == "table" and lhs._isVectorClass and type(rhs) and rhs._isVectorClass then
        return self(lhs[1] % rhs[1], lhs[2] % rhs[2])
    end
end

function VECTOR2.__pow(lhs, rhs)
    if type(lhs) == "table" and lhs._isVectorClass and type(rhs) and rhs._isVectorClass then
        return self(lhs[1] ^ rhs[1], lhs[2] ^ rhs[2])
    end
end

function VECTOR2.__eq(lhs, rhs)
    if type(lhs) == "table" and lhs._isVectorClass and type(rhs) and rhs._isVectorClass then
        return lhs[1] == rhs[1] and lhs[2] == rhs[2]
    end
end

function VECTOR2.__index(vec, key)
	if key == "x" then
		return vec[1]
	elseif key == "y" then
		return vec[2]
	end
end

function VECTOR2:__tostring()
	return "Vector2: x=" .. self[1] .. ", y=" .. self[2]
end

function VECTOR2.__concat(value1, value2)
	if type(value1) == "table" and value1._isVectorClass then
		return value1:__tostring()..value2
	else
		return value1..value2:__tostring()
	end
end

VECTOR2.static.Zero = VECTOR2(0, 0)

VECTOR2.static.Up = VECTOR2(0, -1)
VECTOR2.static.Down = VECTOR2(0, 1)
VECTOR2.static.Left = VECTOR2(-1, 0)
VECTOR2.static.Right = VECTOR2(1, 0)

VECTOR2.static.RealUp = VECTOR2(0, 1)
VECTOR2.static.RealDown = VECTOR2(0, -1)

return VECTOR2
