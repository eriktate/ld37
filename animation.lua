Animation = {}

function Animation:new(width, height, frameRate, image)
    local anim = {
        x = x,
        y = y,
        width = width,
        height = height,
        frameRate = frameRate,
        frames = {},
        spriteBatch = love.graphics.newSpriteBatch(image, 1),
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
            print("Quad: "..j*width..", "..i*height)
            local quad = love.graphics.newQuad(j * width, i * height, width, height, imgWidth, imgHeight)
            if self.spriteID == nil then
                print("DOING STUFF")
                self.spriteID = anim.spriteBatch:add(quad, 0, 0)
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

function Animation:set(name)
    self.currentAnimation = name
    self.currentFrame = 1
end

function Animation:update(dt)
    self.currentFrame = self.currentFrame + (self.frameRate * dt)
    local anim = self.animations[self.currentAnimation]
    if self.currentFrame > #anim + 1 then
        self.currentFrame = 1
    end
    local frameNumber = anim[math.floor(self.currentFrame)]
    local quad = self.frames[frameNumber]
    self.spriteBatch:set(self.spriteID, quad, self.x, self.y)
end

return Animation
