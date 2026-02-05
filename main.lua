require "game"
require "ui"
require "data"

function love.load()
    love.window.setTitle("Tower Game")
    createButton(bgWidth * scale * 0.87, 30, 150, 150, 30,"Rouge","tower","test2")
    createButton(bgWidth * scale * 0.87, 30+100, 150, 150, 30,"Bleu","tower","test1")
    createButton(bgWidth * scale * 0.87, 30+200, 150, 150, 30,"Vert","tower","test3")
    spawnMonster("test1")
end

function love.update(dt)
    updateMonsters()
end

function love.draw()
    love.graphics.clear(255,255,255)
    love.graphics.setColor(255,255,255)
    drawGame()
    drawNewPath()
    drawUI()
end
