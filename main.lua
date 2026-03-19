require "game"
require "ui"
require "data"

function love.load()
    initUI()
    spawnMonster("test1")
end
local a = 0
function love.update(dt)
    if a == 200 then
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
end

function love.draw()
    love.graphics.clear(255,255,255)
    love.graphics.setColor(255,255,255)
    drawGame()
    drawNewPath()
    drawUI()
end
