BeginGameState = Class{__includes = BaseState}

function BeginGameState:init()
    self.transitionAlpha = 1
    self.board = Board(VIRTUAL_WIDTH - 272, 16)
    self.leveLabelY = -64
end

function BeginGameState:enter(params)
    self.level = params.level
    self.score = params.score or 0
    Timer.tween(1, {
        [self] = {transitionAlpha = 0}
    })
    :finish(function()
        Timer.tween(0.25, {
            [self] = {leveLabelY = VIRTUAL_HEIGHT / 2 - 8}
        }):finish(function()
            Timer.after(1, function()
                Timer.tween(0.25, {
                    [self] = {leveLabelY = VIRTUAL_HEIGHT / 2 + 30}
                }):finish(function()
                    gameStateMachine:change('play', {
                        level = self.level,
                        board = self.board,
                        score = self.score                    
                    })
                end)
            end)
        end)
    end)
end


function BeginGameState:exit()
end


function BeginGameState:update(dt)
    Timer.update(dt)
end

function BeginGameState:render()
    self.board:render()
end