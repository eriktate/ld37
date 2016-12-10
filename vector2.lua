Vector2 = {}
-- Might consider mutating Vector instead of returning all new. Just to save on
-- garbag collection time.
function Vector2:new(x, y)
    local vector = {
        x = x,
        y = y
    }
    self.__index = self
    return setmetatable(vector, Vector2)
end

function Vector2.__add(vec1, vec2)
    return Vector2:new(vec1.x + vec2.x, vec1.y + vec2.y)
end

function Vector2:scale(scalar)
    return Vector2:new(self.x * scalar, self.y * scalar)
end

function Vector2:reverse()
    return Vector2:new(-self.x, -self.y)
end