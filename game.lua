require "ui"
require "data"

-- add a way to make some zones unplacable for towers

function drawGame()
    love.graphics.draw(levelBackground, 0, 0, 0, bgXS, bgYS)
    love.graphics.setColor(0,0,255)
    love.graphics.setColor(255,255,255)
    for i, proj in pairs(projectiles) do
        love.graphics.draw(proj["Image"],proj["Position"][1],proj["Position"][2],proj["Rotation"],27 / proj["Image"]:getWidth(), 27 / proj["Image"]:getHeight(),proj["Image"]:getWidth()/2,proj["Image"]:getHeight()/2)
    end
    for i, tow in pairs(towers) do
        love.graphics.draw(tow["BaseImage"],tow["Position"][1],tow["Position"][2], 0, towerSize / tow["Image"]:getWidth(), towerSize / tow["Image"]:getHeight(),tow["Image"]:getWidth() / 2,tow["Image"]:getHeight() / 2)
        love.graphics.draw(tow["Image"],tow["Position"][1],tow["Position"][2], tow["Rotation"], towerSize / tow["Image"]:getWidth(), towerSize / tow["Image"]:getHeight(),tow["Image"]:getWidth() / 2,tow["Image"]:getHeight() / 2)
    end
    for i,mon in pairs(monsters) do
    love.graphics.draw(mon["Image"],mon["Position"][1],mon["Position"][2],getAngle(mon["Position"][1],mon["Position"][2],mapPath[mon["Destination"]][1],mapPath[mon["Destination"]][2]) - math.rad(90),36 / mon["Image"]:getWidth(),36 / mon["Image"]:getHeight(),mon["Image"]:getWidth() / 2, mon["Image"]:getHeight() / 2) --<<--
    end
end

function updateMonsters(dt) 
    for i,mon in pairs(monsters) do
        if mon["Health"] <= 0 then
            cash = cash + mon["Reward"]
            monsters[i] = nil 
        end
        local angle = getAngle(mon["Position"][1],mon["Position"][2],mapPath[mon["Destination"]][1],mapPath[mon["Destination"]][2])
        mon["Position"][1] = mon["Position"][1] + mon["Speed"] * dt * dtmulti* math.cos(angle)
        mon["Position"][2] = mon["Position"][2] + mon["Speed"] * dt * dtmulti* math.sin(angle)  
        if getDistance(mon["Position"][1],mon["Position"][2],mapPath[mon["Destination"]][1],mapPath[mon["Destination"]][2]) < mon["Speed"]* dt * dtmulti then
            if mon["Destination"] < #mapPath then
                 mon["Destination"] = mon["Destination"] +1 
            else
                monsters[i] = nil
                health = health - mon["Damage"]
            end
        end
            for i, tow in pairs(towers) do
                if getDistance(mon["Position"][1],mon["Position"][2],tow["Position"][1] + tow["Image"]:getWidth() /2,tow["Position"][2] + tow["Image"]:getWidth() /2) <= tow["Range"] then 
                    fireTower(tow, mon) 
                end
            end
    end
end

function updateProjectiles(dt)
    for i,proj in pairs(projectiles) do
        local mon = proj["Target"]
        local angle = getAngle(proj["Position"][1],proj["Position"][2],mon["Position"][1],mon["Position"][2]) 
        proj["Rotation"] = angle + math.deg(90)
        proj["Position"][1] = proj["Position"][1] + proj["Speed"] * dt * dtmulti* math.cos(angle)
        proj["Position"][2] = proj["Position"][2] + proj["Speed"] * dt * dtmulti* math.sin(angle)
        if getDistance(proj["Position"][1],proj["Position"][2],mon["Position"][1],mon["Position"][2]) < proj["Speed"]* dt * dtmulti then
            projectiles[i] = nil
            mon["Health"] = mon["Health"] - proj["Damage"]
        end
    end
end

function fireTower(tow, mon) 
    local t = timers[tow["ID"]]
    if t ~= nil then
        if t[3] then
            timers[tow["ID"]] = nil
            tow["canFire"] = true
        end
    else
        createTimer(tow["ID"],tow["Cooldown"])
    end

    if tow["canFire"] then
        tow["Rotation"] = (math.atan2(tow["Position"][2] - mon["Position"][2],tow["Position"][1] - mon["Position"][1])) + math.deg(90)
        local image = tow["Image"]
        local sx = towerSize / image:getWidth()
        local sy = towerSize / image:getHeight()
        createProjectile(tow["Projectile"],tow["Position"][1] + image:getWidth() /2*sx,tow["Position"][2] + image:getWidth() /2*sy,mon)
        tow["canFire"] = false
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

    towerID = 0

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
    local t = {
        ["Position"] = {x,y},
        ["Image"] = projectileImages[s["image"]],
        ["Rotation"] = 0,
        ["Target"] = target,
        ["Damage"] = s["damage"],
        ["Speed"] = s["speed"]
    }
    table.insert(projectiles,t)
end


function createTower(towerType,x,y)
    local s = towerData[tostring(towerType)]
    local l  = math.random(1,2)
    local t = {
        ["Position"] = {x,y},
        ["Animation"] = {
            ["Name"] = nil,
            ["Frame"] = 0
        },
        ["Upgrade"] = 2,
        ["Image"] = towerImages[placingTower]["Default"][l],
        ["BaseImage"] = towerImages[placingTower]["Base"][l],
        ["Rotation"] = 0,
        ["Range"] = s["range"],
        ["Cooldown"] = s["cooldown"],
        ["Projectile"] = s["projectile"],
        ["canFire"] = true,
        ["ID"] = towerID
    }
    towerID = towerID + 1
    table.insert(towers,t)
end

function spawnMonster(monsterType)
    local s = monsterData[tostring(monsterType)]
    local t = {
        ["Position"] = {mapPath[1][1], mapPath[1][2]},
        ["Health"] = s["health"],
        ["Image"] = monsterImages[s["image"]],
        ["Speed"] = s["speed"],
        ["Destination"] = 2,
        ["Damage"] = s["damage"],
        ["Reward"] = s["reward"]
    }
    table.insert(monsters,t)
end
