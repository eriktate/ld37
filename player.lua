require("Entity")
require("Animation")
Player = {}

function Player:new(pos, width, height, speed, image)
    local player = Entity:new(pos, width, height, false)
    player.speed = speed
    player.image = image
    player.animation = Animation:new(width, height, 10, image)
    player.gravity = 200
    player.jumpHeight = 100
    player.jumping = false

    player:addAnimation("idle", {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2})
    player:addAnimation("run", {5, 6, 7, 8})
    player:addAnimation("jump", {9})
    player:addAnimation("fall", {10})
    player:addAnimation("lookup", {13})
    player:addAnimation("lookdown", {14})
    player:addAnimation("push", {17, 18})
    player:addAnimation("pull", {17, 19})
    player:addAnimation("death", {21, 22, 21, 22, 21, 23, 23, 23, 23})
    player:setAnimation("idle")
    return setmetatable(self, { __index = player})
end

function Player:update(dt)
    if love.keyboard.isDown("w") and not self.jumping then
        if not self.airborn then
            self.vspeed = -self.jumpHeight
            self.jumping = true
        end
    end

    if not love.keyboard.isDown("w") then
        self.jumping = false
    end
    
    if love.keyboard.isDown("d") then
        self:moveRight(dt)
        self.animation.xscale = 1
        self:setAnimation(self:airbornState() or "run")
    elseif love.keyboard.isDown("a") then
        self:moveLeft(dt)
        self.animation.xscale = -1
        self:setAnimation(self:airbornState() or "run")
    else
        self:setAnimation(self:airbornState() or "idle")
    end
    
    Entity.update(self, dt)
end

function Player:airbornState()
    if self.airborn then
        if self.vspeed <= 0 then
            return "jump"
        end
        return "fall"
    end
    return nil
end

function Player:moveRight(dt)
    local newX = self.pos.x + (self.speed * dt)

    if not self:checkCollision({x = newX, y = self.pos.y}) then
        self.pos.x = newX
    end
end

function Player:moveLeft(dt)
    local newX = self.pos.x - (self.speed * dt)

    if not self:checkCollision({x = newX, y = self.pos.y}) then
        self.pos.x = newX
    end
end

return Player