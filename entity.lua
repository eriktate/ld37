require("util")
require("Vector2")

Entity = {}

function Entity:new(pos, width, height, solid)
    local entity = {
        pos = pos,
        originX = 0,
        originY = 0,
        width = width,
        height = height,
        bbox = {
            x = 0,
            y = 0,
            originalWidth = width,
            originalHeight = height,
            width = width,
            height = height,
        },
        gravity = 0,
        speed = 0,
        solid = solid,
        lock = false,
        airborn = false,
        collidables = {},
        devices = {},
        animation = nil
    }
    self.__index = self
    return setmetatable(entity, self)
end

function Entity:draw()
    if self.animation then
        love.graphics.draw(self.animation.spriteBatch, self.pos.x, self.pos.y)
    end
    local x = self.pos.x + self.bbox.x
    local y = self.pos.y + self.bbox.y
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle("line", x, y, self.bbox.width, self.bbox.height)
    love.graphics.setColor(255, 255, 255)
end

function Entity:setBbox(x, y, width, height)
    local bbox = {
        x = x or self.bbox.x,
        y = y or self.bbox.y,
        originalWidth = width or self.bbox.originalWidth,
        originalHeight = height or self.bbox.originHeight,
        width = width or self.bbox.width,
        height = height or self.bbox.height
    }
    self.bbox = bbox
end

function Entity:setOrigin(x, y)
    self.originX = x or self.originX
    self.originY = y or self.originY
    if self.animation then
        self.animation:setOrigin(self.originX, self.originY)
    end
end

function Entity:setAnimationCallback(callback)
    self.animation.done = callback
end

function Entity:checkSide(entity)
    if self.pos.x + self.width/2 > entity.pos.x + entity.width/2 then
        return "left"
    else
        return "right"
    end
end
-- Checks for collisions with solid objects in the collidable list.
function Entity:checkCollision(pos, entities)
    local bbox = {
        left = pos.x + self.bbox.x,
        top = pos.y + self.bbox.y,
        right = pos.x + self.bbox.x + self.bbox.width,
        bottom = pos.y + self.bbox.y + self.bbox.height
    }
    for i, collidable in pairs(entities) do
        if collidable.solid then
            local colBox = {
                left = collidable.pos.x + collidable.bbox.x,
                top = collidable.pos.y + collidable.bbox.y,
                right = collidable.pos.x + collidable.bbox.y + collidable.bbox.width,
                bottom = collidable.pos.y + collidable.bbox.y + collidable.bbox.height
            }
            
            if checkOverlap(bbox, colBox) then
                return collidable
            end
        end
    end
    return nil
end

function Entity:adjustBbox()
    if not self.solid then
        if orientation == 180 or orientation == 0 then
            self.bbox.width = self.bbox.originalHeight
            self.bbox.height = self.bbox.originalWidth
        else
            self.bbox.width = self.bbox.originalWidth
            self.bbox.height = self.bbox.originalHeight
        end
    end
end

-- Returns the horizontal motion vector based on the current normal vector.
function Entity:moveVector()
    return self:normal():turnRight()
end

-- Returns the opposite of the normal vector.
function Entity:groundVector()
    return self:normal():reverse()
end

-- Returns the normal vector with respect to the orientation.
function Entity:normal()
    if orientation == 90 then
        return Vector2:new(0, -1)
    elseif orientation == 0 then
        return Vector2:new(-1, 0)
    elseif orientation == 270 then
        return Vector2:new(0, 1)
    elseif orientation == 180 then
        return Vector2:new(1, 0)
    end
    return Vector2:new(0, -1)
end

function Entity:newAnimation(width, height, frameRate, image)
    local animation = Animation:new(width, height, frameRate, image)
    self.animation = animation
    self.animation.static = self.solid
end

function Entity:addAnimation(name, frames)
    self.animation:add(name, frames)
end

function Entity:setAnimation(name)
    self.animation:set(name)
end

function Entity:update(dt)
    self.animation:update(dt)
    if self.solid or self.lock then
        return
    end
    self:adjustBbox()
    
    if self:checkCollision(self.pos + self:groundVector(), self.collidables) then
        self.airborn = false
    else
        self.airborn = true
    end

    if self.airborn then
        self.speed = self.speed + (self.gravity * dt)
    end

    local mag = self.speed * dt
    WatchList:watch("Mag", mag)
    WatchList:watch("Ground vector", self:groundVector().x..self:groundVector().y)
    local moveVec = self.pos + self:groundVector():scale(mag)
    if self:checkCollision(self.pos + self:groundVector():scale(mag), self.collidables) then
        for i = -1, math.ceil(mag) + 1, 1 do
            if self:checkCollision(Vector2.floor(self.pos) + self:groundVector():scale(i), self.collidables) then
                moveVec = Vector2.floor(self.pos) + self:groundVector():scale(i - 1)
                break
            end
        end

        self.speed = 0
    end
    WatchList:watch("MoveVec", moveVec.x..", "..moveVec.y)
    self.pos = moveVec
end

function checkOverlap(box1, box2)
    local xOverlap = false
    local yOverlap = false
    if ((box1.left >= box2.left) and (box1.left <= box2.right)) or ((box1.right <= box2.right) and (box1.right >= box2.left)) then
        xOverlap = true
    end

    if ((box1.top >= box2.top) and (box1.top <= box2.bottom)) or ((box1.bottom <= box2.bottom) and (box1.bottom >= box2.top)) then
        yOverlap = true
    end
    
    return (xOverlap and yOverlap)
end

return Entity