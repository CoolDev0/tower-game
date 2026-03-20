require "data"

-- square buttons only :(
function drawUI()
    for i,button in pairs(buttons) do
        love.graphics.setColor(0,0,0)
        local image = towerImages[button[8] .. ".png"]
        love.graphics.rectangle("fill",button[1],button[2],button[3]*scale,button[4]*scale,button[5]*scale)
        love.graphics.setColor(255,255,255)
        love.graphics.print(button[6],button[1] + button[3]*scale/15,button[2]+ button[4]*scale/4*3)
        if image then
            local sx = 48 / image:getWidth()
            local sy = 48 / image:getHeight()
            love.graphics.draw(image,button[1] + image:getWidth() / 2 * sx,button[2] + image:getHeight() / 4 * sy, 0,sy,sy)
        end
    end
    if placingTower ~= nil then
        local image = towerImages[towerData[placingTower]["image"]]
        love.graphics.setColor(0.8,0.8,0.8,0.8)
        love.graphics.circle("line",love.mouse.getX(),love.mouse.getY(), towerData[placingTower]["range"])
        local sx = 48 / image:getWidth()
        local sy = 48 / image:getHeight()
        love.graphics.draw(image, love.mouse.getX(), love.mouse.getY(), 0, sx, sy, image:getWidth() / 2,image:getHeight() / 2)
        love.graphics.setColor(1,1,1,1)
    end
    love.graphics.print("Cash: " .. cash, 0,0)
    love.graphics.print("Wave " .. wave, 0, 15)
    love.graphics.print("Health: " .. health, 0, 30)

    -- Health bar for now 
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill",buttonOffset,330,387,10)
    love.graphics.setColor(1,0,0)
    love.graphics.rectangle("fill",buttonOffset,330,387/(maxHealth/health),10)
end

function createButton(x,y,dimx,dimy,cornerRadius, text, func, arg1)
    table.insert(buttons,{x,y,dimx,dimy,cornerRadius,text,func, arg1}) 
end

function initUI()
    UIOffset = levelBackground:getWidth() * scale * .85
    buttonOffset = UIOffset + 40
    buttons = {}

    love.window.setTitle("Tower Game - " .. level)
    local text1 = towerData["test1"]["price"] .. "$ - " .. towerData["test1"]["name"]
    local text2 = towerData["test2"]["price"] .. "$ - " ..towerData["test2"]["name"]
    local text3 = towerData["test2"]["price"] .. "$ - " ..towerData["test3"]["name"]

    createButton(buttonOffset, 30, 175, 175, 30,"Crossbow","tower","crossbow")
    createButton(buttonOffset, 30+100, 175, 175, 30,text2,"tower","test2")
    createButton(buttonOffset, 30+200, 175, 175, 30,text3,"tower","test3")

    createButton(buttonOffset +100, 30, 175, 175, 30,text1,"tower","test1")
    createButton(buttonOffset +100, 30+100, 175, 175, 30,text2,"tower","test2")
    createButton(buttonOffset +100, 30+200, 175, 175, 30,text3,"tower","test3")

    createButton(buttonOffset +200, 30, 175, 175, 30,text1,"tower","test1")
    createButton(buttonOffset +200, 30+100, 175, 175, 30,text2,"tower","test2")
    createButton(buttonOffset +200, 30+200, 175, 175, 30,text3,"tower","test3")

    createButton(buttonOffset +300, 30, 175, 175, 30,text1,"tower","test1")
    createButton(buttonOffset +300, 30+100, 175, 175, 30,text2,"tower","test2")
    createButton(buttonOffset +300, 30+200, 175, 175, 30,text3,"tower","test3")
end

function love.mousepressed(x, y)
    if placingTower ~= nil then
            -- check if touching other tower or path
        if x < bgWidth * scale * 0.85 then
            local a = true
            local image = towerImages[towerData[placingTower]["image"]]
            local sx = 48 / image:getWidth()
            local sy = 48 / image:getHeight()
            cash = cash - towerData[placingTower]["price"]
            createTower(placingTower, x , y )
            placingTower = nil
        end
    end
    for i,but in pairs(buttons) do
        if x < but[1] + but[3]*scale and x > but[1] and y > but[2] and y < but[2] + but[4]*scale then
            if but[7] == "tower" then
                if cash >= towerData[but[8]]["price"] then
                    placingTower = but[8]
                end
            end
        end
    end
end
