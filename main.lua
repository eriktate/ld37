require("player")
require("entity")
require("camera")
require("level")
require("lever")
require("vector2")
require("box")
require("button")
require("plate")
require("darkness")

local entityList = {}
local wallList = {}
local deviceList = {}
local pushList = {}

rotateLeft = function()
    newOrientation = (newOrientation - 90) % 360
end

rotateRight = function()
    newOrientation = (newOrientation + 90) % 360
end

rotateAround = function()
    newOrientation = (newOrientation + 180) % 360
end

local background = nil
local rotMode = {
    floor = 0,
    ceiling = 180,
    right = 270,
    left = 90
}

WatchList = {
    things = {}
}

orientation = 90
newOrientation = 90

function WatchList:watch(key, value)
    self.things[key] = value
end

function love.load()
    -- Setup window
    love.graphics.setDefaultFilter( 'nearest', 'nearest' )
    love.graphics.setBackgroundColor(100, 149, 237)
    love.window.setMode(640, 480, { vsync = true })

    bgMusicSource = love.audio.newSource("assets/sfx/music/song1.wav")
    bgMusicSource:setLooping(true)
    love.audio.play(bgMusicSource)

    background = getBackground()
    -- Setup entities.
    camera = Camera:new(200, 200, 0.5, 0.5, util.degtorad(orientation - 90))
    
    tiles = Level.getTiles()

    local walls = Level.getWalls()
    local lockedBox = Box:new(Vector2:new(912, 1080), walls, deviceList, true)
    local boxes = {
        Box:new(Vector2:new(1089, 1095), walls, deviceList),
        lockedBox
    }

    plains2desert = Lever:new(Vector2:new(1190, 1047), rotateLeft, rotateLeft, true)
    plains2tundra = Lever:new(Vector2:new(348, 1127), rotateRight, rotateRight)

    tundra2plains = Lever:new(Vector2:new(313, 1080), rotateLeft, rotateLeft)
    tundra2dark = Lever:new(Vector2:new(313, 368), rotateRight, rotateRight)

    desert2plains = Lever:new(Vector2:new(1127, 1080), rotateRight, rotateRight)
    desert2dark = Lever:new(Vector2:new(1127, 368), rotateLeft, rotateLeft)

    dark2tundra = Lever:new(Vector2:new(1080, 313), rotateRight, rotateRight)
    dark2desert = Lever:new(Vector2:new(348, 313), rotateLeft, rotateLeft)

    tundra2plains.animation.initialRot = rotMode.left
    tundra2dark.animation.initialRot = rotMode.left

    desert2plains.animation.initialRot = rotMode.right
    desert2dark.animation.initialRot = rotMode.right

    dark2tundra.animation.initialRot = rotMode.ceiling
    dark2desert.animation.initialRot = rotMode.ceiling

    firstButton = Button:new(Vector2:new(662, 1096), function()
        lockedBox.locked = false
    end)

    firstPlate = Plate:new(Vector2:new(832, 1096), function()
        plains2desert:unlock()
    end, function()
        plains2desert:lock()
    end)

    table.insert(deviceList, plains2desert)
    table.insert(deviceList, plains2tundra)
    table.insert(deviceList, tundra2plains)
    table.insert(deviceList, tundra2dark)
    table.insert(deviceList, desert2plains)
    table.insert(deviceList, desert2dark)
    table.insert(deviceList, dark2tundra)
    table.insert(deviceList, dark2desert)
    table.insert(deviceList, firstButton)
    table.insert(deviceList, firstPlate)

    wallList = util.concat(boxes, walls)
    entityList = util.concat(deviceList, wallList)
    player = Player:new(Vector2:new(844, 986), 16, 16, 100, love.graphics.newImage("assets/player.png"))
    player.devices = deviceList
    player.collidables = wallList

end

function love.draw()
    local counter = 0
    camera:set()
    love.graphics.draw(background, 545, 305)
    drawLists()
    drawDarkness()
    camera:unset()
    -- for k, v in pairs(WatchList.things) do
    --     love.graphics.print(k..": "..v, 0, counter * 16)
    --     counter = counter + 1
    -- end
end

function love.update(dt)
    WatchList:watch("Airborn", tostring(player.airborn))
    WatchList:watch("Animation", player.animation.currentAnimation)
    WatchList:watch("FPS", love.timer.getFPS())
    WatchList:watch("SPEED", player.speed)
    WatchList:watch("Y", player.pos.y)
    WatchList:watch("X", player.pos.x)
    WatchList:watch("Orientation", orientation)
    WatchList:watch("Flip", player.animation.flip)
    WatchList:watch("BBOX: ", player.bbox.x..", "..player.bbox.y..", "..player.bbox.width..", "..player.bbox.height)
    WatchList:watch("New Orientation", newOrientation)
    manageOrientation(dt)

    updateLists(dt)
    player:update(dt)
    camera:update(dt, player)
    testRotation()
end

function drawLists()
    for i = 1, #tiles, 1 do
        tiles[i]:draw()
    end

    player:draw()

    for i = 1, #entityList, 1 do
        entityList[i]:draw()
    end
end

function updateLists(dt)
    for i = 1, #entityList, 1 do
        entityList[i]:update(dt)
    end
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

function manageOrientation(dt)
    local direction = util.sign(newOrientation - orientation)

    if orientation ~= newOrientation then
        camera:setShake(true)
        local camRot = camera.rotation % (2 * math.pi)
        local target = util.degtorad(newOrientation - 90) % (2 * math.pi)
        local direction = -math.sin(camRot - target)
        camera.rotation = camera.rotation + util.degtorad(30 * util.sign(direction) * dt)

        if math.abs(camRot - target) <= util.degtorad(2) then
            camera.rotation = util.degtorad(newOrientation - 90)
            orientation = newOrientation
            camera:setShake(false)
            unlockEverything()
        end

        WatchList:watch("CamRot", camRot)
        WatchList:watch("BoundRot1", bound1)
        WatchList:watch("BoundRot2", bound2)
    end
end

function unlockEverything()
    player.lock = false
    player.animation:play(true)
end

function getBackground()
    -- local spritebatch = love.graphics.newSpriteBatch(love.graphics.newImage("assets/background.png"), 250)
    -- local quad = love.graphics.newQuad(0, 0, 64, 64, 64, 64, 64)
    -- for i = 4, 1088/64, 1 do
    --     for j = 4, 1088/64, 1 do
    --         spritebatch:add(quad, j * 64, i * 64, 0, 1, 1)
    --     end
    -- end

    -- return spritebatch

    return love.graphics.newImage("assets/quadBackground.png")
end