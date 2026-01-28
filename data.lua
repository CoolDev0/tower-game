urfs = require "urfs"
json = require "json"
    
urfs.mount("data")
urfs.setWriteDir("data")

enDir = "data/assets/enemies"

scale = 0.5 -- don't change

level = "test"

levelData = json.decode(love.filesystem.read("levels/"..level..".json"))
levelBackground = love.graphics.newImage("data/assets/backgrounds/" .. levelData["background"] .. ".png")

newPath = {}
mapPath = levelData["path"]


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
end


function drawNewPath()
       love.graphics.setColor(0,255,0)
        for i,v in pairs(newPath) do
        if not(i == #newPath)  then
            love.graphics.line(v[1],v[2],newPath[i+1][1],newPath[i+1][2])
        end
    end
end