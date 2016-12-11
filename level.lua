require("Entity")
require("Tileset")

Level = require("levels/objectTest")

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
            if layer.name == "Grass" then
                image = love.graphics.newImage("assets/grassTiles.png")
            end
            tilesets[counter] = Tileset:new(image, layer)
        end
    end
    return tilesets
end

return Level