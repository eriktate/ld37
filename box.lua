require("entity")
require("animation")

Box = {}

function Box:new(pos, collidables, devices, locked)
    local box = setmetatable({}, {__index = Entity:new(pos, 16, 16, false)})
    box.locked = locked or false
    box.gravity = 200
    box.collidables = collidables
    box.devices = devices
    box.pushable = true
    box:setOrigin(box.width/2, box.height/2)
    box:setBbox(-box.originX, -box.originY, box.width, box.height)
    box:newAnimation(16, 16, 10, love.graphics.newImage("assets/misc.png"))
    box:addAnimation("idle", {13})
    box:addAnimation("locked", {14})
    box:setAnimation("idle")
    
    function box:update(dt)
        if box.locked then
            box:setAnimation("locked")
        else
            box:setAnimation("idle")
        end

        self:pressButton()
        Entity.update(self, dt)
    end

    function box:checkDevice()
        return self:checkCollision(self.pos, self.devices)
    end

    function box:pressButton()
        local device = self:checkDevice()
        
        if device and device.type == "plate" then
            device:press()
        end
    end
    return box
end

return Box