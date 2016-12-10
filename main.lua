require("Player")
require("Entity")

local entityList = {}

function love.load()
    table.insert(entityList, Entity:new({x = 200, y = 232}, 32, 32, true))
    table.insert(entityList, Entity:new({x = 168, y = 232}, 32, 32, true))
    table.insert(entityList, Entity:new({x = 232, y = 232}, 32, 32, true))
    player = Player:new({x = 200, y = 200}, 16, 16, 100, love.graphics.newImage("assets/player.png"))
    player.collidables = entityList
    love.window.setMode(640, 480, { vsync = false })
end

function love.draw()
    love.graphics.print("FPS: "..love.timer.getFPS(), 0, 0)
    love.graphics.print("Airborn: "..tostring(player.airborn), 0, 16)
    love.graphics.print("Player frame: "..player.animation.currentFrame, 0, 32)
    player:draw()
    for i, entity in ipairs(entityList) do
        entity:draw()
    end
    
end

function love.update(dt)
    player:update(dt)
    if love.keyboard.isDown("d") then
        player:moveRight(dt)
    end

    if love.keyboard.isDown("a") then
        player:moveLeft(dt)
    end
end