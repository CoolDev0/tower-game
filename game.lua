require "ui"
require "data"

-- Towers should have a base, and over it, the shooting thingy that rotates

-- add a way to make some zones unplacable for towers

function drawGame()
    love.graphics.draw(levelBackground, 0, 0, 0, bgXS, bgYS)
    love.graphics.setColor(0,0,255)
    love.graphics.setColor(255,255,255)
    for i, proj in pairs(projectiles) do
        love.graphics.draw(proj[3],proj[1],proj[2],proj[4],27 / proj[3]:getWidth(), 27 / proj[3]:getHeight(),proj[3]:getWidth()/2,proj[3]:getHeight()/2)
    end
    for i, tow in pairs(towers) do
        -- draw the base of the towers
        local image = tow[3]
        love.graphics.draw(image,tow[1],tow[2], tow[8], towerSize / image:getWidth(), towerSize / image:getHeight(),image:getWidth() / 2,image:getHeight() / 2)
    end
    for i,mon in pairs(monsters) do
    love.graphics.draw(mon[3],mon[4],mon[5],getAngle(mon[4],mon[5],mapPath[mon[6]][1],mapPath[mon[6]][2]) - math.rad(90),36 / mon[3]:getWidth(),36 / mon[3]:getHeight(),mon[3]:getWidth() / 2, mon[3]:getHeight() / 2) --<<--
    end
end

function updateMonsters(dt) 
    for i,mon in pairs(monsters) do
        if mon[1] <= 0 then
            cash = cash + mon[8]
            monsters[i] = nil 
        end
        local angle = getAngle(mon[4],mon[5],mapPath[mon[6]][1],mapPath[mon[6]][2])
        mon[4] = mon[4] + mon[2] * dt * dtmulti* math.cos(angle)
        mon[5] = mon[5] + mon[2] * dt * dtmulti* math.sin(angle)  
        if getDistance(mon[4],mon[5],mapPath[mon[6]][1],mapPath[mon[6]][2]) < mon[2]* dt * dtmulti then
            if mon[6] < #mapPath then
                 mon[6] = mon[6] +1 
            else
                monsters[i] = nil
                health = health - mon[7]
            end
        end
            for i, tow in pairs(towers) do
                if getDistance(mon[4],mon[5],tow[1] + tow[3]:getWidth() /2,tow[2] + tow[3]:getWidth() /2) <= tow[4] then 
                    fireTower(tow, mon) 
                end
            end
    end
end

function updateProjectiles(dt)
    for i,proj in pairs(projectiles) do
        local mon = proj[5]
        local angle = getAngle(proj[1],proj[2],mon[4],mon[5]) 
        proj[4] = angle + math.deg(90)
        proj[1] = proj[1] + proj[7] * dt * dtmulti* math.cos(angle)
        proj[2] = proj[2] + proj[7] * dt * dtmulti* math.sin(angle)
        if getDistance(proj[1],proj[2],mon[4],mon[5]) < proj[7]* dt * dtmulti then
            projectiles[i] = nil
            mon[1] = mon[1] - proj[6]
        end
    end
end

function fireTower(tow, mon) 
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
        tow[8] = (math.atan2(tow[2] - mon[5],tow[1] - mon[4])) + math.deg(90)
        local image = tow[3]
        local sx = towerSize / image:getWidth()
        local sy = towerSize / image:getHeight()
        createProjectile(tow[9],tow[1] + image:getWidth() /2*sx,tow[2] + image:getWidth() /2*sy,mon)
        tow[7] = false
    end
end

function initGame()

    levelData = json.decode(love.filesystem.read("levels/"..level..".json"))
    levelBackground = love.graphics.newImage("data/assets/backgrounds/" .. levelData["background"] .. ".png")
    bgXS = 979 / levelBackground:getWidth()
    bgYS = 739 / levelBackground:getHeight()
    bgWidth = levelBackground:getWidth() * bgXS
    bgHeight = levelBackground:getHeight() * bgYS
    mapPath = levelData["path"]

    monsters = {}
    projectiles = {}
    towers = {}
    timers = {}
    placingTower = nil

    health = maxHealth
    wave = 0
    cash = 1500

    initUI()
    gameRunning = true
end

function createTimer(name, max)
    timers[name] = {0,max,false}
end

function createProjectile(projType,x,y,target)
    local s = projectileData[projType]
    table.insert(projectiles, {x,y,projectileImages[s["image"]],0,target,s["damage"], s["speed"]})
end


function createTower(towerType,x,y)
    local s = towerData[tostring(towerType)]
    table.insert(towers,{x,y, towerImages[s["image"]], s["range"], s["cooldown"],tostring(towerType..math.random(0,100000000)), true,0,s["projectile"]})
end

function spawnMonster(monsterType)
    local s = monsterData[tostring(monsterType)]
    table.insert(monsters, {s["health"], s["speed"], monsterImages[s["image"]], mapPath[1][1], mapPath[1][2], 2, s["damage"],s["reward"]})
end
