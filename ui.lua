require "data"

-- square buttons only :(
function drawUI()
    for i,button in pairs(buttons) do
        local image = towerImages[button[8] .. ".png"]
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("fill",button[1],button[2],button[3]*scale,button[4]*scale,button[5]*scale)
        love.graphics.setColor(255,255,255)
        love.graphics.print(button[6],button[1] + button[3]*scale/15,button[2]+ button[4]*scale/4*3)
        if image then
            local sx = 48 / image:getWidth()
            local sy = 48 / image:getHeight()
            love.graphics.draw(image,button[1] + image:getWidth() / 2 * sx,button[2] + image:getHeight() / 4 * sy, 0,sy,sy)
        end
    end
    if placingTower ~= 0 then
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
end

function createButton(x,y,dimx,dimy,cornerRadius, text, func, arg1)
    table.insert(buttons,{x,y,dimx,dimy,cornerRadius,text,func, arg1}) 
end

function initUI()
    love.window.setTitle("Tower Game")
    btnofs = 40

    local text1 = towerData["test1"]["price"] .. "$ - " .. towerData["test1"]["name"]
    local text2 = towerData["test2"]["price"] .. "$ - " ..towerData["test2"]["name"]
    local text3 = towerData["test2"]["price"] .. "$ - " ..towerData["test3"]["name"]

    createButton(UIOffset + btnofs, 30, 175, 175, 30,text1,"tower","crossbow")
    createButton(UIOffset + btnofs, 30+100, 175, 175, 30,text2,"tower","test2")
    createButton(UIOffset + btnofs, 30+200, 175, 175, 30,text3,"tower","test3")

    createButton(UIOffset + btnofs +100, 30, 175, 175, 30,text1,"tower","test1")
    createButton(UIOffset + btnofs +100, 30+100, 175, 175, 30,text2,"tower","test2")
    createButton(UIOffset + btnofs +100, 30+200, 175, 175, 30,text3,"tower","test3")

    createButton(UIOffset + btnofs +200, 30, 175, 175, 30,text1,"tower","test1")
    createButton(UIOffset + btnofs +200, 30+100, 175, 175, 30,text2,"tower","test2")
    createButton(UIOffset + btnofs +200, 30+200, 175, 175, 30,text3,"tower","test3")

    createButton(UIOffset + btnofs +300, 30, 175, 175, 30,text1,"tower","test1")
    createButton(UIOffset + btnofs +300, 30+100, 175, 175, 30,text2,"tower","test2")
    createButton(UIOffset + btnofs +300, 30+200, 175, 175, 30,text3,"tower","test3")
end

function love.mousepressed(x, y)
    if placingTower ~= 0 then
            -- check if touching other tower or path
        if x < bgWidth * scale * 0.85 then
            local a = true
            local image = towerImages[towerData[placingTower]["image"]]
            if a then
                    local sx = 48 / image:getWidth()
                    local sy = 48 / image:getHeight()
                    createTower(placingTower, x , y )
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
