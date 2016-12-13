require("entity")
require("tileset")

Level = require("levels/TiltedGrass")

function Level.getWalls()
    local walls = {}
    local counter = 1
    for i = 1, #Level.layers, 1 do
        local layer = Level.layers[i]
        if layer.type == "objectgroup" then
            for j = 1, #layer.objects, 1 do
                local object = layer.objects[j]
                walls[counter] = Entity:new(Vector2:new(object.x, object.y), object.width, object.height, true)
                counter = counter + 1
            end
        end
    end
    return walls
end

function Level.getTiles()
    local tilesets = {}
    local counter = 1
    for i = 1, #Level.layers, 1 do
        local layer = Level.layers[i]
        if layer.type == "tilelayer" then
            local image = nil
            local firstGid = 1
            if layer.name == "Grass" then
                image = love.graphics.newImage("assets/grassTiles.png")
            end
            if layer.name == "Desert" then
                image = love.graphics.newImage("assets/desert.png")
                firstGid = 26
            end
            if layer.name == "Tundra" then
                image = love.graphics.newImage("assets/tundra.png")
                firstGid = 51
            end
            if layer.name == "Dark" then
                image = love.graphics.newImage("assets/grassdark.png")
                firstGid = 76
            end
            tilesets[counter] = Tileset:new(image, layer, firstGid)
            counter = counter + 1
        end
    end
    return tilesets
end

return Level