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
        love.graphics.circle("line",tow[1] + tow[3]:getWidth() / 2,tow[2] + tow[3]:getHeight() / 2, tow[4])
    end
    for i, proj in pairs(projectiles) do
        love.graphics.rectangle("fill", proj[1],proj[2])
    end

end

function updateMonsters() 
    for i,mon in pairs(monsters) do
        angle = getAngle(mon[4],mon[5],mapPath[mon[6]][1],mapPath[mon[6]][2])
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
    for i, mon in pairs(monsters) do
        for i, tow in pairs(towers) do
            -- check if distance of monster from center of circle is less than radius
            local distance = math.sqrt((math.abs(tow[1] - mon[4]))^2+(math.abs(tow[2] - mon[5]))^2)
            if distance <= tow[4] then fireTower(tow) end
        end
    end
end

function fireTower(tow) 
    local t = timers[tow[6]]

    if t ~= nil then
        if t[3] then
            timers[tow[6]] = nil
            tow[7] = true
        end
    else
        createTimer(tow[6],tow[5])
    end

    if tow[7] then
        print("FIRE")
        tow[7] = false
    end
end

function createTimer(name, max)
    timers[name] = {0,max,false}
    for i,v in pairs (timers) do
        for i2,v2 in pairs(v) do
            print(v2)
        end
    end
end

function createProjectile(type,x,y)
    table.insert(projectiles, {x,y})
end


function createTower(towerType,x,y)
    local s = towerData[tostring(towerType)]
    table.insert(towers,{x,y, towerImages[s["image"]], s["range"], s["cooldown"],tostring(towerType..math.random(0,100000000)), true})
end

function spawnMonster(monsterType)
    local s = monsterData[tostring(monsterType)]
    table.insert(monsters, {s["health"], s["speed"], monsterImages[s["image"]], mapPath[1][1], mapPath[1][2], 2}) -- Spawn at Entrance
                            -- 1Health       2Speed           3Image           4X              5Y         6Destination
end
