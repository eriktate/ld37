require("entity")
require("animation")
Player = {}

function Player:new(pos, width, height, speed, image)
    local player = Entity:new(pos, width, height, false)
    player:setOrigin(width/2, height/2)
    player.moveSpeed = speed
    player.image = image
    player.gravity = 200
    player.jumpHeight = 120
    player.flip = -1
    player.jumping = false
    player.devices = {}

    player.stepSnd = love.audio.newSource("assets/sfx/character/ground.wav")
    player.jumpSnd = love.audio.newSource("assets/sfx/character/jump.wav")
    player.lastFrame = 0

    player:setBbox(-player.originX + 2, -player.originY, width - 3, height - 2)
    player:newAnimation(width, height, 10, image)
    player:addAnimation("idle", {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2})
    player:addAnimation("run", {5, 6, 7, 8})
    player:addAnimation("jump", {9})
    player:addAnimation("fall", {10})
    player:addAnimation("lookup", {13})
    player:addAnimation("lookdown", {14})
    player:addAnimation("push", {17, 18})
    player:addAnimation("pulled", {19})
    player:addAnimation("pull", {17, 17, 17, 17, 17, 18, 18, 18, 18, 18, 19, 19, 19, 19, 19})
    player:addAnimation("death", {21, 22, 21, 22, 21, 23, 23, 23, 23})
    player:setAnimation("idle")
    return setmetatable(self, { __index = player})
end

function Player:update(dt)
    if not self.lock then
        if love.keyboard.isDown("w") and not self.jumping then
            if not self.airborn then
                self.speed = -self.jumpHeight
                self.jumping = true
                love.audio.play(self.jumpSnd)
            end
        end

        if not love.keyboard.isDown("w") then
            self.jumping = false
        end
        
        if love.keyboard.isDown("d") then
            self:moveRight(dt)
            self.animation.flip = 1
            self:setAnimation(self:airbornState() or "run")
        elseif love.keyboard.isDown("a") then
            self:moveLeft(dt)
            self.animation.flip = -1
            self:setAnimation(self:airbornState() or "run")
        else
            self:setAnimation(self:airbornState() or "idle")
        end
        
        if love.keyboard.isDown("space") then
            self:pull()
        end
    end

    self:pressButton()
    self:playStep()

    Entity.update(self, dt)
end

function Player:airbornState()
    if self.airborn then
        if self.speed <= 0 then
            return "jump"
        end
        return "fall"
    end
    return nil
end

function Player:moveRight(dt)
    local mag = self.moveSpeed * dt
    local moveVec = self.pos + self:moveVector():scale(mag)
    collided = self:checkCollision(moveVec, self.collidables)
    if collided then
        if collided.pushable and not collided.locked then
            if collided:checkCollision(collided.pos + collided:moveVector():scale(mag), collided.collidables) then
                return
            end
            collided.pos = collided.pos + collided:moveVector():scale(mag)
        else
            return
        end
    end

    self.pos = moveVec
end

function Player:moveLeft(dt)
    local mag = self.moveSpeed * dt
    local moveVec = self.pos - self:moveVector():scale(mag)
    collided = self:checkCollision(moveVec, self.collidables)
    if collided then
        if collided.pushable and not collided.locked then
            if collided:checkCollision(collided.pos - collided:moveVector():scale(mag), collided.collidables) then
                return
            end
            collided.pos = collided.pos - collided:moveVector():scale(mag)
        else
            return
        end
    end
    
    self.pos = moveVec
end

function Player:pull()
    device = self:checkDevice()
    if device and not device.locked then
        self.lock = true
        side = self:checkSide(device)
        self:setAnimation("pull")
        self:setAnimationCallback(function()
            self:setAnimation("pulled")
            self.animation:stop()
        end)
        self.pos = device.pos
        if device.active then
            self.flip = -1
            device:deactivate()
        else
            self.flip = 1
            device:activate()
        end
    end 
end

function Player:checkDevice()
    return self:checkCollision(self.pos, self.devices)
end

function Player:pressButton()
    local device = self:checkDevice()
    
    if device and device.type == "button" then
        device:press()
    end
end

function Player:playStep()
    local frame = self.animation:animationFrame()
    if frame ~= self.lastFrame and (frame == 6 or frame == 8) then
        love.audio.play(self.stepSnd)
    end
    self.lastFrame = frame
end

return Player