require "data"

buttons = {}
placingTower = 0

-- square buttons only :(

function drawUI()
    for i,button in pairs(buttons) do
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("fill",button[1],button[2],button[3]*scale,button[4]*scale,button[5]*scale)
        love.graphics.setColor(255,255,255)
        love.graphics.print(button[6],button[1] + button[3]*scale/2,button[2]+ button[4]*scale/2)
    end
    if placingTower ~= 0 then
        local image = towerImages[towerData[tostring(placingTower)]["image"]]
        love.graphics.setColor(0.8,0.8,0.8,0.8)
        love.graphics.draw(image, love.mouse.getX() - image:getWidth() / 2, love.mouse.getY() - image:getHeight() / 2)
        love.graphics.setColor(1,1,1,1)
    end
    love.graphics.print("Cash: " .. cash, 0,0)
    love.graphics.print("Wave " .. wave, 0, 15)
end

function createButton(x,y,dimx,dimy,cornerRadius, text, func, arg1)
    table.insert(buttons,{x,y,dimx,dimy,cornerRadius,text,func, arg1}) 
end

function love.mousepressed(x, y)
    if placingTower ~= 0 then
        if love.mouse.getX() < bgWidth * scale * 0.85 then
            local image = towerImages[towerData[tostring(placingTower)]["image"]]
            createTower(placingTower, love.mouse.getX() - image:getWidth() / 2, love.mouse.getY() - image:getHeight() / 2)
            placingTower = 0
        end
    end
    for i,but in pairs(buttons) do
        if love.mouse.getX() < but[1] + but[3]*scale and love.mouse.getX() > but[1] and love.mouse.getY() > but[2] and love.mouse.getY() < but[2] + but[4]*scale then
            if but[7] == "tower" then
                placingTower = but[8]
            end
        end
    end
end
