require("Player")
require("Entity")
require("Camera")
require("Level")
require("Lever")
require("Vector2")

local entityList = {}
local wallList = {}
local deviceList = {}

WatchList = {
    things = {}
}

orientation = 90

function WatchList:watch(key, value)
    self.things[key] = value
end

function love.load()
    -- Setup window
    love.graphics.setDefaultFilter( 'nearest', 'nearest' )
    love.graphics.setBackgroundColor(100, 149, 237)
    love.window.setMode(640, 640, { vsync = false })

    bgMusicSource = love.audio.newSource("assets/song0.wav")
    love.audio.play(bgMusicSource)

    -- Setup entities.
    camera = Camera:new(0, 0, 0.5, 0.5, 0)
    wallList = Level.getWalls()
    tiles = Level.getTiles()
    lever = Lever:new(Vector2:new(232, 376), love.graphics.newImage("assets/misc.png"))
    player = Player:new(Vector2:new(200, 300), 16, 16, 100, love.graphics.newImage("assets/player.png"))
    table.insert(deviceList, lever)
    player.collidables = wallList
end

function love.draw()
    local counter = 0
    camera:set()
    lever:draw()
    player:draw()
    for i, entity in pairs(entityList) do
        entity:draw()
    end
    for i, wall in pairs(wallList) do
        wall:draw()
    end
    for i, tile in pairs(tiles) do
        tile:draw()
    end
   camera:unset()
    for k, v in pairs(WatchList.things) do
        love.graphics.print(k..": "..v, 0, counter * 16)
        counter = counter + 1
    end
end

function love.update(dt)
    WatchList:watch("Airborn", tostring(player.airborn))
    WatchList:watch("Animation", player.animation.currentAnimation)
    WatchList:watch("Player Frame", player.animation.currentFrame)
    WatchList:watch("FPS", love.timer.getFPS())
    WatchList:watch("SPEED", player.speed)
    WatchList:watch("Distance", player.speed * dt)
    WatchList:watch("Y", player.pos.y)
    WatchList:watch("X", player.pos.x)
    WatchList:watch("Orientation", orientation)
    WatchList:watch("Flip", player.animation.flip)
    WatchList:watch("BBOX: ", player.bbox.x..", "..player.bbox.y..", "..player.bbox.width..", "..player.bbox.height)
    WatchList:watch("Lever Anim", lever.animation.currentAnimation)
    WatchList:watch("Lever Frame", lever.animation.currentFrame)
    WatchList:watch("Lever SpriteID", lever.animation.spriteID)
    WatchList:watch("Player SpriteID", player.animation.spriteID)
    for i, entity in pairs(entityList) do
        entity:update(dt)
    end
    lever:update(dt)
    player:update(dt)
    camera:update(dt, player)
    testRotation()
end

function testRotation()
    if love.keyboard.isDown("right") then
        orientation = 0
    end

    if love.keyboard.isDown("up") then
        orientation = 270
    end

    if love.keyboard.isDown("left") then
        orientation = 180
    end

    if love.keyboard.isDown("down") then
        orientation = 90
    end
end