display.setStatusBar( display.HiddenStatusBar )

local topY = display.screenOriginY --Numerical value for the top of the screen
local rightX = display.contentWidth - display.screenOriginX --Numerical value for the right of the screen
local bottomY = display.contentHeight - display.screenOriginY --Numerical value for the bottom of the screen
local leftX = display.screenOriginX --Numerical value for the left of the screen
local screenW = rightX - leftX --Numerical value for the width of the screen
local screenH = bottomY - topY --Numerical value for the height of the screen

score1 = 0
score2 = 0

player1 = display.newRect(leftX, topY + screenH/2 - screenH/10, screenW/20, screenH/5)
player2 = display.newRect(rightX - screenW/20, topY + screenH/2 - screenH/10, screenW/20, screenH/5)

topLine = display.newLine(leftX + screenW/20, topY, rightX - screenW/20, topY)
topLine.width = screenH/10

bottomLine = display.newLine(leftX + screenW/20, bottomY, rightX - screenW/20, bottomY)
bottomLine.width = screenH/10

middleLine = display.newLine(leftX + screenW/2, topY, leftX + screenW/2, bottomY)
middleLine.width = screenH/40

textScore1 = display.newText( score1, leftX + screenW/2 - screenW/5, topY + screenH/7, native.systemFont, 100 )
textScore2 = display.newText( score2, leftX + screenW/2 + screenW/10, topY + screenH/7, native.systemFont, 100 )

textScore1.alpha = 0.5
textScore2.alpha = 0.5

ball = display.newCircle(leftX + screenW/2, topY + screenH/2, screenW/40)


function movePlayer1( event )
    if event.phase == "began" then
	
        markY = player1.y    -- store y location of object
	
    elseif event.phase == "moved" then
	
        local y = (event.y - event.yStart) + markY
        
        player1.y = y    -- move object based on calculations above
    end
    
    return true
end

function movePlayer2( event )
    if event.phase == "began" then
	
        mark2Y = player2.y    -- store y location of object
	
    elseif event.phase == "moved" then
	
        local y = (event.y - event.yStart) + mark2Y
        
        player2.y = y    -- move object based on calculations above
    end
    
    return true
end

function updateGame ( event )
	if player1.y + player1.height/2 > bottomY then
		player1.y = bottomY - player1.height/2
	elseif player1.y - player1.height/2 < topY then
		player1.y = topY + player1.height/2
	end
	
	if player2.y + player2.height/2 > bottomY then
		player2.y = bottomY - player2.height/2
	elseif player2.y - player2.height/2 < topY then
		player2.y = topY + player2.height/2
	end
end

player1:addEventListener("touch", movePlayer1)
player2:addEventListener("touch", movePlayer2)
Runtime:addEventListener("enterFrame",updateGame)
