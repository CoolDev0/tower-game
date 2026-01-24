buttons = {}

function drawButtons()
    
    for i,button in pairs(buttons) do
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("fill",button[1],button[2],button[3]*scale,button[4]*scale,button[5]*scale)
        love.graphics.setColor(255,255,255)
        love.graphics.print(i,button[1] + button[3]*scale/2,button[2]+ button[4]*scale/2)
    end
    love.graphics.print(love.mouse.getX(),0,20)
end

function createButton(x,y,dimx,dimy,cornerRadius, text, func)
    table.insert(buttons,{x,y,dimx,dimy,cornerRadius,text, func}) 
end