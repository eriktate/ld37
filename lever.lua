require("Entity")
require("Animation")

Lever = {}

function Lever:new(pos)
    local lever = Entity:new(pos, 16, 16, false)
    lever.active = false
    lever.animation = Animation:new(16, 16, 10, love.graphics.newImage("assets/misc.png"))
    lever:addAnimation("idle", {3})
    lever:addAnimation("activate", {3, 2, 1})
    lever:addAnimation("deactivate", {1, 2, 3})
    lever:addAnimation("winIdle", {5})
    lever:addAnimation("winActivate", {6, 5, 4})
    lever:addAnimation("winDeactivate", {4, 5, 6})
    lever:setAnimation("idle")
    return setmetatable(self, {__index = lever})
end

function Lever:activate(callback)
    lever:setAnimation("activate")
    callback()
end

function Lever:deactivate(callback)
    lever:setAnimation("")
    callback()
end

return Lever