require("util")

Animation = {}

function Animation:new(width, height, frameRate, image)
    local anim = {
        x = 0,
        y = 0,
        originX = 0,
        originY = 0,
        width = width,
        height = height,
        flip = 1,
        frameRate = frameRate,
        frames = {},
        spriteBatch = love.graphics.newSpriteBatch(image),
        spriteID = nil,
        currentFrame = 1,
        currentAnimation = "",
        animations = {}
    }
    local imgWidth, imgHeight = image:getDimensions()
    local columns = imgWidth/width
    local rows = imgHeight/height
    local counter = 1

    for i=0, rows - 1, 1 do
        for j=0, columns - 1, 1 do
            local quad = love.graphics.newQuad(j * width, i * height, width, height, imgWidth, imgHeight)
            if anim.spriteID == nil then
                anim.spriteID = anim.spriteBatch:add(quad, 0, 0, util.degtorad(orientation), 1, 1)
                print(anim.spriteID)
            end
            anim.frames[counter] = quad
            counter = counter + 1
        end
    end
    self.__index = self
    return setmetatable(anim, self)
end

function Animation:add(name, frames)
    self.animations[name] = frames
end

function Animation:setOrigin(x, y)
    self.originX = x or self.originX
    self.originY = y or self.originY 
end

function Animation:set(name)
    if name ~= self.currentAnimation then
        self.currentAnimation = name
        self.currentFrame = 1
    end
end

-- An Animation's update function needs the delta time and its normal vector.
function Animation:update(dt)
    self.currentFrame = self.currentFrame + (self.frameRate * dt)
    local anim = self.animations[self.currentAnimation]
    if self.currentFrame > #anim + 1 then
        self.currentFrame = 1
    end
    local frameNumber = anim[math.floor(self.currentFrame)]
    local quad = self.frames[frameNumber]
    self.spriteBatch:set(self.spriteID, quad, self.x, self.y, util.degtorad(orientation + 270), self.flip, 1, self.width/2, self.height/2)    
end

return Animation
