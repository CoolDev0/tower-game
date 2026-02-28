require "data"

-- square buttons only :(

function drawUI()
    for i,button in pairs(buttons) do
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("fill",button[1],button[2],button[3]*scale,button[4]*scale,button[5]*scale)
        love.graphics.setColor(255,255,255)
        love.graphics.print(button[6],button[1] + button[3]*scale/2,button[2]+ button[4]*scale/2)
    end
    if placingTower ~= 0 then
        local image = towerImages[towerData[placingTower]["image"]]
        love.graphics.setColor(0.8,0.8,0.8,0.8)
        love.graphics.draw(image, love.mouse.getX() - image:getWidth() / 2, love.mouse.getY() - image:getHeight() / 2)
        love.graphics.setColor(1,1,1,1)
    end
    love.graphics.print("Cash: " .. cash, 0,0)
    love.graphics.print("Wave " .. wave, 0, 15)
    love.graphics.print("Health: " .. health, 0, 30)
end

function createButton(x,y,dimx,dimy,cornerRadius, text, func, arg1)
    table.insert(buttons,{x,y,dimx,dimy,cornerRadius,text,func, arg1}) 
end

function love.mousepressed(x, y)
    if placingTower ~= 0 then
            -- check if touching other tower or path
        if x < bgWidth * scale * 0.85 then
            local a = true
            local image = towerImages[towerData[placingTower]["image"]]
            for i,v in pairs(towers) do
    
            end
            if a then
                    createTower(placingTower, x - image:getWidth() / 2, y - image:getHeight() / 2)
                    placingTower = 0
                end
        end
    end
    for i,but in pairs(buttons) do
        if x < but[1] + but[3]*scale and x > but[1] and y > but[2] and y < but[2] + but[4]*scale then
            if but[7] == "tower" then
                placingTower = but[8]
            end
        end
    end
end
