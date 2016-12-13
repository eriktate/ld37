require("util")

Camera = {}

function Camera:new(x, y, scaleX, scaleY, rotation)
    local camera = {
        x = x,
        y = y,
        drawX = x,
        drawY = y,
        shake = false,
        scaleX = scaleX,
        scaleY = scaleY,
        rotation = rotation
    }
    self.__index = self
    return setmetatable(camera, Camera)
end

function Camera:set()
    love.graphics.push()
    love.graphics.translate(640/2, 640/2)
    love.graphics.rotate(-self.rotation)
    love.graphics.translate(-640/2, -640/2)
    love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
    love.graphics.translate(-self.x, -self.y)
end

function Camera:unset()
    love.graphics.pop()
end

function Camera:move(dx, dy)
    self.x = self.x + (dx or 0)
    self.x = self.y + (dy or 0)
end

function Camera:rotate(dr)
    self.rotation = self.rotation + dr
end

function Camera:scale(sx, sy)
    sx = sx or 1
    self.scaleX = self.scaleX * sx
    self.scaleY = self.scaleY * (sy or sx)
end

function Camera:setPosition(x, y)
    self.x = x or self.x
    self.y = y or self.y
end

function Camera:setScale(sx, sy)
    self.scaleX = sx or self.scaleX
    self.scaleY = sy or self.scaleY
end

function Camera:setShake(shake)
    self.shake = shake
end

function Camera:update(dt, follow)
    local x = follow.pos.x - (640 / 2 * self.scaleX)
    local y = follow.pos.y - (640 / 2 * self.scaleY)

    if self.shake then
        x = x - 5 + (math.random() * 10)
        y = y - 5 + (math.random() * 10)
    end
    self:setPosition(x, y)
end


return Camera