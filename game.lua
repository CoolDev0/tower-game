-- IDEA: Only load images of enemies when they're used in the current level

require "ui"
require "data"

test = love.graphics.newImage(bgDir .. "/test.png")
bgWidth, bgHeight = test:getPixelDimensions()

placingTower = false

-- Replace these tables with file loading
-- (Health, Speed, Image)
monsterStats = {
                {3,1.8,love.graphics.newImage(enDir .. "/test.png")},
                {3,1.5,love.graphics.newImage(enDir .. "/test2.png")}
             } 
monsters = {}

function startPlacing(placeable)
    
end

function drawGame(background)

    love.graphics.draw(background, 0, 0, 0, .85*scale,.85*scale)
    love.graphics.setColor(0,0,255)

    for i,v in pairs(mapPath) do
        if not(i == #mapPath)  then
            love.graphics.line(v[1],v[2],mapPath[i+1][1],mapPath[i+1][2])
        end
    end
    love.graphics.setColor(255,255,255)
end

function updateMonsters() 
    for i,mon in pairs(monsters) do
        dx = mapPath[mon[6]][1] - mon[4]
        dy = mapPath[mon[6]][2] - mon[5]
        angle = math.atan2(dy,dx)
        mon[4] = mon[4] + mon[2] * math.cos(angle)
        mon[5] = mon[5] + mon[2] * math.sin(angle)  
        -- Check if the enemy will be at the destination next frame
        if (mon[4] >= mapPath[mon[6]][1] - mon[2] and mon[4] <= mapPath[mon[6]][1] + mon[2])  and (mon[5] >= mapPath[mon[6]][2] - mon[2] and mon[5] <= mapPath[mon[6]][2] + mon[2]) then
            if mon[6] +1 < #mapPath +1 then
                 mon[6] = mon[6] +1 
            else
                table.remove(monsters,i)
                    spawnMonster(monsterStats[math.random(1,2)])
            end
        end
    end
end

function spawnMonster(monsterType)
    table.insert(monsters, {monsterType[1], monsterType[2], monsterType[3], mapPath[1][1], mapPath[1][2], 2}) -- Spawn at Entrance
                            -- 1Health       2Speed           3Image           4X              5Y         6Destination
end

function drawMonsters()
    for i,mon in pairs(monsters) do
        -- ASSUMING THEY ARE 48x48 FIX THIS IF NOT CHANGED
        love.graphics.draw(mon[3],mon[4],mon[5],0,1*scale,1*scale,24,24) --<<--
        love.graphics.print("Monsters: "..#monsters)
    end
end
