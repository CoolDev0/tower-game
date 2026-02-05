require "ui"
require "data"

function drawGame()

    love.graphics.draw(levelBackground, 0, 0, 0, .85*scale,.85*scale)
    love.graphics.setColor(0,0,255)

    for i,v in pairs(mapPath) do
        if not(i == #mapPath)  then
            love.graphics.line(v[1],v[2],mapPath[i+1][1],mapPath[i+1][2])
        end
    end
    love.graphics.setColor(255,255,255)

    for i,mon in pairs(monsters) do
    -- ASSUMING THEY ARE 48x48 FIX THIS IF NOT CHANGED
        love.graphics.draw(mon[3],mon[4],mon[5],0,1*scale,1*scale,24,24) --<<--
    end
    for i, tow in pairs(towers) do
        love.graphics.draw(tow[3],tow[1],tow[2])
    end

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
            if mon[6] < #mapPath then
                 mon[6] = mon[6] +1 
            else
                table.remove(monsters,i)
                    spawnMonster("test"..math.random(1,2))
            end
        end
    end
end

function createTower(towerType,x,y)
    local s = towerData[tostring(towerType)]
    table.insert(towers,{x,y, towerImages[s["image"]]})
end

function spawnMonster(monsterType)
    local s = monsterData[tostring(monsterType)]
    table.insert(monsters, {s["health"], s["speed"], monsterImages[s["image"]], mapPath[1][1], mapPath[1][2], 2}) -- Spawn at Entrance
                            -- 1Health       2Speed           3Image           4X              5Y         6Destination
end
