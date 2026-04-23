nativefs = require "nativefs"
json = require "json"

nativefs.mount("data")

love.graphics.setDefaultFilter("nearest","nearest")

scale = 0.5 -- don't change

level = "green"

dtmulti = 300

newPath = {}

monsterData = json.decode(love.filesystem.read("monsters.json"))
monsterImages = {}
monsters = {}

projectileData = json.decode(love.filesystem.read("projectiles.json"))
projectileSpeed = 4
projectileImages = {}

projectileSize = 16
towerSize = 38

towerData = json.decode(love.filesystem.read("towers.json"))
towerImages = {}

maxHealth = 100

fonts = {
    ["Changa-Regular14"] = love.graphics.newFont("data/fonts/Changa-Regular.ttf", 14),
    ["Changa-Regular22"] = love.graphics.newFont("data/fonts/Changa-Regular.ttf", 22)
}

for i,v in pairs(monsterData) do
    monsterImages[v["image"]] = love.graphics.newImage("data/assets/enemies/" .. v["image"])
end


animations = {

}

for _i,s in pairs(love.filesystem.getDirectoryItems("data/assets/towers")) do
    local si, _ei = string.find(s,"_")
    if si then
        local name = string.sub(s,0,si-1)
        local animation = string.sub(s,si +1,string.len(s) - 5)
        local frame = string.sub(s,string.len(s) - 4,string.len(s) - 4)

        if not animations[animation] then
            animations[animation] = {}
        end
        if not animations[animation][name] then
            animations[animation][name] = frame
        elseif frame > animations[animation][name] then
            animations[animation][name] = frame
        end
    end
end

for i,v in pairs(animations) do
    for n,m in pairs(v) do
        print(i .. " " .. n .. " " .. m)
    end
end

for i,v in pairs(towerData) do
    towerImages[i] = {
        ["Default"] = {},
        ["Base"] = {},
        ["Animations"] = {
      }
    }
    towerImages[i]["Default"][1] = love.graphics.newImage("data/assets/towers/" .. v["image"] .. ".png")
    towerImages[i]["Base"][1] = love.graphics.newImage("data/assets/towers/" .. v["baseImage"] .. ".png")
    for a,k in pairs(animations) do
        if not towerImages[i]["Animations"][a] then
            towerImages[i]["Animations"][a] = {}
        end
        for n = 1, animations[a][i], 1 do
            if not towerImages[i]["Animations"][a][1] then
                towerImages[i]["Animations"][a][1] = {}
            end
            towerImages[i]["Animations"][a][1][n] = love.graphics.newImage("data/assets/towers/" .. v["image"] .. "_" .. a .. n .. ".png")
        end
     end

    for upgradeNumber,upgradeData in pairs(v["upgrades"]) do
        towerImages[i]["Default"][tonumber(upgradeNumber)] = love.graphics.newImage("data/assets/towers/" .. upgradeData["image"] .. ".png")
        towerImages[i]["Base"][tonumber(upgradeNumber)] = love.graphics.newImage("data/assets/towers/" .. upgradeData["baseImage"] .. ".png")

        for a,k in pairs(animations) do
            if not towerImages[i]["Animations"][a] then
                towerImages[i]["Animations"][a] = {}
            end
            for n = 1, animations[a][i], 1 do
              if not towerImages[i]["Animations"][a][tonumber(upgradeNumber)] then
                    towerImages[i]["Animations"][a][tonumber(upgradeNumber)] = {}
              end
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