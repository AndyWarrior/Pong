display.setStatusBar( display.HiddenStatusBar )

system.activate("multitouch")

local topY = display.screenOriginY --Numerical value for the top of the screen
local rightX = display.contentWidth - display.screenOriginX --Numerical value for the right of the screen
local bottomY = display.contentHeight - display.screenOriginY --Numerical value for the bottom of the screen
local leftX = display.screenOriginX --Numerical value for the left of the screen
local screenW = rightX - leftX --Numerical value for the width of the screen
local screenH = bottomY - topY --Numerical value for the height of the screen


function startGame()
	score1 = 0
	score2 = 0
	maxScore = 10

	direction = 1
	speed = 2

	hitplayer1 = false
	hitplayer2 = false
	
	allow1 = false
	allow2 = false
	
	singleplayer = false
	gameover = false

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
	
	option1 = display.newText( "1 Player", leftX + screenW/10, textScore1.y + screenH/5, native.systemFont, 36 )
	option2 = display.newText( "2 Players", leftX + screenW/2 + screenW/20, textScore2.y + screenH/5 , native.systemFont, 36 )

	ball = display.newCircle(leftX + screenW/2, topY + screenH/2, screenW/40)
	
	Runtime:addEventListener("touch", selectOption)
end

function updateGame(event)
	checkCollisions()
	moveBall()
	updateScore()
end

function updateScore()
	if score1 >= maxScore or score2 >= maxScore then
		score1 = 0
		score2 = 0
	end
	
	textScore1.text = score1
	textScore2.text = score2
end

function move1( event )
    if event.phase == "began" and event.x < screenW/2 and event.y > player1.y - screenH/10 and event.y < player1.y + screenH/10 then
	
        markY = player1.y    -- store y location of object
		allow1 = true
	end
    if allow1 == true and event.x < screenW/2 then
	
        local y = (event.y - event.yStart) + markY
        
        player1.y = y    -- move object based on calculations above
	end
	if event.phase == "ended" and event.x < screenW/2 then
		allow1 = false
    end
    
    return true
end

function move2( event )
    if event.phase == "began" and event.x > screenW/2 and event.y > player2.y - screenH/10 and event.y < player2.y + screenH/10 then
	
        mark2Y = player2.y    -- store y location of object
		allow2 = true
	end
    if allow2 == true and event.x > screenW/2 then
	
        local y = (event.y - event.yStart) + mark2Y
        
        player2.y = y    -- move object based on calculations above
	end
	if event.phase == "ended" and event.x > screenW/2 then
		allow2 = false
    end
    
    return true
end

function cpumove()
	if ball.y > player2.y then
		player2.y = player2.y + speed
	elseif ball.y < player2.y then
		player2.y = player2.y - speed
	end
end

function moveBall()
	if direction == 1 then
		ball.x = ball.x + speed
		ball.y = ball.y - speed
	elseif direction == 2 then
		ball.x = ball.x - speed
		ball.y = ball.y - speed
	elseif direction == 3 then
		ball.x = ball.x - speed
		ball.y = ball.y + speed
	elseif direction == 4 then
		ball.x = ball.x + speed
		ball.y = ball.y + speed
	end
end

function checkCollisions()
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
	
	if ball.y + screenW/40 < topLine.y + screenH/10 then
		if direction == 1 then
			direction = 4
		elseif direction == 2 then
			direction = 3
		end
	elseif ball.y + screenW/40 > bottomLine.y - screenH/20 then
		if direction == 3 then
			direction = 2
		elseif direction == 4 then
			direction = 1
		end
	end
	
	if (inside(ball,player1) and hitplayer1 == false) then
		hitplayer1 = true
		hitplayer2 = false
		speed = speed + 1
		if direction == 2 then
			direction = 1
		elseif direction == 3 then
			direction = 4
		end
	elseif (inside(ball,player2) and hitplayer2 == false) then
		hitplayer2 = true
		hitplayer1 = false
		speed = speed + 1
		if direction == 1 then
			direction = 2
		elseif direction == 4 then
			direction = 3
		end
	end
	
	if ball.x < leftX then
		score2 = score2 + 1
		if score1 >= maxScore or score2 >= maxScore then
			gameover = true
		end
		resetGame(2)
	elseif ball.x > rightX then
		score1 = score1 + 1
		if score1 >= maxScore or score2 >= maxScore then
			gameover = true
		end
		resetGame(1)
	end
end

function resetBall()
	ball.x = leftX + screenW/2
	ball.y = topY + screenH/2
end

function resetPlayers()
	player1.y = topY + screenH/2
	player2.y = topY + screenH/2
end

function resetGame(n)
	local z = math.random(1,2)
	if n == 1 then
		if z == 1 then
			direction = 2
		elseif z == 2 then
			direction = 3
		end
	elseif n == 2 then
		if z == 1 then
			direction = 1
		elseif z == 2 then
			direction = 4
		end
	end
	resetBall()
	speed = 2
	hitplayer1 = false
	hitplayer2 = false
	if gameover == true then
		resetPlayers()
		Runtime:removeEventListener("touch", move1)
		if singleplayer==false then
			Runtime:removeEventListener("touch", move2)
		else Runtime:removeEventListener("enterFrame", cpumove)
		end
		Runtime:removeEventListener("enterFrame",updateGame)
		Runtime:addEventListener("touch",selectOption)
		option1 = display.newText( "1 Player", leftX + screenW/10, textScore1.y + screenH/5, native.systemFont, 36 )
		option2 = display.newText( "2 Players", leftX + screenW/2 + screenW/20, textScore2.y + screenH/5 , native.systemFont, 36 )
	end
end

function inside(obj1, obj2)
        return obj1.contentBounds.xMin < obj2.contentBounds.xMax
                and obj1.contentBounds.xMax > obj2.contentBounds.xMin
                and obj1.contentBounds.yMin < obj2.contentBounds.yMax
                and obj1.contentBounds.yMax > obj2.contentBounds.yMin
end

function selectOption(event)
	if event.x < screenW/2 then
		singleplayer = true
	elseif event.x > screenW/2 then
		singleplayer = false
	end
	
	Runtime:addEventListener("touch", move1)
	if singleplayer==false then
		Runtime:addEventListener("touch", move2)
	else Runtime:addEventListener("enterFrame", cpumove)
	end
	Runtime:addEventListener("enterFrame",updateGame)
	Runtime:removeEventListener("touch",selectOption)
	gameover = false
	option1:removeSelf()
	option1 = nil
	option2:removeSelf()
	option2 = nil
end

startGame()