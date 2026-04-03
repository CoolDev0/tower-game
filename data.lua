nativefs = require "nativefs"
json = require "json"

nativefs.mount("data")

love.graphics.setDefaultFilter("nearest","nearest")

scale = 0.5 -- don't change

level = "bridge"

dtmulti = 300

newPath = {}

monsterData = json.decode(love.filesystem.read("monsters.json"))
monsterImages = {}
monsters = {}

projectileData = json.decode(love.filesystem.read("projectiles.json"))
projectileSpeed = 4
projectileImages = {}

projectileSize = 27
towerSize = 38

towerData = json.decode(love.filesystem.read("towers.json"))
towerImages = {}

maxHealth = 100

fonts = {
    ["Changa-Regular14"] = love.graphics.newFont("data/fonts/Changa-Regular.ttf", 14),
    ["Changa-Regular22"] = love.graphics.newFont("data/fonts/Changa-Regular.ttf", 22)
}

animations = {
    ["Shooting"] = {    
        
    }
}

for i,v in pairs(monsterData) do
    monsterImages[v["image"]] = love.graphics.newImage("data/assets/enemies/" .. v["image"])
end

local animations = {
    ["shoot"] = {
        ["Length"] = 2
    }
}

for i,v in pairs(towerData) do
    towerImages[i] = {
        ["Default"] = {},
        ["Base"] = {},
        ["Animations"] = {
            ["shoot"] = {
            }
      }
    }
    towerImages[i]["Default"][1] = love.graphics.newImage("data/assets/towers/" .. v["image"] .. ".png")
    towerImages[i]["Base"][1] = love.graphics.newImage("data/assets/towers/" .. v["baseImage"] .. ".png")

    for upgradeNumber,upgradeData in pairs(v["upgrades"]) do
        towerImages[i]["Default"][tonumber(upgradeNumber)] = love.graphics.newImage("data/assets/towers/" .. upgradeData["image"] .. ".png")
        towerImages[i]["Base"][tonumber(upgradeNumber)] = love.graphics.newImage("data/assets/towers/" .. upgradeData["baseImage"] .. ".png")

        for a,v in pairs(animations) do
            for n = 1, v["Length"], 1 do
              towerImages[i]["Animations"][a][tonumber(upgradeNumber)] = {}
              towerImages[i]["Animations"][a][tonumber(upgradeNumber)][n] = love.graphics.newImage("data/assets/towers/" .. upgradeData["image"] .. "_" .. a .. n .. ".png")
            end
      end
    end
end

for i,v in pairs(projectileData) do
    projectileImages[v["image"]] = love.graphics.newImage("data/assets/projectiles/" .. v["image"])
end

function getDistance(x1,y1,x2,y2)
    return math.sqrt((math.abs(x1 - x2))^2+(math.abs(y1 - y2))^2)
end

function getAngle(x1,y1,x2,y2)
    return(math.atan2(y2 - y1,x2 - x1))
end


function love.keypressed(key)
   if key == "space" then
        table.insert(newPath, {love.mouse.getX(), love.mouse.getY()})
   end
   if key == "t" then
        if #newPath > 1 then
            mapPath = newPath
            for i,v in pairs(monsters) do
                v[6] = 1
            end
        end
   end
    if key == "s" then
        print(json.encode(newPath))
        love.filesystem.write("newPath.json", json.encode(newPath))
    end
end


function drawNewPath()
       love.graphics.setColor(0,255,0)
        for i,v in pairs(newPath) do
        if not(i == #newPath)  then
            love.graphics.line(v[1],v[2],newPath[i+1][1],newPath[i+1][2])
        end
    end
end