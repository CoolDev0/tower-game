require "game"
require "ui"
require "data"

function love.load()
    love.window.setTitle("Tower Game")
    createButton(bgWidth * scale * 0.87, 30, 150, 150, 30)
    createButton(bgWidth * scale * 0.87+ 100, 30, 150, 150, 30)
    createButton(bgWidth * scale * 0.87+ 200, 30, 150, 150, 30)
    spawnMonster(monsterStats[1])
end

function love.update()
    updateMonsters()
end

function love.draw()
    love.graphics.clear(255,255,255)
    love.graphics.setColor(255,255,255)
    drawGame(test)
    drawNewPath()
    drawMonsters()
    drawButtons()
end
