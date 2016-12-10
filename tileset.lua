Tileset = {}

function Tileset:new(image, tileLayer)
    local tileset = {
        tiles = {}
    }
    tileset.spritebatch = love.graphics.newSpriteBatch(image, 5000)
    
    local tileData = tileLayer.data
    for i = 1, #tileData, 1 do
        local tile = tileData[i]
        if tile ~= 0 then
            local x = ((i - 1) % tileLayer.width) * 16
            local y = math.floor((i - 1) / tileLayer.width) * 16
            local qcoords = getTileCoords(tile, image)
            local quad = love.graphics.newQuad(qcoords.x, qcoords.y, 16, 16, image:getWidth(), image:getHeight())
            table.insert(tileset.tiles, tileset.spritebatch:add(quad, x, y))
        end
    end

    self.__index = self
    return setmetatable(tileset, Tileset)
end

function Tileset:draw()
    love.graphics.draw(self.spritebatch, 0, 0)
end

function getTileCoords(index, image)
    local width = image:getWidth()/16
    local height = image:getHeight()/16
    local x = ((index - 1) % width) * 16
    local y = math.floor((index - 1) / width) * 16
    return {x = x, y = y}
end

return Tileset