require("Player")
require("Entity")
require("Camera")
require("Level")

local entityList = {}

WatchList = {
    things = {}
}

function WatchList:watch(key, value)
    self.things[key] = value
end

function love.load()
    love.graphics.setBackgroundColor(100, 149, 237)
    camera = Camera:new(0, 0, 1, 1, 0)
    entityList = Level.getWalls()
    tiles = Level.getTiles()
    player = Player:new({x = 200, y = 100}, 16, 16, 100, love.graphics.newImage("assets/player.png"))
    player.collidables = entityList
    love.window.setMode(640, 480, { vsync = false })
end

function love.draw()
    local counter = 0
    --camera:set()
    for k, v in pairs(WatchList.things) do
        love.graphics.print(k..": "..v, 0, counter * 16)
        counter = counter + 1
    end
    player:draw()
    for i, entity in ipairs(entityList) do
        entity:draw()
    end
    for i, tile in ipairs(tiles) do
        tile:draw()
    end
    --camera:unset()
end

function love.update(dt)
    WatchList:watch("Airborn", tostring(player.airborn))
    WatchList:watch("Animation", player.animation.currentAnimation)
    WatchList:watch("Player Frame", player.animation.currentFrame)
    WatchList:watch("FPS", love.timer.getFPS())
    WatchList:watch("VSPEED", player.vspeed)
    WatchList:watch("VDistance", player.vspeed * dt)
    WatchList:watch("Y", player.pos.y)
    WatchList:watch("X", player.pos.x)
    player:update(dt)
    --camera:setPosition(player.pos.x - 120, player.pos.y - 120)
end