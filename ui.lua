require "data"

local canPlace = false

local r = 0
local g = 0

local hpX = 15
local hpY = 25

-- add animations for like when you gain money or enemies die or you take damage

-- UI Images

local uiImages = {
    ["healthbar"] = love.graphics.newImage("data/assets/ui/healthbar.png"),
    ["heart"] = love.graphics.newImage("data/assets/ui/heart.png"),
    ["coins"] = love.graphics.newImage("data/assets/ui/coins.png")
}

local sidebarWidth = 300
local sidebarOffset = 1280 - sidebarWidth

-- square buttons only :(
function drawUI()
    love.graphics.setFont(fonts["Changa-Regular14"])

    for i,button in pairs(buttons) do
        if button[7] == "tower" then
            love.graphics.setColor(0,0,0)
            local image = towerImages[button[8] .. ".png"]
            love.graphics.rectangle("line",button[1],button[2],button[3]*scale,button[4]*scale,button[5]*scale)
            local t = towerData[button[8]]["name"]
            local t2 = towerData[button[8]]["price"] .. " $"
            love.graphics.setColor(0,0,0)
            love.graphics.print(t,button[1] + (button[3] * scale - love.graphics.getFont():getWidth(t)) / 2, button[2])
            love.graphics.print(t2,button[1] + (button[3] * scale - love.graphics.getFont():getWidth(t2)) / 2, button[2] + (button[4] - love.graphics.getFont():getHeight(t2)) /2.33)
            love.graphics.setColor(1,1,1)
            if image then
                local sx = towerSize / image:getWidth()
                local sy = towerSize / image:getHeight()
                love.graphics.draw(image,button[1] + button[3] / 4,button[2] + button[4] / 4, 0,sx,sy, image:getWidth() / 2, image:getHeight() /2)
            end
        end
    end

    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill",hpX,hpY,280,19)
    love.graphics.setColor(maxHealth / health - 0.5,health / maxHealth,0)
    love.graphics.rectangle("fill",hpX,hpY,280/(maxHealth/health),19)
    love.graphics.setColor(1, 1, 1,0.5)
    love.graphics.rectangle("fill", sidebarOffset-200, 15,190,40)
    love.graphics.setColor(1,1,1)

    love.graphics.setFont(fonts["Changa-Regular22"])
    love.graphics.print(cash, sidebarOffset-190, 16)
    love.graphics.print("Wave " .. wave, bgWidth / 2, 16)
    love.graphics.print(math.ceil(health / maxHealth * 100) .. " %", hpX + uiImages["healthbar"]:getWidth() * 2.52 + 10, hpY - 9)
    love.graphics.setFont(fonts["Changa-Regular14"])

    love.graphics.draw(uiImages["coins"],sidebarOffset - 45, 23,0,1.25)

    love.graphics.draw(uiImages["healthbar"],hpX,hpY - 7,0,2.52)
    love.graphics.draw(uiImages["heart"],hpX+5,hpY,0,2.52)

    if placingTower ~= nil then
        if love.mouse.getX() <= sidebarOffset then
            --for i,v in pairs(towers) do
            --    if getDistance(v[1],v[2],love.mouse.getX(),love.mouse.getY()) > v[3]:getWidth() + towerImages[towerData[placingTower]["image"]]:getWidth() then
                    canPlace = true 
            --     else
            --        canPlace = false
             --   end
            --end
        else 
            canPlace = false
        end
        if canPlace then
            r = 0
            g = 0.8
        else
            r = 0.8
            g = 0
        end
        local image = towerImages[towerData[placingTower]["image"]]
        love.graphics.setColor(r,g,0,0.8)
        love.graphics.circle("line",love.mouse.getX(),love.mouse.getY(), towerData[placingTower]["range"])
         love.graphics.setColor(r,g,0,0.2)
        love.graphics.circle("fill",love.mouse.getX(),love.mouse.getY(), towerData[placingTower]["range"])
        love.graphics.setColor(r,g,0,0.8)
        local sx = towerSize / image:getWidth()
        local sy = towerSize / image:getHeight()
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(image, love.mouse.getX(), love.mouse.getY(), 0, sx, sy, image:getWidth() / 2,image:getHeight() / 2)
    end
end

function createButton(x,y,dimx,dimy,cornerRadius, text, func, arg1)
    table.insert(buttons,{x,y,dimx,dimy,cornerRadius,text,func, arg1}) 
end

function initUI()
    love.graphics.setFont(fonts["Changa-Regular14"])
    buttonOffset = sidebarOffset + 6
    buttons = {}

    love.window.setTitle("Tower Game - " .. levelData["name"])

    createButton(buttonOffset, 30, 175, 175, 30,"","tower","crossbow")
    createButton(buttonOffset, 30+100, 175, 175, 30,"","tower","test2")
    createButton(buttonOffset, 30+200, 175, 175, 30,"","tower","test3")

    createButton(buttonOffset +100, 30, 175, 175, 30,"","tower","test1")
    createButton(buttonOffset +100, 30+100, 175, 175, 30,"","tower","test2")
    createButton(buttonOffset +100, 30+200, 175, 175, 30,"","tower","test3")

    createButton(buttonOffset +200, 30, 175, 175, 30,"","tower","test1")
    createButton(buttonOffset +200, 30+100, 175, 175, 30,"","tower","test2")
    createButton(buttonOffset +200, 30+200, 175, 175, 30,"","tower","test3")

    createButton(buttonOffset +300, 30, 175, 175, 30,"","tower","test1")
    createButton(buttonOffset +300, 30+100, 175, 175, 30,"","tower","test2")
    createButton(buttonOffset +300, 30+200, 175, 175, 30,"","tower","test3")
end

function love.mousepressed(x, y)
    if placingTower ~= nil then
        if canPlace then
            local a = true
            local image = towerImages[towerData[placingTower]["image"]]
            local sx = towerSize / image:getWidth()
            local sy = towerSize / image:getHeight()
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
