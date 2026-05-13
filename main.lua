require 'src.Dependencies'


WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288
BACKGROUND_SCROLL_SPEED = 80


function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    love.window.setTitle('Match 3')

    math.randomseed(os.time())



    backgroundX = 0

    love.keyboard.keysPressed = {}

    math.randomseed(os.time())
    gameTextures = {
        ['tiles'] = love.graphics.newImage('graphics/match3.png'),
        ['background'] = love.graphics.newImage('graphics/background.png')
    }

    gameSounds = {
        ['music'] = love.audio.newSource('sounds/music3.mp3', 'static'),
        ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
        ['error'] = love.audio.newSource('sounds/error.wav', 'static'),
        ['match'] = love.audio.newSource('sounds/match.wav', 'static'),
        ['clock'] = love.audio.newSource('sounds/clock.wav', 'static'),
        ['game-over'] = love.audio.newSource('sounds/game-over.wav', 'static'),
        ['next-level'] = love.audio.newSource('sounds/next-level.wav', 'static')
    }

    gameFrames = {
        ['tileFrame'] = GenerateTileQuads(gameTextures['tiles'])
    }

    gameFonts = {
        ['large'] = love.graphics.newFont('font/font.ttf', 32),
        ['medium'] = love.graphics.newFont('font/font.ttf', 16)
    }

    gameStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['begin-game'] = function() return BeginGameState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end
    }
    gameStateMachine:change('start')

    gameSounds['music']:setLooping(true)
    gameSounds['music']:play()
    
    push:setupScreen(
        VIRTUAL_WIDTH,
        VIRTUAL_HEIGHT,
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        {
            fullscreen = false,
            resizable = true,
            vsync = true,
            upscale = 'normal'
        }
    )
end

function love.update(dt)
    Timer.update(dt)
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end


function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end


function love.update(dt)
    
    backgroundX = backgroundX - BACKGROUND_SCROLL_SPEED * dt
    
    if backgroundX <= -1024 + VIRTUAL_WIDTH - 4 + 51 then
        backgroundX = 0
    end

    gameStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end


function love.draw()
    push:start()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gameTextures['background'], backgroundX, 0)
    
    gameStateMachine:render()
    push:finish()
end

function generateBoard()
    local tiles = {}

    for y = 1, 8 do
        table.insert(tiles, {})

        for x = 1, 8 do
            table.insert(tiles[y], {
                x = (x - 1) * 32,
                y = (y - 1) * 32,

                gridX = x,
                gridY = y,

                tile = math.random(#tileQuads)
            })
        end
    end

    return tiles
end

function drawBoard(offsetX, offsetY)
    for y = 1, 8 do
        for x = 1, 8 do

            local tile = board[y][x]

            love.graphics.draw(
                tileSprite,
                tileQuads[tile.tile],
                tile.x + offsetX,
                tile.y + offsetY
            )

            if highlightedTile then
                if tile.gridX == highlightedX and tile.gridY == highlightedY then

                    love.graphics.setColor(1, 1, 1, 128 / 255)

                    love.graphics.rectangle(
                        'fill',
                        tile.x + offsetX,
                        tile.y + offsetY,
                        32,
                        32,
                        4
                    )

                    love.graphics.setColor(1, 1, 1, 1)
                end
            end
        end
    end

    love.graphics.setColor(1, 0, 0, 234 / 255)
    love.graphics.setLineWidth(4)

    love.graphics.rectangle(
        'line',
        selectedTile.x + offsetX,
        selectedTile.y + offsetY,
        32,
        32,
        4
    )

    love.graphics.setColor(1, 1, 1, 1)
end