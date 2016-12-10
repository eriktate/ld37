require("Entity")
require("Animation")
Player = {}

function Player:new(pos, width, height, speed, image)
    local player = Entity:new(pos, width, height, false)
    player.speed = speed
    player.image = image
    player.animation = Animation:new(width, height, 10, image)
    player.animation:add("idle", {1, 2})
    player.animation:add("run", {5, 6, 7, 8})
    player.animation:add("jump", {9})
    player.animation:add("fall", {10})
    player.animation:add("lookup", {13})
    player.animation:add("lookdown", {14})
    player.animation:add("push", {17, 18})
    player.animation:add("pull", {17, 19})
    player.animation:add("death", {21, 22, 21, 22, 21, 23, 23, 23, 23})
    player.animation:set("death")
    return setmetatable(self, { __index = player})
end

function Player:update(dt)
    self.animation:update(dt)
end

function Player:moveRight(dt)
    self.pos.x = self.pos.x + (self.speed * dt)
end

function Player:moveLeft(dt)
    self.pos.x = self.pos.x - (self.speed *dt)
end

return Player