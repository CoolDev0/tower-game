-- IDEA: Only load images of enemies when they're used in the current level

bgDir = "data/assets/backgrounds"
enDir = "data/assets/enemies"

s = 0.48

mapPath = {{0*s,345*s}, {685*s,345*s},{685*s,625*s},{1175*s,645*s},{1175*s,160*s},{1630*s,145*s}} -- Index 1: Entrance, Last index: Exit
-- Replace these tables with file loading
-- (Health, Speed, Image)
monsterStats = {
                {3,1.8,love.graphics.newImage(enDir .. "/test.png")},
                {3,1.5,love.graphics.newImage(enDir .. "/test2.png")}
             } 
monsters = {}


function drawGame(background)
    love.graphics.draw(background, 0, 0, 0, .85*s,.85*s)
    love.graphics.setColor(0,0,255)

    for i,v in pairs(mapPath) do
        if not(i == #mapPath)  then
            love.graphics.line(v[1],v[2],mapPath[i+1][1],mapPath[i+1][2])
        end
    end
    love.graphics.setColor(255,255,255)
end

function updateMonsters() 
    for i,v in pairs(monsters) do 
        if v[4] <  mapPath[v[6]][1] then -- Check if monster x is less than its destination
            v[4] = v[4] + v[2]
        end
        if v[4] > mapPath[v[6]][1] then
            v[4] = v[4] - v[2]
        end
        if v[5] <  mapPath[v[6]][2] then -- Check if monster y is less than its destination
            v[5] = v[5] + v[2]
        end
        if v[5] > mapPath[v[6]][2] then
           v[5] = v[5] - v[2]
        end      
        if (v[4] >= mapPath[v[6]][1] - v[2] and v[4] <= mapPath[v[6]][1] + v[2])  and (v[5] >= mapPath[v[6]][2] - v[2] and v[5] <= mapPath[v[6]][2] + v[2]) then
            if v[6] +1 < #mapPath +1 then
                 v[6] = v[6] +1 
            else
                table.remove(monsters,i)
                    spawnMonster(monsterStats[math.random(1,2)])
            end
        end
    end
end

function spawnMonster(monsterType)
    table.insert(monsters, {monsterType[1], monsterType[2], monsterType[3], mapPath[1][1], mapPath[1][2], 2}) -- Spawn at Entrance
                            -- 1Health       2Speed           3Image           4X              5Y           6Destination
end

function drawMonsters()
    for i,v in pairs(monsters) do
        -- ASSUMING THEY ARE 48x48 FIX THIS IF NOT CHANGED
        love.graphics.draw(v[3],v[4],v[5],0,1*s,1*s,24,24) --<<--
        love.graphics.print("Monsters: "..#monsters)
    end
end
