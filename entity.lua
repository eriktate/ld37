require("util")
require("Vector2")

Entity = {}

function Entity:new(pos, width, height, solid)
    local entity = {
        pos = pos,
        width = width,
        height = height,
        bbox = {
            x = 0,
            y = 0,
            width = width,
            height = height,
        },
        gravity = 0,
        solid = solid,
        airborn = false,
        collidables = {},
        animation = {}
    }
    self.__index = self
    return setmetatable(entity, self)
end

function Entity:draw()
    if next(self.animation) ~= nil then
        love.graphics.draw(self.animation.spriteBatch, self.pos.x, self.pos.y)
    end
end

function Entity:setBbox(x, y, width, height)
    self.bbox = {
        x = x,
        y = y,
        width = width,
        height = height
    }
end

-- Checks for collisions with solid objects in the collidable list.
function Entity:checkCollision(pos)
    local bbox = {
        left = pos.x + self.bbox.x,
        top = pos.y + self.bbox.y,
        right = pos.x + self.bbox.x + self.bbox.width,
        bottom = pos.y + self.bbox.y + self.bbox.height
    }
    for i, collidable in pairs(self.collidables) do
        if collidable.solid then
            local colBox = {
                left = collidable.pos.x + collidable.bbox.x,
                top = collidable.pos.y + collidable.bbox.y,
                right = collidable.pos.x + collidable.bbox.y + collidable.bbox.width,
                bottom = collidable.pos.y + collidable.bbox.y + collidable.bbox.height
            }

            if checkOverlap(bbox, colBox) then
                return true
            end
        end
    end
    return false
end

-- Returns the horizontal motion vector based on the current normal vector.
function Entity:motionVector()
    local vector = self:normal()
    vector.x = -vector.y
    vector.y = x
end

-- Returns the opposite of the normal vector.
function Entity:groundVector()
    return self:normal():reverse()
end

-- Returns the normal vector with respect to the orientation.
function Entity:normal()
    if orientation = 90 then
        return {x = 0, y = -1}
    elseif orientation = 180 then
        return {x = -1, y = 0}
    elseif orientation = 270 then
        return {x = 0, y = 1}
    elseif orientation = 0 then
        return {x = 1, y = 0}
    end
    return {x = 0, y = -1}
end

function Entity:addAnimation(name, frames)
    self.animation:add(name, frames)
end

function Entity:setAnimation(name)
    self.animation:set(name)
end

function Entity:update(dt)
    self.animation:update(dt)
    if self:checkCollision(self.pos + self:groundVector()) then
        self.airborn = false
    else
        self.airborn = true
    end

    if self.airborn then
        self.speed = self.speed + (self.gravity * dt)
    end

    local mag = self.speed * dt
    if self:checkCollision(self.pos + self:groundVector():scale(mag)) then
        for i = 0, math.ceil(mag) + 1, 1 do
            if self:checkCollision(self.pos + self:groundVector():scale(mag)) then
                mag = i -1
                break
            else
                mag = i
            end
        end

        self.speed = 0
    end

    self.pos = self.pos + self:groundVector():scale(mag)
end

function checkOverlap(box1, box2)
    local xOverlap = false
    local yOverlap = false
    if ((box1.left >= box2.left) and (box1.left <= box2.right)) or ((box1.right <= box2.right) and (box1.right >= box2.left)) then
        xOverlap = true
    end

    if ((box1.top >= box2.top) and (box1.top <= box2.bottom)) or ((box1.bottom <= box2.bottom) and (box1.bottom > box2.top)) then
        yOverlap = true
    end
    
    return (xOverlap and yOverlap)
end

return Entity