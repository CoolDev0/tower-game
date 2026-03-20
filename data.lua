nativefs = require "nativefs"
json = require "json"

nativefs.mount("data")

love.graphics.setDefaultFilter("nearest","nearest")

scale = 0.5 -- don't change

level = "test"

newPath = {}

monsterData = json.decode(love.filesystem.read("monsters.json"))
monsterImages = {}
monsters = {}

projectileData = json.decode(love.filesystem.read("projectiles.json"))
projectileSpeed = 2
projectileImages = {}

towerData = json.decode(love.filesystem.read("towers.json"))
towerImages = {}

maxHealth = 100

for i,v in pairs(monsterData) do
    monsterImages[v["image"]] = love.graphics.newImage("data/assets/enemies/" .. v["image"])
end
for i,v in pairs(towerData) do
    towerImages[v["image"]] = love.graphics.newImage("data/assets/towers/" .. v["image"])
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
        if #newPath > 1 then
            love.filesystem.write("newPath.json", json.encode(newPath))
        end
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