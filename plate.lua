require("entity")
require("animation")

Plate = {}

function Plate:new(pos, action, deaction)
    local plate = setmetatable({}, {__index = Entity:new(pos, 16, 16, true)})
    plate.type = "plate"
    plate.action = action or function()end
    plate.deaction = deaction or function()end
    plate:setOrigin(plate.width/2, plate.height/2)
    plate:setBbox(-plate.originX, -plate.originY)
    plate:newAnimation(16, 16, 10, love.graphics.newImage("assets/misc.png"))
    plate:addAnimation("pressed", {11})
    plate:addAnimation("unpressed", {10})
    plate:setAnimation("unpressed")
    
    function plate:press()
        self:setAnimation("pressed")
        self.action()
    end

    function plate:unpress()
        self:setAnimation("unpressed")
        self.deaction()
    end

    return plate
end

return Plate
