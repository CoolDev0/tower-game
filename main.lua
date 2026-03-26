require "game"
require "ui"
require "data"

function love.load()
    a = 0
    love.window.setTitle("Tower Game - Title Screen")
    gameState = 0
end
function love.update(dt)
    if gameState == 0 then
        gameState = 1
    end
    if gameState == 1 then
        if not gameRunning then initGame() end
            if a == 100 then
                a = 0
                spawnMonster("test"..math.random(1,2))
            end
        for i,v in pairs(timers) do
            if not v[3] then
                if v[1] > v[2] then 
                    v[3] = true
                    v = nil
                else
                    v[1] = v[1] + dt
                end
            end
        end
        updateMonsters()
        updateProjectiles()
        a = a + 1
        if health <= 0 then
            gameState = 0
            gameInitialized = false
            initGame()
        end
    end 
    
end

function love.draw()
    if gameState == 1 then
        love.graphics.clear(255,255,255)
        love.graphics.setColor(255,255,255)
        drawGame()
        drawNewPath()
        drawUI()
    end
end
