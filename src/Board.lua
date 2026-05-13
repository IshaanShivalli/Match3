Board = Class{}

function Board:init(x, y)
    self.x = x
    self.y = y
    self.matches = {}

    self:initializeTiles()
end

function Board:initializeTiles()
    self.tiles = {}

    for tileY = 1, 8 do
        table.insert(self.tiles, {})

        for tileX = 1, 8 do
            table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(18), math.random(6)))
        end
    end

    while self:calculateMatches() do
        self:initializeTiles()
    end
end

function Board:calculateMatches()
    local matches = {}

    local matchNum = 1

    for y = 1, 8 do
        local colorToMatch = self.tiles[y][1].color

        matchNum = 1

        for x = 2, 8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                if matchNum >= 3 then
                    local match = {}
                    if matchNum == 4 then
                        for x2 = 1, 8 do table.insert(match, self.tiles[y][x2]) end
                    elseif matchNum == 5 then
                        for y2 = 1, 8 do
                            for x2 = 1, 8 do
                                if self.tiles[y2][x2].color == colorToMatch then
                                    table.insert(match, self.tiles[y2][x2])
                                end
                            end
                        end
                    elseif matchNum >= 6 then
                        local allTiles = {}
                        for y2 = 1, 8 do
                            for x2 = 1, 8 do table.insert(allTiles, self.tiles[y2][x2]) end
                        end
                        for i = 1, 32 do
                            table.insert(match, table.remove(allTiles, math.random(#allTiles)))
                        end
                    else
                        for x2 = x - 1, x - matchNum, -1 do
                            table.insert(match, self.tiles[y][x2])
                        end
                    end
                    table.insert(matches, match)
                end

                colorToMatch = self.tiles[y][x].color
                matchNum = 1
                if x >= 7 then
                    break
                end
            end
        end

        if matchNum >= 3 then
            local match = {}
            if matchNum == 4 then
                for x2 = 1, 8 do table.insert(match, self.tiles[y][x2]) end
            elseif matchNum == 5 then
                for y2 = 1, 8 do
                    for x2 = 1, 8 do
                        if self.tiles[y2][x2].color == colorToMatch then
                            table.insert(match, self.tiles[y2][x2])
                        end
                    end
                end
            elseif matchNum >= 6 then
                local allTiles = {}
                for y2 = 1, 8 do
                    for x2 = 1, 8 do table.insert(allTiles, self.tiles[y2][x2]) end
                end
                for i = 1, 32 do
                    table.insert(match, table.remove(allTiles, math.random(#allTiles)))
                end
            else
                for x = 8, 8 - matchNum + 1, -1 do
                    table.insert(match, self.tiles[y][x])
                end
            end
            table.insert(matches, match)
        end
    end

    for x = 1, 8 do
        local colorToMatch = self.tiles[1][x].color

        matchNum = 1

        for y = 2, 8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                if matchNum >= 3 then
                    local match = {}
                    if matchNum == 4 then
                        for y2 = 1, 8 do table.insert(match, self.tiles[y2][x]) end
                    elseif matchNum == 5 then
                        for y2 = 1, 8 do
                            for x2 = 1, 8 do
                                if self.tiles[y2][x2].color == colorToMatch then
                                    table.insert(match, self.tiles[y2][x2])
                                end
                            end
                        end
                    elseif matchNum >= 6 then
                        local allTiles = {}
                        for y2 = 1, 8 do
                            for x2 = 1, 8 do table.insert(allTiles, self.tiles[y2][x2]) end
                        end
                        for i = 1, 32 do
                            table.insert(match, table.remove(allTiles, math.random(#allTiles)))
                        end
                    else
                        for y2 = y - 1, y - matchNum, -1 do
                            table.insert(match, self.tiles[y2][x])
                        end
                    end
                    table.insert(matches, match)
                end

                colorToMatch = self.tiles[y][x].color
                matchNum = 1
                if y >= 7 then
                    break
                end
            end
        end

        if matchNum >= 3 then
            local match = {}
            if matchNum == 4 then
                for y2 = 1, 8 do table.insert(match, self.tiles[y2][x]) end
            elseif matchNum == 5 then
                for y2 = 1, 8 do
                    for x2 = 1, 8 do
                        if self.tiles[y2][x2].color == colorToMatch then
                            table.insert(match, self.tiles[y2][x2])
                        end
                    end
                end
            elseif matchNum >= 6 then
                local allTiles = {}
                for y2 = 1, 8 do
                    for x2 = 1, 8 do table.insert(allTiles, self.tiles[y2][x2]) end
                end
                for i = 1, 32 do
                    table.insert(match, table.remove(allTiles, math.random(#allTiles)))
                end
            else
                for y = 8, 8 - matchNum + 1, -1 do
                    table.insert(match, self.tiles[y][x])
                end
            end
            table.insert(matches, match)
        end
    end

    self.matches = matches

    return #self.matches > 0 and self.matches or false
end

function Board:removeMatches()
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end

    self.matches = nil
end

--[[
    Shifts down all of the tiles that now have spaces below them, then returns a table that
    contains tweening information for these new tiles.
]]
function Board:getFallingTiles()
    -- tween table, with tiles as keys and their x and y as the to values
    local tweens = {}

    -- for each column, go up tile by tile till we hit a space
    for x = 1, 8 do
        local space = false
        local spaceY = 0

        local y = 8
        while y >= 1 do
            
            -- if our last tile was a space...
            local tile = self.tiles[y][x]
            
            if space then
                
                -- if the current tile is *not* a space, bring this down to the lowest space
                if tile then
                    
                    -- put the tile in the correct spot in the board and fix its grid positions
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY

                    -- set its prior position to nil
                    self.tiles[y][x] = nil

                    -- tween the Y position to 32 x its grid position
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }

                    -- set Y to spaceY so we start back from here again
                    space = false
                    y = spaceY

                    -- set this back to 0 so we know we don't have an active space
                    spaceY = 0
                end
            elseif tile == nil then
                space = true
                
                -- if we haven't assigned a space yet, set this to it
                if spaceY == 0 then
                    spaceY = y
                end
            end

            y = y - 1
        end
    end

    for x = 1, 8 do
        for y = 8, 1, -1 do
            local tile = self.tiles[y][x]

            if not tile then
                local tile = Tile(x, y, math.random(18), math.random(6))
                tile.y = -32
                self.tiles[y][x] = tile

                tweens[tile] = {
                    y = (tile.gridY - 1) * 32
                }
            end
        end
    end

    return tweens
end

function Board:render()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end