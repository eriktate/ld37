require("entity")

Button = {}

function Button:new(pos, action, deaction)
    local button = setmetatable({}, {__index = Entity:new(pos, 16, 16, true)})
    button.type = "button"
    button.action = action or function()end
    button.deaction = deaction or function()end
    button:setOrigin(button.width/2, button.height/2)
    button:setBbox(-button.originX, -button.originY)
    button:newAnimation(16, 16, 10, love.graphics.newImage("assets/misc.png"))
    button:addAnimation("pressed", {8})
    button:addAnimation("unpressed", {7})
    button:setAnimation("unpressed")
    
    function button:press()
        self:setAnimation("pressed")
        self.action()
    end

    function button:unpress()
        self:setAnimation("unpressed")
        self.deaction()
    end

    return button
end

return Button