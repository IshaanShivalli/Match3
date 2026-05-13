Tile = Class{}

function Tile:init(x, y, color, variety)
    self.gridX = x
    self.gridY = y
    self.color = color
    self.variety = variety
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32
end


function Tile:render(x, y)
    love.graphics.setColor(34/255, 32/255, 52/255, 255/255)
    love.graphics.draw(gameTextures['tiles'], gameFrames['tileFrame'][self.color][self.variety], self.x + x + 2, self.y + y + 2)
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
    love.graphics.draw(gameTextures['tiles'], gameFrames['tileFrame'][self.color][self.variety], self.x + x, self.y + y)
end

