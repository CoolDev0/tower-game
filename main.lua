require "game"

function love.load()
    test = love.graphics.newImage(bgDir .. "/test.png")
    spawnMonster(monsterStats[1])
end

function love.update()
    updateMonsters()
end

function love.draw()
    drawGame(test)
    drawMonsters()
end
