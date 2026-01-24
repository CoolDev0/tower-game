urfs = require "urfs"
    
urfs.mount("data")
urfs.setWriteDir("data")

bgDir = "data/assets/backgrounds"
enDir = "data/assets/enemies"

scale = 0.5

newPath = {}
mapPath = {{0*scale,345*scale},{685*scale,345*scale},{685*scale,625*scale},{1175*scale,645*scale},{1175*scale,160*scale},{1630*scale,145*scale}} -- Index 1: Entrance, Last index: Exit

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