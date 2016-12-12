require("entity")
require("animation")

Lever = {}

function Lever:new(pos, action, deaction, locked)
    local lever =  setmetatable({}, {__index = Entity:new(pos, 16, 16, true)})
    lever.type = "lever"
    lever.locked = locked
    lever.active = false
    lever.action = action or function()end
    lever.deaction = deaction or function()end
    lever:setOrigin(lever.width/2, lever.height/2)
    lever:setBbox(-lever.originX, -lever.originY)
    lever:newAnimation(16, 16, 10, love.graphics.newImage("assets/misc.png"))
    lever:addAnimation("activated", {1})
    lever:addAnimation("deactivated", {3})
    lever:addAnimation("activate", {3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1})
    lever:addAnimation("deactivate", {1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3})
    lever:addAnimation("winIdle", {5})
    lever:addAnimation("winActivate", {6, 5, 4})
    lever:addAnimation("winDeactivate", {4, 5, 6})
    lever:addAnimation("locked", {9})
    if lever.locked then
        lever:setAnimation("locked")
    else
        lever:setAnimation("deactivated")
    end
    
    function lever:activate()
        self:setAnimation("activate")
        self.animation:play(true)
        self:setAnimationCallback(function()
            self:setAnimation("activated")
            self.animation:stop()
            self.active = true
            self.action()
        end)
    end

    function lever:unlock()
        if self.locked then
            self.locked = false
            self:setAnimation("deactivated")
        end
    end

    function lever:lock()
        if not self.locked then
            self.locked = true
            self:setAnimation("locked")
        end
    end
    
    function lever:setAnimation(anim)
        print("hit")
        if self.locked then
            Entity.setAnimation(self, "locked")
        else
            Entity.setAnimation(self, anim)
        end
    end

    function lever:deactivate(callback)
        self:setAnimation("deactivate")
        self.animation:play(true)
        self:setAnimationCallback(function()
            self:setAnimation("deactivated")
            self.animation:stop()
            self.active = false
            self.deaction()
        end)
    end

    return lever
end



return Lever