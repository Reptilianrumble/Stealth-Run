-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"

--------------------------------------------


-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX
local hero = {}

local function setHeroProperties ()
-- Hero Properties 
hero.speed = 30

end

local function setHeroVelocity ()
	heroHorizontalVelocity, heroVerticalVelocity = hero:getLinearVelocity()
	hero:setLinearVelocity ( hero.velocity, heroVerticalVelocity)
end

local function onKeyEvent ( event )
	
	if (event.keyName == "w" or event.keyName == "space" or event.keyName == "up") and heroVerticalVelocity == 0 then
		Runtime:addEventListener ("enterFrame", setHeroVelocity)
		hero:applyLinearImpulse (0,-20, hero.x, hero.y)
	elseif event.keyName == "a" or event.keyName == "left" then
		Runtime:addEventListener ("enterFrame", setHeroVelocity)
		hero.velocity = -70
		direction = -1
		if (event.keyName == "a" or event.keyName == "left") and event.phase == "up" then
		hero.velocity = hero.velocity + 70
		Runtime:removeEventListener ("enterFrame", setHeroVelocity)
		end
	elseif event.keyName == "d" or event.keyName == "right" then
		Runtime:addEventListener ("enterFrame", setHeroVelocity)
		hero.velocity = 70
		direction = 1
		if (event.keyName ~= "a" or event.keyName ~= "left") and event.phase == "up" then
		hero.velocity =  hero.velocity - 70
		Runtime:removeEventListener ("enterFrame", setHeroVelocity)
		end
	elseif 	(event.keyName == "s" or event.keyName == "down") and heroVerticalVelocity ~= 0 then
		Runtime:addEventListener ("enterFrame", setHeroVelocity)
		heroVerticalVelocity = -0.01
		hero:applyLinearImpulse (0,7.5, hero.x, hero.y)
	elseif  (event.keyName == "f") then 
		local projectile = display.newRect(hero.x, hero.y, 5, 5 )
		projectile:setFillColor(1, 0, 0)
        	physics.addBody( projectile, 'dynamic' )
       		projectile.gravityScale = 1
       		projectile:setLinearVelocity( (direction * 500), 0 )
	end
end




function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	physics.start()
	physics.pause()


	-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.
	local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0 
	background.anchorY = 0
	background:setFillColor( 1 )
	
	-- make a hero (off-screen), position it, and rotate slightly
	hero = display.newImageRect( "stealth_run_character.png", 80, 80 )
	hero.x, hero.y = 30, 212.5
	
	-- add physics to the hero
	physics.addBody( hero, { density=1.0, wfriction=0.3, bounce=0.0 } )
	hero.isFixedRotation = true
	
	
	local enemy = display.newImageRect( "Enemy.png", 50, 50 )
	enemy.x, enemy.y = 450, 212.5
	
	

	physics.addBody( enemy, { density=1.0, friction=0.3, bounce=0.3 } )
	enemy.isFixedRotation = true
	
	local HUD = display.newText("Score:" .. "    " .. "Time:", 20, 40, native.systemFont, 12 )
	HUD:setFillColor ( 0, 0, 0)
	
	----------------------------------------adding enemy move loop here
	local hello = true	
	----------------------------------------
	
	
	local wallLeft	= display.newImageRect( "BorderWall.png", 20, 3000 )
	wallLeft.x, wallLeft.y = -50, 3000
	wallLeft.anchorX = 0
	wallLeft.anchorY = 1
	
	physics.addBody( wallLeft, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	wallLeft.isFixedRotation = true
	
	local wallRight = display.newImageRect( "BorderWall.png", 20, 3000 )
	wallRight.x, wallRight.y = 510, 3000
	wallRight.anchorX = 0
	wallRight.anchorY = 1
	
	
	physics.addBody( wallRight, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	wallRight.isFixedRotation = true
	
	local roof = display.newImageRect( "BorderWall.png", 3000, 20 )
	roof.x, roof.y = -50, 20
	roof.anchorX = 0
	roof.anchorY = 1
	
	
	physics.addBody( roof, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	roof.isFixedRotation = true
	
	local step1 = display.newImageRect( "Step.png", 30, 30 )
	step1.x, step1.y = 200, 238
	step1.anchorX = 0
	step1.anchorY = 1
	
	physics.addBody( step1, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	step1.isFixedRotation = true
	
	local step2 = display.newImageRect( "Step.png", 30, 50 )
	step2.x, step2.y = 230, 238
	step2.anchorX = 0
	step2.anchorY = 1
	
	physics.addBody( step2, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	step2.isFixedRotation = true
	
	-- create a ground object and add physics (with custom shape)
	local ground = display.newImageRect( "floor.png", screenW, 82 )
	ground.anchorX = 0
	ground.anchorY = 1
	--  draw the ground at the very bottom of the screen
	ground.x, ground.y = display.screenOriginX, display.actualContentHeight + display.screenOriginY
	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	local groundShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	physics.addBody( ground, "static", { friction=0.3, shape=grassShape } )
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( ground)
	sceneGroup:insert( hero )
	sceneGroup:insert( wallLeft )
	sceneGroup:insert( wallRight )
	sceneGroup:insert( step1 )
	sceneGroup:insert( step2 )
	sceneGroup:insert( enemy )
	sceneGroup:insert( HUD )
	--sceneGroup:insert( controls )
	--sceneGroup:insert( btnJump )
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup

Runtime:addEventListener( "key", onKeyEvent )
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene






--************************************************************************************************************************************
--**************************** BELOW IS A VERSION WITH EVERYTHING BUT IT MIGHT ACT REALLY WEIRD **************************************
--************************************************************************************************************************************

-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------


local composer = require( "composer" )
local scene = composer.newScene()
local camera
-- include Corona's "physics" library
local physics = require "physics"

--------------------------------------------


-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX
local hero = {}

local function moveCamera()
	
	local leftOffset = 80
	local heroX = hero.x
	local heroY = hero.y
	local yOffset = 392.5
	local screenLeft = -camera.x
	local moveArea = 200
	
	if heroX > leftOffset then
		if heroX > screenLeft + moveArea then
		camera.x = -hero.x + moveArea
		elseif heroX < screenLeft + leftOffset then
		camera.x = -heroX + leftOffset
		end
	else
		camera.x = 0
	end
	
	if heroY > yOffset then 
		camera.y = heroY + yOffset
	elseif heroY < yOffset then 
		camera.y = -heroY + yOffset
	end
end

local function setHeroProperties ()
-- Hero Properties 
hero.speed = 70

end

local function setHeroVelocity ()
	heroHorizontalVelocity, heroVerticalVelocity = hero:getLinearVelocity()
	hero:setLinearVelocity ( hero.velocity, heroVerticalVelocity)
end

local function onKeyEvent ( event )
	
	if (event.keyName == "w" or event.keyName == "space" or event.keyName == "up") and heroVerticalVelocity == 0 then
		Runtime:addEventListener ("enterFrame", setHeroVelocity)
		hero:applyLinearImpulse (0,-20, hero.x, hero.y)
	elseif event.keyName == "a" or event.keyName == "left" then
		Runtime:addEventListener ("enterFrame", setHeroVelocity)
		hero.velocity = -70
		if (event.keyName == "a" or event.keyName == "left") and event.phase == "up" then
		hero.velocity = hero.velocity + 70
		Runtime:removeEventListener ("enterFrame", setHeroVelocity)
		end
	elseif event.keyName == "d" or event.keyName == "right" then
		Runtime:addEventListener ("enterFrame", setHeroVelocity)
		hero.velocity = 70
		if (event.keyName ~= "a" or event.keyName ~= "left") and event.phase == "up" then
		hero.velocity =  hero.velocity - 70
		Runtime:removeEventListener ("enterFrame", setHeroVelocity)
		end
	elseif 	(event.keyName == "s" or event.keyName == "down") and heroVerticalVelocity ~= 0 then
		Runtime:addEventListener ("enterFrame", setHeroVelocity)
		heroVerticalVelocity = -0.01
		hero:applyLinearImpulse (0,7.5, hero.x, hero.y)
		
	end
end


function scene:create( event )

	camera = display.newGroup()
	
	
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	physics.start()
	physics.pause()


	-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.
	local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0 
	background.anchorY = 0
	background:setFillColor( 0.5 )
	
	-- make a hero (off-screen), position it, and rotate slightly
	hero = display.newImageRect( "stealth_run_character.png", 80, 80 )
	hero.x, hero.y = 30, 358
	
	-- add physics to the hero
	physics.addBody( hero, { density=1.0, friction=0.3, bounce=0.0 } )
	hero.isFixedRotation = true
	
	
	local enemy = display.newImageRect( "Enemy.png", 50, 50 )
	enemy.x, enemy.y = 450, 372.5
	
	physics.addBody( enemy, { density=1.0, friction=0.3, bounce=0.3 } )
	enemy.isFixedRotation = true
	
	local HUD = display.newText("Score:" .. "    " .. "Time:", 20, 40, native.systemFont, 12 )
	HUD:setFillColor ( 0, 0, 0)

	----------------------------------------adding enemy move loop here
	local hello = true	
	----------------------------------------
	
	
	local wallLeft	= display.newImageRect( "BorderWall.png", 20, 3000 )
	wallLeft.x, wallLeft.y = -110, 3000
	wallLeft.anchorX = 0
	wallLeft.anchorY = 1
	
	physics.addBody( wallLeft, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	wallLeft.isFixedRotation = true
	
	local wallRight = display.newImageRect( "BorderWall.png", 20, 3000 )
	wallRight.x, wallRight.y = 730, 3000
	wallRight.anchorX = 0
	wallRight.anchorY = 1
	
	
	physics.addBody( wallRight, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	wallRight.isFixedRotation = true
	
	local roof = display.newImageRect( "BorderWall.png", 3000, 20 )
	roof.x, roof.y = -110, 20
	roof.anchorX = 0
	roof.anchorY = 1
	
	
	physics.addBody( roof, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	roof.isFixedRotation = true
	
	local step1 = display.newImageRect( "Step.png", 30, 30 )
	step1.x, step1.y = 200, 400
	step1.anchorX = 0
	step1.anchorY = 1
	
	physics.addBody( step1, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	step1.isFixedRotation = true
	
	local step2 = display.newImageRect( "Step.png", 30, 50 )
	step2.x, step2.y = 230, 400
	step2.anchorX = 0
	step2.anchorY = 1
	
	physics.addBody( step2, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	step2.isFixedRotation = true
	
	-- create a ground object and add physics (with custom shape)
	local ground = display.newImageRect( "floor.png", screenW-17, 82 )
	ground.anchorX = 0
	ground.anchorY = 1
	--  draw the ground at the very bottom of the screen
	ground.x, ground.y = display.screenOriginX, display.actualContentHeight + display.screenOriginY
	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	local groundShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	physics.addBody( ground, "static", { friction=0.3, shape=grassShape } )
	
	
	sceneGroup:insert( background )
	camera:insert( hero )
	camera:insert( wallLeft )
	camera:insert( wallRight )
	sceneGroup:insert ( camera )
	camera:insert( step1 )
	camera:insert( step2 )
	camera:insert( enemy )
	sceneGroup:insert( roof )
	camera:insert( ground )
	sceneGroup:insert( HUD )
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	Runtime:addEventListener("enterFrame", moveCamera)
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
Runtime:addEventListener( "key", onKeyEvent )
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene

*******************************************************************************************************************************************************************************************************
******************************************************************************************************************************************
******************************************************************************************************************************

-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local camera 
-- include Corona's "physics" library
local physics = require "physics"

--------------------------------------------


-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX
local hero = {}

local function moveCamera()
	
	local leftOffset = 100
	local heroX = hero.x
	local heroY = hero.y
	local yOffset = 200
	local screenLeft = -camera.x
	local moveArea = 200
	
	if heroX > leftOffset then
		if heroX > screenLeft + moveArea then
		camera.x = -hero.x + moveArea
		elseif heroX < screenLeft + leftOffset then
		camera.x = -heroX + leftOffset
		end
	else
		camera.x = 0
	end
	
	if heroY > yOffset then 
		camera.y = heroY + yOffset
	elseif heroY < yOffset then 
		camera.y = -heroY + yOffset
	end
end

local function setHeroProperties ()
-- Hero Properties 
hero.speed = 100

end

local function setHeroVelocity ()
	heroHorizontalVelocity, heroVerticalVelocity = hero:getLinearVelocity()
	hero:setLinearVelocity ( hero.velocity, heroVerticalVelocity)
end

local function onKeyEvent ( event )
	
	if(hasCollided) then
		print("true")
	else
		print("false")
	end
	
	local flip = 0
	
	if (event.keyName == "w" or event.keyName == "space" or event.keyName == "up") and heroVerticalVelocity == 0 then
		Runtime:addEventListener ("enterFrame", setHeroVelocity)
		hero:applyLinearImpulse (0,-50, hero.x, hero.y)
	elseif event.keyName == "a" or event.keyName == "left" then
		Runtime:addEventListener ("enterFrame", setHeroVelocity)
		hero.velocity = -70
		hero.xScale = -1
		if (event.keyName == "a" or event.keyName == "left") and event.phase == "up" then
		hero.velocity = hero.velocity + 70
		Runtime:removeEventListener ("enterFrame", setHeroVelocity)
		end
	elseif event.keyName == "d" or event.keyName == "right" then
		Runtime:addEventListener ("enterFrame", setHeroVelocity)
		hero.velocity = 70
		hero.xScale = 1
		if (event.keyName ~= "a" or event.keyName ~= "left") and event.phase == "up" then
		hero.velocity =  hero.velocity - 70
		Runtime:removeEventListener ("enterFrame", setHeroVelocity)
		end
	elseif 	(event.keyName == "s" or event.keyName == "down") and heroVerticalVelocity ~= 0 then
		Runtime:addEventListener ("enterFrame", setHeroVelocity)
		heroVerticalVelocity = -0.01
		hero:applyLinearImpulse (0,12, hero.x, hero.y)
		
	end
end

local function hasCollided()
	local dx = hero.x - ladder.x
    local dy = hero.y - ladder.y
 
    local distance = math.sqrt( dx*dx + dy*dy )
    local objectSize = (ladder.contentWidth/2) + (hero.contentWidth/2)
 
    if ( dx < 50 ) then
        return true
    end
    return false
end

local function gameLoop( event )
	
	Runtime:addEventListener( "enterFrame", hasCollided )
	
	if( hasCollided ) then
		if( event.keyName == "w" or event.keyName == "space" or event.keyName == "up" ) then 
			hero:applyLinearImpulse ( 0, -1000, hero.x, hero.y )
		end
	end
end


function scene:create( event )

	camera = display.newGroup()

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	physics.start()
	physics.pause()


	-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.
	local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0 
	background.anchorY = 0
	background:setFillColor( 1 )
	
	-- make a hero (off-screen), position it, and rotate slightly
	hero = display.newImageRect( "stealth_run_character.png", 80, 80 )
	hero.x, hero.y = 30, 197.5
	
	-- add physics to the hero
	physics.addBody( hero, { density=1.0, wfriction=0.3, bounce=0.0 } )
	hero.isFixedRotation = true
	
	
	local enemy = display.newImageRect( "Enemy.png", 50, 50 )
	enemy.x, enemy.y = 450, 212.5
	
	

	physics.addBody( enemy, { density=1.0, friction=0.3, bounce=0.3 } )
	enemy.isFixedRotation = true
	
	----------------------------------------adding enemy move loop here
	local hello = true	
	----------------------------------------
	
	
	local wallLeft	= display.newImageRect( "BorderWall.png", 20, 3000 )
	wallLeft.x, wallLeft.y = -50, 3000
	wallLeft.anchorX = 0
	wallLeft.anchorY = 1
	
	physics.addBody( wallLeft, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	wallLeft.isFixedRotation = true
	
	local wallRight = display.newImageRect( "BorderWall.png", 20, 150 )
	wallRight.x, wallRight.y = 510, 150
	wallRight.anchorX = 0
	wallRight.anchorY = 1
	
	
	physics.addBody( wallRight, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	wallRight.isFixedRotation = true
	
	local wallRight1 = display.newImageRect( "BorderWall.png", 20, 150 )
	wallRight1.x, wallRight1.y = 1020, 150
	wallRight1.anchorX = 0
	wallRight1.anchorY = 1
	
	
	physics.addBody( wallRight1, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	wallRight1.isFixedRotation = true
	
	local roof = display.newImageRect( "BorderWall.png", 3000, 20 )
	roof.x, roof.y = -50, 20
	roof.anchorX = 0
	roof.anchorY = 1
	
	
	physics.addBody( roof, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	roof.isFixedRotation = true
	
	local step1 = display.newImageRect( "Step.png", 30, 30 )
	step1.x, step1.y = 200, 238
	step1.anchorX = 0
	step1.anchorY = 1
	
	physics.addBody( step1, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	step1.isFixedRotation = true
	
	local step2 = display.newImageRect( "Step.png", 30, 50 )
	step2.x, step2.y = 230, 238
	step2.anchorX = 0
	step2.anchorY = 1
	
	physics.addBody( step2, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	step2.isFixedRotation = true
	
	ladder = display.newImageRect( "ladder.png", 50, 250 )
	ladder.x, ladder.y = 970, 238
	ladder.anchorX = 0
	ladder.anchorY = 1
	
	
	
	
	
	-- create a ground object and add physics (with custom shape)
	local ground = display.newImageRect( "floor.png", 3000, 82 )
	ground.anchorX = 0
	ground.anchorY = 1
	--  draw the ground at the very bottom of the screen
	ground.x, ground.y = display.screenOriginX, display.actualContentHeight + display.screenOriginY
	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	local groundShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	physics.addBody( ground, "static", { friction=0.3, shape=grassShape } )
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	camera:insert( roof )
	camera:insert( ladder )
	camera:insert( ground)
	camera:insert( hero )
	camera:insert( wallLeft )
	camera:insert( wallRight )
	camera:insert( wallRight1 )
	camera:insert( step1 )
	camera:insert( step2 )
	camera:insert( enemy )

	
	--sceneGroup:insert( controls )
	--sceneGroup:insert( btnJump )
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	Runtime:addEventListener("enterFrame", moveCamera)
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
Runtime:addEventListener( "enterFrame", gameLoop )
Runtime:addEventListener( "key", onKeyEvent )
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
--hero:addEventListener( "collision" )
--ladder:addEventListener( "collision" )
-----------------------------------------------------------------------------------------

return scene



*****************************************************************************************************
*****************************************************************************************************
*****************************************************************************************************
-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local camera 
local beamGroup = display.newGroup()

-- include Corona's "physics" library
local physics = require "physics"

--------------------------------------------
hasItem = 0 
-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX
local hero = {}

local function moveCamera()
	
	local leftOffset = 100
	local heroX = hero.x
	local heroY = hero.y
	local yOffset = 210
	local screenLeft = -camera.x
	local moveArea = 200
	
	if heroX > leftOffset then
		if heroX > screenLeft + moveArea then
		camera.x = -hero.x + moveArea
		elseif heroX < screenLeft + leftOffset then
		camera.x = -heroX + leftOffset
		end
	else
		camera.x = 0
	end
	
	if heroY > yOffset then 
		camera.y = heroY + yOffset
	elseif heroY < yOffset then 
		camera.y = -heroY + yOffset
	end
end

local function setHeroProperties ()
-- Hero Properties 
hero.speed = 70

end

local function setHeroVelocity ()
	heroHorizontalVelocity, heroVerticalVelocity = hero:getLinearVelocity()
	hero:setLinearVelocity ( hero.velocity, heroVerticalVelocity)
end

local function onKeyEvent ( event )
	
	if (event.keyName == "w" or event.keyName == "space" or event.keyName == "up") and heroVerticalVelocity == 0 then
		if(math.abs(hero.x - ladder.x) < 35 and math.abs(hero.y - ladder.y) < 50) then
			Runtime:addEventListener ("enterFrame", setHeroVelocity)
			hero:applyLinearImpulse (0,-30, hero.x, hero.y)
		else
			Runtime:addEventListener ("enterFrame", setHeroVelocity)
			hero:applyLinearImpulse (0,-10, hero.x, hero.y)
		end
	elseif event.keyName == "a" or event.keyName == "left" then
		Runtime:addEventListener ("enterFrame", setHeroVelocity)
		hero.velocity = -70
		hero.xScale = -1
		if (event.keyName == "a" or event.keyName == "left") and event.phase == "up" then
		hero.velocity = hero.velocity + 70
		Runtime:removeEventListener ("enterFrame", setHeroVelocity)
		end
	elseif event.keyName == "d" or event.keyName == "right" then
		Runtime:addEventListener ("enterFrame", setHeroVelocity)
		hero.velocity = 70
		hero.xScale = 1
		if (event.keyName ~= "a" or event.keyName ~= "left") and event.phase == "up" then
		hero.velocity =  hero.velocity - 70
		Runtime:removeEventListener ("enterFrame", setHeroVelocity)
		end
	elseif 	(event.keyName == "s" or event.keyName == "down") and heroVerticalVelocity ~= 0 then
		Runtime:addEventListener ("enterFrame", setHeroVelocity)
		heroVerticalVelocity = -0.01
		hero:applyLinearImpulse (0,12, hero.x, hero.y)
	elseif (event.keyName == "e" and (math.abs(hero.x - painting.x) < 35 and math.abs(hero.y - painting.y) < 50)) then
		hasItem = 1
		painting.y = 5438345439345
	elseif (event.keyName == "e" and (math.abs(hero.x - finishPoint.x) < 35 and math.abs(hero.y - finishPoint.y) < 50) and hasItem == 1) then
		hasItem = 2
	end
end


	local Path = {}
	Path[1] = { x=-50, y=0}
	Path[2] = { x=50, y=0 }
	Path[3] = { x=-50, y=0}
	Path[4] = { x=50, y=0 }
	Path[5] = { x=-50, y=0}
	Path[6] = { x=50, y=0 }
	Path[7] = { x=-50, y=0}
	Path[8] = { x=50, y=0 }
	Path[9] = { x=-50, y=0}
	Path[10] = { x=50, y=0 }
	Path[11] = { x=-50, y=0}
	Path[12] = { x=50, y=0 }
	Path[13] = { x=-50, y=0}
	Path[14] = { x=50, y=0 }
	Path[15] = { x=-50, y=0}
	Path[16] = { x=50, y=0 }
	Path[17] = { x=-50, y=0}
	Path[18] = { x=50, y=0 }
	Path[19] = { x=-50, y=0}
	Path[20] = { x=50, y=0 }
	
	local function distBetween( x1, y1, x2, y2 )
		local xFactor = x2 - x1
		local yFactor = y2 - y1
		local dist = math.sqrt( (xFactor*xFactor) + (yFactor*yFactor) )
		return dist
	end

	local function setPath( enemy, Path, params )
		
		local delta = params.useDelta or nil
		local deltaX = 0
		local deltaY = 0
		local constant = params.constantTime or nil
		local ease = params.easingMethod or easing.linear
		local tag = params.tag or nil
		local delay = params.delay or 0
        local speedFactor = 1
		

		if ( delta ) then
			deltaX = enemy.x
			deltaY = enemy.y
		end	
		
		if ( constant ) then
			local dist = distBetween( enemy.x, enemy.y, deltaX+Path[1].x, deltaY+Path[1].y)
			speedFactor = constant/dist
		end	
		
		for i = 1,#Path do
			enemy.xScale = -enemy.xScale
			local segmentTime = 500
			
			if ( constant ) then
				local dist
				if( i==1 ) then
					dist = distBetween(  enemy.x, enemy.y, deltaX+Path[i].x, deltaY+Path[i].y )
			else
				dist = distBetween( Path[i-1].x, Path[i-1].y, Path[i].x, Path[i].y )
			end
			segmentTime = dist*speedFactor
			else
				if ( path[i].time ) then segmentTime = path[i].time end
		end
		
		 if ( Path[i].easingMethod ) then ease = Path[i].easingMethod end
		 
		 
		 
		transition.to( enemy, { tag=tag, time=segmentTime, x=deltaX+Path[i].x, y=deltaY+Path[i].y, delay=delay, transition=ease } )
      delay = delay + segmentTime
	  
	  
   end 
end

local function resetBeams()

	-- Clear all beams/bursts from display
	for i = beamGroup.numChildren,1,-1 do
		local child = beamGroup[i]
		display.remove( child )
		child = nil
	end

	-- Reset beam group alpha
	beamGroup.alpha = 1

	-- Restart turret rotating after firing is finished
	turret.angularVelocity = turretSpeed
end
	
local function drawBeam( startX, startY, endX, endY )

	-- Draw a series of overlapping lines to represent the beam
	local beam1 = display.newLine( beamGroup, startX, startY, endX, endY )
	beam1.strokeWidth = 2 ; beam1:setStrokeColor( 1, 0.312, 0.157, 1 ) ; beam1.blendMode = "add" ; beam1:toBack()
	local beam2 = display.newLine( beamGroup, startX, startY, endX, endY )
	beam2.strokeWidth = 4 ; beam2:setStrokeColor( 1, 0.312, 0.157, 0.706 ) ; beam2.blendMode = "add" ; beam2:toBack()
	local beam3 = display.newLine( beamGroup, startX, startY, endX, endY )
	beam3.strokeWidth = 6 ; beam3:setStrokeColor( 1, 0.196, 0.157, 0.392 ) ; beam3.blendMode = "add" ; beam3:toBack()
end

	
local function castRay( startX, startY, endX, endY )

	-- Perform ray cast
	local hits = physics.rayCast( startX, startY, endX, endY, "closest" )

	-- There is a hit; calculate the entire ray sequence (initial ray and reflections)
	if ( hits and beamGroup.numChildren <= maxBeams ) then

		-- Store first hit to variable (just the "closest" hit was requested, so use 'hits[1]')
		local hitFirst = hits[1]

		-- Store the hit X and Y position to local variables
		local hitX, hitY = hitFirst.position.x, hitFirst.position.y
	
		-- Draw the next beam
		drawBeam( startX, startY, hitX, hitY )

		-- Check for and calculate the reflected ray
		local reflectX, reflectY = physics.reflectRay( startX, startY, hitFirst )
		
		
		 for i = 1,#hits do
			if(object == hero) then
				for i = 1,#Path do
					Path[i] = {x = hero.x}
				end
			end
			timer.performWithDelay( 40, function() castRay( hitX, hitY, reflectEndX, reflectEndY ); end )
		end
		
		
	-- Else, ray casting sequence is complete
	else

		-- Draw the final beam
		drawBeam( startX, startY, endX, endY )

		-- Fade out entire beam group after a short delay
		transition.to( beamGroup, { time=800, delay=400, alpha=0, onComplete=resetBeams } )
	end
end
	
local function fireOnTimer( event )

	-- Ensure that all previous beams/bursts are cleared/complete before firing
	if ( beamGroup.numChildren == 0 ) then

		-- Calculate ending x/y of beam
		local xDest = turret.x - (math.cos(math.rad(turret.rotation+90)) * 1600 )
		local yDest = turret.y - (math.sin(math.rad(turret.rotation+90)) * 1600 )

		-- Cast the initial ray
		castRay( turret.x, turret.y, xDest, yDest )
	end
end	

function scene:create( event )

	camera = display.newGroup()
	
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	physics.start()
	physics.pause()


	-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.
	local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0 
	background.anchorY = 0
	background:setFillColor( 1 )
		
	-- make a hero (off-screen), position it, and rotate slightly
	hero = display.newImageRect( "stealth_run_character.png", 20, 60 )
	hero.x, hero.y = 30, 207
	
	-- add physics to the hero
	physics.addBody( hero, { density=1.0, wfriction=0.3, bounce=0.0 } )
	hero.isFixedRotation = true
	
	
	
	enemy = display.newImageRect( "Enemy.png", 40, 50 )
	enemy.x, enemy.y = 450, 212.5
	enemy.xScale = -1
	physics.addBody( enemy, { density=1.0, friction=0.3, bounce=0.3 } )
	enemy.isFixedRotation = true
	
	
	timer.performWithDelay(5000, setPath( enemy, Path, { useDelta=true, constantTime=500, easingMethod=easing.inOutQuad, delay=200, tag="moveObject" } ), -1 )
	
	
	----------------------------------------adding enemy move loop here
	local hello = true	
	----------------------------------------
	
	painting = display.newImageRect( "Perhaps Modern Art.png", 80, 80 )
	painting.x, painting.y = 30, -90
	
		
	local counter = 0
	
	local HUD = display.newText("Score:" .. "    " .. "Time:", 20, 40, native.systemFont, 12 )
	HUD:setFillColor ( 0, 1, 0)
	
	local HUDtime = display.newText("Time: " .. counter, 20, 60, native.systemFont, 12 )
	HUDtime:setFillColor ( 0, 1, 0)
 
    	local function updateTimer(event)
            counter = counter + 1
            HUDtime.text = "Time: " .. counter .. " secs"
    	end
	
	timer.performWithDelay(1000, updateTimer, 6000)
	
	local controls = display.newText("Use WASD or the arrow keys to move around!", display.contentCenterX - 120, display.contentCenterY - 60, native.systemFont, 12 )
	controls:setFillColor ( 0, 0, 0)
	
	local enemyWarning = display.newText("But be careful not to be spotted by enemies", display.contentCenterX + 20, display.contentCenterY, native.systemFont, 12 )
	enemyWarning:setFillColor ( 0, 0, 0)
	
	finishPoint = display.newRect(5, 224, 30, 30)
	finishPoint:setFillColor ( 0, 1, 0 )
	
	local wallLeft	= display.newImageRect( "BorderWall.png", 20, 480 )
	wallLeft.x, wallLeft.y = -50, 238
	wallLeft.anchorX = 0
	wallLeft.anchorY = 1
	
	physics.addBody( wallLeft, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	wallLeft.isFixedRotation = true
	
	
	local wallRight = display.newImageRect( "BorderWall.png", 20, 150 )
	wallRight.x, wallRight.y = 510, 150
	wallRight.anchorX = 0
	wallRight.anchorY = 1
	
	
	physics.addBody( wallRight, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	wallRight.isFixedRotation = true
	
	local wallRight1 = display.newImageRect( "BorderWall.png", 20, 475 )
	wallRight1.x, wallRight1.y = 1020, 238
	wallRight1.anchorX = 0
	wallRight1.anchorY = 1
	
	
	physics.addBody( wallRight1, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	wallRight1.isFixedRotation = true

	local wallRight2 = display.newImageRect( "BorderWall.png", 20, 165 )
	wallRight2.x, wallRight2.y = 510, -90
	wallRight2.anchorX = 0
	wallRight2.anchorY = 1
	
	
	physics.addBody( wallRight2, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	wallRight2.isFixedRotation = true
	
	local roof = display.newImageRect( "BorderWall.png", 975, 20 )
	roof.x, roof.y = -50, 20
	roof.anchorX = 0
	roof.anchorY = 1
	
	
	physics.addBody( roof, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	roof.isFixedRotation = true
	
	local roof1 = display.newImageRect( "BorderWall.png", 1090, 20 )
	roof1.x, roof1.y = -50, -237
	roof1.anchorX = 0
	roof1.anchorY = 1
	
	
	physics.addBody( roof1, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	roof1.isFixedRotation = true
	
	local step1 = display.newImageRect( "Step.png", 30, 30 )
	step1.x, step1.y = 200, 238
	step1.anchorX = 0
	step1.anchorY = 1
	
	physics.addBody( step1, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	step1.isFixedRotation = true
	
	local step2 = display.newImageRect( "Step.png", 30, 50 )
	step2.x, step2.y = 230, 238
	step2.anchorX = 0
	step2.anchorY = 1
	
	physics.addBody( step2, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	step2.isFixedRotation = true
	
	ladder = display.newImageRect( "ladder.png", 50, 250 )
	ladder.x, ladder.y = 970, 238
	ladder.anchorX = 0
	ladder.anchorY = 1
	
	-- create a ground object and add physics (with custom shape)
	local ground = display.newImageRect( "floor.png", 3000, 82 )
	ground.anchorX = 0
	ground.anchorY = 1
	--  draw the ground at the very bottom of the screen
	ground.x, ground.y = display.screenOriginX, display.actualContentHeight + display.screenOriginY
	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	local groundShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	physics.addBody( ground, "static", { friction=0.3, shape=grassShape } )
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	camera:insert( controls )
	camera:insert( enemyWarning )
	camera:insert( roof )
	camera:insert( roof1 )
	camera:insert( ladder )
	camera:insert( ground)
	camera:insert( painting )
	camera:insert( finishPoint )
	camera:insert( hero )
	camera:insert( wallLeft )
	camera:insert( wallRight )
	camera:insert( wallRight1 )
	camera:insert( wallRight2 )
	camera:insert( step1 )
	camera:insert( step2 )
	camera:insert( enemy )
	sceneGroup:insert( HUD )
	sceneGroup:insert( HUDtime )

end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	Runtime:addEventListener("enterFrame", moveCamera)
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
Runtime:addEventListener( "key", onKeyEvent )
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-----------------------------------------------------------------------------------------

return scene


*********************************************************************************************
JOHN PUT IN SOUNDS
*******************************************************************************
-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local camera 
local beamGroup = display.newGroup()

-- include Corona's "physics" library
local physics = require "physics"

--------sound---------------------------
--put this table in menu.lua as well, below composer.newScene-------------------

local soundTable = {

	GadgetSound = audio.loadSound( "betaGadgetsound.wav" ),
	DeathSound = audio.loadSound( "deathsound1.wav" ),
	FootstepSound = audio.loadSound( "footstep.wav" ),
	hitSound = audio.loadSound( "hitsound2.wav" ),
	jumpSound = audio.loadSound( "jump.wav" ),
	ladderSound = audio.loadSound( "ladder.wav" ),
	menuSound = audio.loadSound( "menusound.wav" ), 
	transitionSound = audio.loadSound( "transitionsound.wav" ),
	victorySound = audio.loadSound( "victorysound3.wav" )
	}

--------------------------------------------
hasItem = 0 
-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX
local hero = {}

local function moveCamera()
	
	local leftOffset = 100
	local heroX = hero.x
	local heroY = hero.y
	local yOffset = 210
	local screenLeft = -camera.x
	local moveArea = 200
	
	if heroX > leftOffset then
		if heroX > screenLeft + moveArea then
		camera.x = -hero.x + moveArea
		elseif heroX < screenLeft + leftOffset then
		camera.x = -heroX + leftOffset
		end
	else
		camera.x = 0
	end
	
	if heroY > yOffset then 
		camera.y = heroY + yOffset
	elseif heroY < yOffset then 
		camera.y = -heroY + yOffset
	end
end

local function setHeroProperties ()
-- Hero Properties 
hero.speed = 70

end

local function setHeroVelocity ()
	heroHorizontalVelocity, heroVerticalVelocity = hero:getLinearVelocity()
	hero:setLinearVelocity ( hero.velocity, heroVerticalVelocity)
end

local function onKeyEvent ( event )
	
	if (event.keyName == "w" or event.keyName == "space" or event.keyName == "up") and heroVerticalVelocity == 0 then
		if(math.abs(hero.x - ladder.x) < 35 and math.abs(hero.y - ladder.y) < 50) then
			Runtime:addEventListener ("enterFrame", setHeroVelocity)
			audio.play (soundTable["ladderSound"] )
			hero:applyLinearImpulse (0,-30, hero.x, hero.y)
		else
			Runtime:addEventListener ("enterFrame", setHeroVelocity)
			audio.play (soundTable["jumpSound"] )
			hero:applyLinearImpulse (0,-10, hero.x, hero.y)
		end
	elseif event.keyName == "a" or event.keyName == "left" then
		Runtime:addEventListener ("enterFrame", setHeroVelocity)
		hero.velocity = -70
		hero.xScale = -1
			if	heroVerticalVelocity == 0 then
				audio.play (soundTable["FootstepSound"] )
			end	
		if (event.keyName == "a" or event.keyName == "left") and event.phase == "up" then
		hero.velocity = hero.velocity + 70
		Runtime:removeEventListener ("enterFrame", setHeroVelocity)
		end
	elseif event.keyName == "d" or event.keyName == "right" then
		Runtime:addEventListener ("enterFrame", setHeroVelocity)
		hero.velocity = 70
		hero.xScale = 1
			if heroVerticalVelocity ==0 then
				audio.play (soundTable["FootstepSound"] )
			end	
		if (event.keyName ~= "a" or event.keyName ~= "left") and event.phase == "up" then
		hero.velocity =  hero.velocity - 70
		Runtime:removeEventListener ("enterFrame", setHeroVelocity)
		end
	elseif 	(event.keyName == "s" or event.keyName == "down") and heroVerticalVelocity ~= 0 then
		Runtime:addEventListener ("enterFrame", setHeroVelocity)
		heroVerticalVelocity = -0.01
		hero:applyLinearImpulse (0,12, hero.x, hero.y)
	elseif (event.keyName == "e" and (math.abs(hero.x - painting.x) < 35 and math.abs(hero.y - painting.y) < 50)) then
		hasItem = 1
		painting.y = 5438345439345
	elseif (event.keyName == "e" and (math.abs(hero.x - finishPoint.x) < 35 and math.abs(hero.y - finishPoint.y) < 50) and hasItem == 1) then
		hasItem = 2
	end
end


	local Path = {}
	Path[1] = { x=-50, y=0}
	Path[2] = { x=50, y=0 }
	Path[3] = { x=-50, y=0}
	Path[4] = { x=50, y=0 }
	Path[5] = { x=-50, y=0}
	Path[6] = { x=50, y=0 }
	Path[7] = { x=-50, y=0}
	Path[8] = { x=50, y=0 }
	Path[9] = { x=-50, y=0}
	Path[10] = { x=50, y=0 }
	Path[11] = { x=-50, y=0}
	Path[12] = { x=50, y=0 }
	Path[13] = { x=-50, y=0}
	Path[14] = { x=50, y=0 }
	Path[15] = { x=-50, y=0}
	Path[16] = { x=50, y=0 }
	Path[17] = { x=-50, y=0}
	Path[18] = { x=50, y=0 }
	Path[19] = { x=-50, y=0}
	Path[20] = { x=50, y=0 }
	
	local function distBetween( x1, y1, x2, y2 )
		local xFactor = x2 - x1
		local yFactor = y2 - y1
		local dist = math.sqrt( (xFactor*xFactor) + (yFactor*yFactor) )
		return dist
	end

	local function setPath( enemy, Path, params )
		
		local delta = params.useDelta or nil
		local deltaX = 0
		local deltaY = 0
		local constant = params.constantTime or nil
		local ease = params.easingMethod or easing.linear
		local tag = params.tag or nil
		local delay = params.delay or 0
        local speedFactor = 1
		

		if ( delta ) then
			deltaX = enemy.x
			deltaY = enemy.y
		end	
		
		if ( constant ) then
			local dist = distBetween( enemy.x, enemy.y, deltaX+Path[1].x, deltaY+Path[1].y)
			speedFactor = constant/dist
		end	
		
		for i = 1,#Path do
			enemy.xScale = -enemy.xScale
			local segmentTime = 500
			
			if ( constant ) then
				local dist
				if( i==1 ) then
					dist = distBetween(  enemy.x, enemy.y, deltaX+Path[i].x, deltaY+Path[i].y )
			else
				dist = distBetween( Path[i-1].x, Path[i-1].y, Path[i].x, Path[i].y )
			end
			segmentTime = dist*speedFactor
			else
				if ( path[i].time ) then segmentTime = path[i].time end
		end
		
		 if ( Path[i].easingMethod ) then ease = Path[i].easingMethod end
		 
		 
		 
		transition.to( enemy, { tag=tag, time=segmentTime, x=deltaX+Path[i].x, y=deltaY+Path[i].y, delay=delay, transition=ease } )
      delay = delay + segmentTime
	  
	  
   end 
end

local function resetBeams()

	-- Clear all beams/bursts from display
	for i = beamGroup.numChildren,1,-1 do
		local child = beamGroup[i]
		display.remove( child )
		child = nil
	end

	-- Reset beam group alpha
	beamGroup.alpha = 1

	-- Restart turret rotating after firing is finished
	turret.angularVelocity = turretSpeed
end
	
local function drawBeam( startX, startY, endX, endY )

	-- Draw a series of overlapping lines to represent the beam
	local beam1 = display.newLine( beamGroup, startX, startY, endX, endY )
	beam1.strokeWidth = 2 ; beam1:setStrokeColor( 1, 0.312, 0.157, 1 ) ; beam1.blendMode = "add" ; beam1:toBack()
	local beam2 = display.newLine( beamGroup, startX, startY, endX, endY )
	beam2.strokeWidth = 4 ; beam2:setStrokeColor( 1, 0.312, 0.157, 0.706 ) ; beam2.blendMode = "add" ; beam2:toBack()
	local beam3 = display.newLine( beamGroup, startX, startY, endX, endY )
	beam3.strokeWidth = 6 ; beam3:setStrokeColor( 1, 0.196, 0.157, 0.392 ) ; beam3.blendMode = "add" ; beam3:toBack()
end

	
local function castRay( startX, startY, endX, endY )

	-- Perform ray cast
	local hits = physics.rayCast( startX, startY, endX, endY, "closest" )

	-- There is a hit; calculate the entire ray sequence (initial ray and reflections)
	if ( hits and beamGroup.numChildren <= maxBeams ) then

		-- Store first hit to variable (just the "closest" hit was requested, so use 'hits[1]')
		local hitFirst = hits[1]

		-- Store the hit X and Y position to local variables
		local hitX, hitY = hitFirst.position.x, hitFirst.position.y
	
		-- Draw the next beam
		drawBeam( startX, startY, hitX, hitY )

		-- Check for and calculate the reflected ray
		local reflectX, reflectY = physics.reflectRay( startX, startY, hitFirst )
		
		
		 for i = 1,#hits do
			if(object == hero) then
				for i = 1,#Path do
					Path[i] = {x = hero.x}
				end
			end
			timer.performWithDelay( 40, function() castRay( hitX, hitY, reflectEndX, reflectEndY ); end )
		end
		
		
	-- Else, ray casting sequence is complete
	else

		-- Draw the final beam
		drawBeam( startX, startY, endX, endY )

		-- Fade out entire beam group after a short delay
		transition.to( beamGroup, { time=800, delay=400, alpha=0, onComplete=resetBeams } )
	end
end
	
local function fireOnTimer( event )

	-- Ensure that all previous beams/bursts are cleared/complete before firing
	if ( beamGroup.numChildren == 0 ) then

		-- Calculate ending x/y of beam
		local xDest = turret.x - (math.cos(math.rad(turret.rotation+90)) * 1600 )
		local yDest = turret.y - (math.sin(math.rad(turret.rotation+90)) * 1600 )

		-- Cast the initial ray
		castRay( turret.x, turret.y, xDest, yDest )
	end
end	

function scene:create( event )

	camera = display.newGroup()
	
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	physics.start()
	physics.pause()


	-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.
	local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0 
	background.anchorY = 0
	background:setFillColor( 1 )
		
	-- make a hero (off-screen), position it, and rotate slightly
	hero = display.newImageRect( "stealth_run_character.png", 20, 60 )
	hero.x, hero.y = 30, 207
	
	-- add physics to the hero
	physics.addBody( hero, { density=1.0, wfriction=0.3, bounce=0.0 } )
	hero.isFixedRotation = true
	
	
	
	enemy = display.newImageRect( "Enemy.png", 40, 50 )
	enemy.x, enemy.y = 450, 212.5
	enemy.xScale = -1
	physics.addBody( enemy, { density=1.0, friction=0.3, bounce=0.3 } )
	enemy.isFixedRotation = true
	
	
	timer.performWithDelay(5000, setPath( enemy, Path, { useDelta=true, constantTime=500, easingMethod=easing.inOutQuad, delay=200, tag="moveObject" } ), -1 )
	
	
	----------------------------------------adding enemy move loop here
	local hello = true	
	----------------------------------------
	
	painting = display.newImageRect( "Perhaps Modern Art.png", 80, 80 )
	painting.x, painting.y = 30, -90
	
		
	local counter = 0
	
	local HUD = display.newText("Score:" .. "    " .. "Time:", 20, 40, native.systemFont, 12 )
	HUD:setFillColor ( 0, 1, 0)
	
	local HUDtime = display.newText("Time: " .. counter, 20, 60, native.systemFont, 12 )
	HUDtime:setFillColor ( 0, 1, 0)
 
    	local function updateTimer(event)
            counter = counter + 1
            HUDtime.text = "Time: " .. counter .. " secs"
    	end
	
	timer.performWithDelay(1000, updateTimer, 6000)
	
	local controls = display.newText("Use WASD or the arrow keys to move around!", display.contentCenterX - 120, display.contentCenterY - 60, native.systemFont, 12 )
	controls:setFillColor ( 0, 0, 0)
	
	local enemyWarning = display.newText("But be careful not to be spotted by enemies", display.contentCenterX + 20, display.contentCenterY, native.systemFont, 12 )
	enemyWarning:setFillColor ( 0, 0, 0)
	
	finishPoint = display.newRect(5, 224, 30, 30)
	finishPoint:setFillColor ( 0, 1, 0 )
	
	local wallLeft	= display.newImageRect( "BorderWall.png", 20, 480 )
	wallLeft.x, wallLeft.y = -50, 238
	wallLeft.anchorX = 0
	wallLeft.anchorY = 1
	
	physics.addBody( wallLeft, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	wallLeft.isFixedRotation = true
	
	
	local wallRight = display.newImageRect( "BorderWall.png", 20, 150 )
	wallRight.x, wallRight.y = 510, 150
	wallRight.anchorX = 0
	wallRight.anchorY = 1
	
	
	physics.addBody( wallRight, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	wallRight.isFixedRotation = true
	
	local wallRight1 = display.newImageRect( "BorderWall.png", 20, 475 )
	wallRight1.x, wallRight1.y = 1020, 238
	wallRight1.anchorX = 0
	wallRight1.anchorY = 1
	
	
	physics.addBody( wallRight1, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	wallRight1.isFixedRotation = true

	local wallRight2 = display.newImageRect( "BorderWall.png", 20, 165 )
	wallRight2.x, wallRight2.y = 510, -90
	wallRight2.anchorX = 0
	wallRight2.anchorY = 1
	
	
	physics.addBody( wallRight2, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	wallRight2.isFixedRotation = true
	
	local roof = display.newImageRect( "BorderWall.png", 975, 20 )
	roof.x, roof.y = -50, 20
	roof.anchorX = 0
	roof.anchorY = 1
	
	
	physics.addBody( roof, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	roof.isFixedRotation = true
	
	local roof1 = display.newImageRect( "BorderWall.png", 1090, 20 )
	roof1.x, roof1.y = -50, -237
	roof1.anchorX = 0
	roof1.anchorY = 1
	
	
	physics.addBody( roof1, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	roof1.isFixedRotation = true
	
	local step1 = display.newImageRect( "Step.png", 30, 30 )
	step1.x, step1.y = 200, 238
	step1.anchorX = 0
	step1.anchorY = 1
	
	physics.addBody( step1, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	step1.isFixedRotation = true
	
	local step2 = display.newImageRect( "Step.png", 30, 50 )
	step2.x, step2.y = 230, 238
	step2.anchorX = 0
	step2.anchorY = 1
	
	physics.addBody( step2, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	step2.isFixedRotation = true
	
	ladder = display.newImageRect( "ladder.png", 50, 250 )
	ladder.x, ladder.y = 970, 238
	ladder.anchorX = 0
	ladder.anchorY = 1
	
	-- create a ground object and add physics (with custom shape)
	local ground = display.newImageRect( "floor.png", 3000, 82 )
	ground.anchorX = 0
	ground.anchorY = 1
	--  draw the ground at the very bottom of the screen
	ground.x, ground.y = display.screenOriginX, display.actualContentHeight + display.screenOriginY
	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	local groundShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	physics.addBody( ground, "static", { friction=0.3, shape=grassShape } )
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	camera:insert( controls )
	camera:insert( enemyWarning )
	camera:insert( roof )
	camera:insert( roof1 )
	camera:insert( ladder )
	camera:insert( ground)
	camera:insert( painting )
	camera:insert( finishPoint )
	camera:insert( hero )
	camera:insert( wallLeft )
	camera:insert( wallRight )	camera:insert( wallRight1 )
	camera:insert( wallRight2 )
	camera:insert( step1 )
	camera:insert( step2 )
	camera:insert( enemy )
	sceneGroup:insert( HUD )
	sceneGroup:insert( HUDtime )

end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	Runtime:addEventListener("enterFrame", moveCamera)
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then

		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
Runtime:addEventListener( "key", onKeyEvent )
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-----------------------------------------------------------------------------------------

return scene

***************************************************************************************************************
***************************************************************************************************************
***************************************************************************************************************
-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local camera 
local beamGroup = display.newGroup()

-- include Corona's "physics" library
local physics = require "physics"

--------sound---------------------------
--put this table in menu.lua as well, below composer.newScene-------------------

local soundTable = {

	GadgetSound = audio.loadSound( "betaGadgetsound.wav" ),
	DeathSound = audio.loadSound( "deathsound1.wav" ),
	FootstepSound = audio.loadSound( "footstep.wav" ),
	hitSound = audio.loadSound( "hitsound2.wav" ),
	jumpSound = audio.loadSound( "jump.wav" ),
	ladderSound = audio.loadSound( "ladder.wav" ),
	menuSound = audio.loadSound( "menusound.wav" ), 
	transitionSound = audio.loadSound( "transitionsound.wav" ),
	victorySound = audio.loadSound( "victorysound3.wav" )
	}

--------------------------------------------
hasItem = 0 
-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX
local hero = {}

local function moveCamera()
	
	local leftOffset = 100
	local heroX = hero.x
	local heroY = hero.y
	local yOffset = 210
	local screenLeft = -camera.x
	local moveArea = 200
	
	if heroX > leftOffset then
		if heroX > screenLeft + moveArea then
		camera.x = -hero.x + moveArea
		elseif heroX < screenLeft + leftOffset then
		camera.x = -heroX + leftOffset
		end
	else
		camera.x = 0
	end
	
	if heroY > yOffset then 
		camera.y = heroY + yOffset
	elseif heroY < yOffset then 
		camera.y = -heroY + yOffset
	end
end

local function setHeroProperties ()
-- Hero Properties 
hero.speed = 70

end

local function setHeroVelocity ()
	heroHorizontalVelocity, heroVerticalVelocity = hero:getLinearVelocity()
	hero:setLinearVelocity ( hero.velocity, heroVerticalVelocity)
end

local function onKeyEvent ( event )
	
	if (event.keyName == "w" or event.keyName == "space" or event.keyName == "up") and heroVerticalVelocity == 0 then
		if(math.abs(hero.x - ladder.x) < 35 and math.abs(hero.y - ladder.y) < 50) then
			Runtime:addEventListener ("enterFrame", setHeroVelocity)
			audio.play (soundTable["ladderSound"] )
			hero:applyLinearImpulse (0,-30, hero.x, hero.y)
		else
			Runtime:addEventListener ("enterFrame", setHeroVelocity)
			audio.play (soundTable["jumpSound"] )
			hero:applyLinearImpulse (0,-10, hero.x, hero.y)
		end
	elseif event.keyName == "a" or event.keyName == "left" then
		Runtime:addEventListener ("enterFrame", setHeroVelocity)
		hero.velocity = -70
		hero.xScale = -1
		direction = -1
			if	heroVerticalVelocity == 0 then
				audio.play (soundTable["FootstepSound"] )
			end	
		if (event.keyName == "a" or event.keyName == "left") and event.phase == "up" then
		hero.velocity = hero.velocity + 70
		Runtime:removeEventListener ("enterFrame", setHeroVelocity)
		end
	elseif event.keyName == "d" or event.keyName == "right" then
		Runtime:addEventListener ("enterFrame", setHeroVelocity)
		hero.velocity = 70
		hero.xScale = 1
		direction = 1
			if heroVerticalVelocity ==0 then
				audio.play (soundTable["FootstepSound"] )
			end	
		if (event.keyName ~= "a" or event.keyName ~= "left") and event.phase == "up" then
		hero.velocity =  hero.velocity - 70
		Runtime:removeEventListener ("enterFrame", setHeroVelocity)
		end
	elseif 	(event.keyName == "s" or event.keyName == "down") and heroVerticalVelocity ~= 0 then
		Runtime:addEventListener ("enterFrame", setHeroVelocity)
		heroVerticalVelocity = -0.01
		hero:applyLinearImpulse (0,12, hero.x, hero.y)
	elseif  (event.keyName == "f") and event.phase == "up" then 
		local projectile = display.newRect(hero.x, hero.y, 5, 5 )
		enemy.collision = enemyCollision
		enemy:addEventListener("collision", enemy)
		projectile:setFillColor(1, 0, 0)
        physics.addBody( projectile, 'dynamic' )
       	projectile.gravityScale = 1
       	projectile:setLinearVelocity( (direction * 500), 0 )
	elseif (event.keyName == "e" and (math.abs(hero.x - painting.x) < 35 and math.abs(hero.y - painting.y) < 50)) then
		hasItem = 1
		painting.y = 5438345439345
	elseif (event.keyName == "e" and (math.abs(hero.x - finishPoint.x) < 35 and math.abs(hero.y - finishPoint.y) < 50) and hasItem == 1) then
		hasItem = 2
	end
end


	local Path = {}
	Path[1] = { x=-50, y=0}
	Path[2] = { x=50, y=0 }
	Path[3] = { x=-50, y=0}
	Path[4] = { x=50, y=0 }
	Path[5] = { x=-50, y=0}
	Path[6] = { x=50, y=0 }
	Path[7] = { x=-50, y=0}
	Path[8] = { x=50, y=0 }
	Path[9] = { x=-50, y=0}
	Path[10] = { x=50, y=0 }
	Path[11] = { x=-50, y=0}
	Path[12] = { x=50, y=0 }
	Path[13] = { x=-50, y=0}
	Path[14] = { x=50, y=0 }
	Path[15] = { x=-50, y=0}
	Path[16] = { x=50, y=0 }
	Path[17] = { x=-50, y=0}
	Path[18] = { x=50, y=0 }
	Path[19] = { x=-50, y=0}
	Path[20] = { x=50, y=0 }
	
	local function distBetween( x1, y1, x2, y2 )
		local xFactor = x2 - x1
		local yFactor = y2 - y1
		local dist = math.sqrt( (xFactor*xFactor) + (yFactor*yFactor) )
		return dist
	end

	local function setPath( enemy, Path, params )
		
		local delta = params.useDelta or nil
		local deltaX = 0
		local deltaY = 0
		local constant = params.constantTime or nil
		local ease = params.easingMethod or easing.linear
		local tag = params.tag or nil
		local delay = params.delay or 0
        local speedFactor = 1
		

		if ( delta ) then
			deltaX = enemy.x
			deltaY = enemy.y
		end	
		
		if ( constant ) then
			local dist = distBetween( enemy.x, enemy.y, deltaX+Path[1].x, deltaY+Path[1].y)
			speedFactor = constant/dist
		end	
		
		for i = 1,#Path do
			enemy.xScale = -enemy.xScale
			local segmentTime = 500
			
			if ( constant ) then
				local dist
				if( i==1 ) then
					dist = distBetween(  enemy.x, enemy.y, deltaX+Path[i].x, deltaY+Path[i].y )
			else
				dist = distBetween( Path[i-1].x, Path[i-1].y, Path[i].x, Path[i].y )
			end
			segmentTime = dist*speedFactor
			else
				if ( path[i].time ) then segmentTime = path[i].time end
		end
		
		 if ( Path[i].easingMethod ) then ease = Path[i].easingMethod end
		 
		 
		 
		transition.to( enemy, { tag=tag, time=segmentTime, x=deltaX+Path[i].x, y=deltaY+Path[i].y, delay=delay, transition=ease } )
      delay = delay + segmentTime
	  
	  
   end 
end

local function resetBeams()

	-- Clear all beams/bursts from display
	for i = beamGroup.numChildren,1,-1 do
		local child = beamGroup[i]
		display.remove( child )
		child = nil
	end

	-- Reset beam group alpha
	beamGroup.alpha = 1

	-- Restart turret rotating after firing is finished
	turret.angularVelocity = turretSpeed
end
	
local function drawBeam( startX, startY, endX, endY )

	-- Draw a series of overlapping lines to represent the beam
	local beam1 = display.newLine( beamGroup, startX, startY, endX, endY )
	beam1.strokeWidth = 2 ; beam1:setStrokeColor( 1, 0.312, 0.157, 1 ) ; beam1.blendMode = "add" ; beam1:toBack()
	local beam2 = display.newLine( beamGroup, startX, startY, endX, endY )
	beam2.strokeWidth = 4 ; beam2:setStrokeColor( 1, 0.312, 0.157, 0.706 ) ; beam2.blendMode = "add" ; beam2:toBack()
	local beam3 = display.newLine( beamGroup, startX, startY, endX, endY )
	beam3.strokeWidth = 6 ; beam3:setStrokeColor( 1, 0.196, 0.157, 0.392 ) ; beam3.blendMode = "add" ; beam3:toBack()
end

	
local function castRay( startX, startY, endX, endY )

	-- Perform ray cast
	local hits = physics.rayCast( startX, startY, endX, endY, "closest" )

	-- There is a hit; calculate the entire ray sequence (initial ray and reflections)
	if ( hits and beamGroup.numChildren <= maxBeams ) then

		-- Store first hit to variable (just the "closest" hit was requested, so use 'hits[1]')
		local hitFirst = hits[1]

		-- Store the hit X and Y position to local variables
		local hitX, hitY = hitFirst.position.x, hitFirst.position.y
	
		-- Draw the next beam
		drawBeam( startX, startY, hitX, hitY )

		-- Check for and calculate the reflected ray
		local reflectX, reflectY = physics.reflectRay( startX, startY, hitFirst )
		
		
		 for i = 1,#hits do
			if(object == hero) then
				for i = 1,#Path do
					Path[i] = {x = hero.x}
				end
			end
			timer.performWithDelay( 40, function() castRay( hitX, hitY, reflectEndX, reflectEndY ); end )
		end
		
		
	-- Else, ray casting sequence is complete
	else

		-- Draw the final beam
		drawBeam( startX, startY, endX, endY )

		-- Fade out entire beam group after a short delay
		transition.to( beamGroup, { time=800, delay=400, alpha=0, onComplete=resetBeams } )
	end
end
	
local function fireOnTimer( event )

	-- Ensure that all previous beams/bursts are cleared/complete before firing
	if ( beamGroup.numChildren == 0 ) then

		-- Calculate ending x/y of beam
		local xDest = turret.x - (math.cos(math.rad(turret.rotation+90)) * 1600 )
		local yDest = turret.y - (math.sin(math.rad(turret.rotation+90)) * 1600 )

		-- Cast the initial ray
		castRay( turret.x, turret.y, xDest, yDest )
	end
end	

local function enemyCollision (enemy, event)
	if event.phase == "began" then
		if event.target.type == "enemy" and event.other.type == "projectile" then
		print ("enemy hit")
		end
	end
end

function scene:create( event )

	camera = display.newGroup()
	
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	physics.start()
	physics.pause()


	-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.
	local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0 
	background.anchorY = 0
	background:setFillColor( 1 )
		
	-- make a hero (off-screen), position it, and rotate slightly
	hero = display.newImageRect( "stealth_run_character.png", 20, 60 )
	hero.x, hero.y = 30, 207
	
	-- add physics to the hero
	physics.addBody( hero, { density=1.0, wfriction=0.3, bounce=0.0 } )
	hero.isFixedRotation = true
	
	
	
	enemy = display.newImageRect( "Enemy.png", 40, 50 )
	enemy.x, enemy.y = 450, 212.5
	enemy.xScale = -1
	physics.addBody( enemy, { density=1.0, friction=0.3, bounce=0.3 } )
	enemy.isFixedRotation = true
	enemy.collision = enemyCollision
	enemy:addEventListener("collision", enemy)
	
	timer.performWithDelay(5000, setPath( enemy, Path, { useDelta=true, constantTime=500, easingMethod=easing.inOutQuad, delay=200, tag="moveObject" } ), -1 )
	
	
	----------------------------------------adding enemy move loop here
	local hello = true	
	----------------------------------------
	
	painting = display.newImageRect( "Perhaps Modern Art.png", 80, 80 )
	painting.x, painting.y = 30, -90
	
		
	local counter = 0
	
	local HUD = display.newText("Score:" .. "    " .. "Time:", 20, 40, native.systemFont, 12 )
	HUD:setFillColor ( 0, 1, 0)
	
	local HUDtime = display.newText("Time: " .. counter, 20, 60, native.systemFont, 12 )
	HUDtime:setFillColor ( 0, 1, 0)
 
    	local function updateTimer(event)
            counter = counter + 1
            HUDtime.text = "Time: " .. counter .. " secs"
    	end
	
	timer.performWithDelay(1000, updateTimer, 6000)
	
	local controls = display.newText("Use WASD or the arrow keys to move around!", display.contentCenterX - 120, display.contentCenterY - 60, native.systemFont, 12 )
	controls:setFillColor ( 0, 0, 0)
	
	local enemyWarning = display.newText("But be careful not to be spotted by enemies", display.contentCenterX + 20, display.contentCenterY, native.systemFont, 12 )
	enemyWarning:setFillColor ( 0, 0, 0)
	
	finishPoint = display.newRect(5, 224, 30, 30)
	finishPoint:setFillColor ( 0, 1, 0 )
	
	local wallLeft	= display.newImageRect( "BorderWall.png", 20, 480 )
	wallLeft.x, wallLeft.y = -50, 238
	wallLeft.anchorX = 0
	wallLeft.anchorY = 1
	
	physics.addBody( wallLeft, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	wallLeft.isFixedRotation = true
	
	
	local wallRight = display.newImageRect( "BorderWall.png", 20, 150 )
	wallRight.x, wallRight.y = 510, 150
	wallRight.anchorX = 0
	wallRight.anchorY = 1
	
	
	physics.addBody( wallRight, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	wallRight.isFixedRotation = true
	
	local wallRight1 = display.newImageRect( "BorderWall.png", 20, 475 )
	wallRight1.x, wallRight1.y = 1020, 238
	wallRight1.anchorX = 0
	wallRight1.anchorY = 1
	
	
	physics.addBody( wallRight1, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	wallRight1.isFixedRotation = true

	local wallRight2 = display.newImageRect( "BorderWall.png", 20, 165 )
	wallRight2.x, wallRight2.y = 510, -90
	wallRight2.anchorX = 0
	wallRight2.anchorY = 1
	
	
	physics.addBody( wallRight2, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	wallRight2.isFixedRotation = true
	
	local roof = display.newImageRect( "BorderWall.png", 975, 20 )
	roof.x, roof.y = -50, 20
	roof.anchorX = 0
	roof.anchorY = 1
	
	
	physics.addBody( roof, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	roof.isFixedRotation = true
	
	local roof1 = display.newImageRect( "BorderWall.png", 1090, 20 )
	roof1.x, roof1.y = -50, -237
	roof1.anchorX = 0
	roof1.anchorY = 1
	
	
	physics.addBody( roof1, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	roof1.isFixedRotation = true
	
	local step1 = display.newImageRect( "Step.png", 30, 30 )
	step1.x, step1.y = 200, 238
	step1.anchorX = 0
	step1.anchorY = 1
	
	physics.addBody( step1, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	step1.isFixedRotation = true
	
	local step2 = display.newImageRect( "Step.png", 30, 50 )
	step2.x, step2.y = 230, 238
	step2.anchorX = 0
	step2.anchorY = 1
	
	physics.addBody( step2, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	step2.isFixedRotation = true
	
	ladder = display.newImageRect( "ladder.png", 50, 250 )
	ladder.x, ladder.y = 970, 238
	ladder.anchorX = 0
	ladder.anchorY = 1
	
	-- create a ground object and add physics (with custom shape)
	local ground = display.newImageRect( "floor.png", 3000, 82 )
	ground.anchorX = 0
	ground.anchorY = 1
	--  draw the ground at the very bottom of the screen
	ground.x, ground.y = display.screenOriginX, display.actualContentHeight + display.screenOriginY
	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	local groundShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	physics.addBody( ground, "static", { friction=0.3, shape=grassShape } )
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	camera:insert( controls )
	camera:insert( enemyWarning )
	camera:insert( roof )
	camera:insert( roof1 )
	camera:insert( ladder )
	camera:insert( ground)
	camera:insert( painting )
	camera:insert( finishPoint )
	camera:insert( hero )
	camera:insert( wallLeft )
	camera:insert( wallRight )
	camera:insert( wallRight1 )
	camera:insert( wallRight2 )
	camera:insert( step1 )
	camera:insert( step2 )
	camera:insert( enemy )
	sceneGroup:insert( HUD )
	sceneGroup:insert( HUDtime )

end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	Runtime:addEventListener("enterFrame", moveCamera)
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
Runtime:addEventListener( "key", onKeyEvent )
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-----------------------------------------------------------------------------------------

return scene


*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************


-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local camera 
local beamGroup = display.newGroup()

-- include Corona's "physics" library
local physics = require "physics"

--------------------------------------------
hasItem = 0 
-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX
local hero = {}


local soundTable = {

	GadgetSound = audio.loadSound( "betaGadgetsound.wav" ),
	DeathSound = audio.loadSound( "deathsound1.wav" ),
	FootstepSound = audio.loadSound( "footstep.wav" ),
	hitSound = audio.loadSound( "hitsound2.wav" ),
	jumpSound = audio.loadSound( "jump.wav" ),
	ladderSound = audio.loadSound( "ladder.wav" ),
	menuSound = audio.loadSound( "menusound.wav" ), 
	transitionSound = audio.loadSound( "transitionsound.wav" ),
	victorySound = audio.loadSound( "victorysound3.wav" )

}

local function moveCamera()
	
	local leftOffset = 100
	local heroX = hero.x
	local heroY = hero.y
	local yOffset = 210
	local screenLeft = -camera.x
	local moveArea = 200
	
	if heroX > leftOffset then
		if heroX > screenLeft + moveArea then
		camera.x = -hero.x + moveArea
		elseif heroX < screenLeft + leftOffset then
		camera.x = -heroX + leftOffset
		end
	else
		camera.x = 0
	end
	
	if heroY > yOffset then 
		camera.y = heroY + yOffset
	elseif heroY < yOffset then 
		camera.y = -heroY + yOffset
	end
end

local function setHeroProperties ()
-- Hero Properties 
hero.speed = 70

end

local function setHeroVelocity ()
	heroHorizontalVelocity, heroVerticalVelocity = hero:getLinearVelocity()
	hero:setLinearVelocity ( hero.velocity, heroVerticalVelocity)
end

local function setProjectileVelocity (  )
	projectileHorizontalVelocity, projectileVerticalVelocity = projectile:getLinearVelocity()
	projectile:setLinearVelocity ( projectile.velocity, projectileVerticalVelocity)
end

local function onKeyEvent ( event )
	

	
	if (event.keyName == "w" or event.keyName == "space" or event.keyName == "up") and heroVerticalVelocity == 0 then
		if(math.abs(hero.x - ladder.x) < 35 and math.abs(hero.y - ladder.y) < 50) then
			Runtime:addEventListener ("enterFrame", setHeroVelocity)
			audio.play (soundTable["ladderSound"] )
			hero:applyLinearImpulse (0,-30, hero.x, hero.y)
		else
			Runtime:addEventListener ("enterFrame", setHeroVelocity)
			audio.play (soundTable["jumpSound"] )
			hero:applyLinearImpulse (0,-10, hero.x, hero.y)
		end
	elseif event.keyName == "a" or event.keyName == "left" then
		Runtime:addEventListener ("enterFrame", setHeroVelocity)
		hero.velocity = -70
		hero.xScale = -1
			if	heroVerticalVelocity == 0 then
				audio.play (soundTable["FootstepSound"] )
			end
		if (event.keyName == "a" or event.keyName == "left") and event.phase == "up" then
		hero.velocity = hero.velocity + 70
		Runtime:removeEventListener ("enterFrame", setHeroVelocity)
		end
	elseif event.keyName == "d" or event.keyName == "right" then
		Runtime:addEventListener ("enterFrame", setHeroVelocity)
		hero.velocity = 70
		hero.xScale = 1
			if heroVerticalVelocity ==0 then
				audio.play (soundTable["FootstepSound"] )
			end	
		if (event.keyName ~= "a" or event.keyName ~= "left") and event.phase == "up" then
		hero.velocity =  hero.velocity - 70
		Runtime:removeEventListener ("enterFrame", setHeroVelocity)
		end
	elseif 	(event.keyName == "s" or event.keyName == "down") and heroVerticalVelocity ~= 0 then
		Runtime:addEventListener ("enterFrame", setHeroVelocity)
		heroVerticalVelocity = -0.01
		hero:applyLinearImpulse (0,12, hero.x, hero.y)
	elseif  (event.keyName == "f") and event.phase ~= "up" then 
		projectile = display.newRect(hero.x, hero.y, 5, 5 )
		print(projectile)
		
		Runtime:addEventListener ("enterFrame", setProjectileVelocity)
		enemy.collision = enemyCollision
		enemy:addEventListener("collision", enemy)
		projectile:setFillColor(1, 0, 0)
        physics.addBody( projectile, 'dynamic' )
       	projectile.gravityScale = 1
		projectile.velocity = hero.xScale * 500
       	projectileCleanUp()
		camera:insert( projectile )
	elseif (event.keyName == "e" and (math.abs(hero.x - painting.x) < 35 and math.abs(hero.y - painting.y) < 50)) then
		hasItem = 1
		painting.y = 5438345439345
	elseif (event.keyName == "e" and (math.abs(hero.x - finishPoint.x) < 35 and math.abs(hero.y - finishPoint.y) < 50) and hasItem == 1) then
		hasItem = 2
	end
end


	local Path = {}
	Path[1] = { x=-50, y=0}
	Path[2] = { x=50, y=0 }

	local function distBetween( x1, y1, x2, y2 )
		local xFactor = x2 - x1
		local yFactor = y2 - y1
		local dist = math.sqrt( (xFactor*xFactor) + (yFactor*yFactor) )
		return dist
	end

	pathIndex = 1
	
	function setPath( enemy, Path, params )
		
		local delta = params.useDelta or nil
		local deltaX = enemy.x
		local deltaY = enemy.y
		local constant = params.constantTime or nil
		local ease = params.easingMethod or easing.linear
		local tag = params.tag or nil
		local delay = params.delay or 0
        local speedFactor = 1
		local segmentTime = 500

		if ( delta ) then
			deltaX = enemy.x
			deltaY = enemy.y
		end	
		
		
		transition.to( enemy, { 
			tag=tag,
			time=segmentTime,
			x=deltaX+Path[pathIndex].x,
			y=deltaY+Path[pathIndex].y,
			delay=delay,
			transition=ease, 
			onComplete = function (event)
				pathIndex = pathIndex + 1
				if( pathIndex > #Path ) then
					pathIndex = 1
				end
				setPath( enemy, Path, params )
			end
		} )
		
		
		--[[timer.performWithDelay( segmentTime, {  } )
		
		if ( constant ) then
			local dist = distBetween( enemy.x, enemy.y, deltaX+Path[1].x, deltaY+Path[1].y)
			speedFactor = constant/dist
		end	
		
		for i = 1,#Path do
			
			if ( constant ) then
				local dist
				if( i==1 ) then
					dist = distBetween(  enemy.x, enemy.y, deltaX+Path[i].x, deltaY+Path[i].y )
			else
				dist = distBetween( Path[i-1].x, Path[i-1].y, Path[i].x, Path[i].y )
			end
			segmentTime = dist*speedFactor
			else
				if ( path[i].time ) then segmentTime = path[i].time end
		end
		
		 if ( Path[i].easingMethod ) then ease = Path[i].easingMethod end
		 
		 
		 
      delay = delay + segmentTime--]]
	  
	  
   --end
   
end

	

local function resetBeams()

	-- Clear all beams/bursts from display
	for i = beamGroup.numChildren,1,-1 do
		local child = beamGroup[i]
		display.remove( child )
		child = nil
	end

	-- Reset beam group alpha
	beamGroup.alpha = 1

	-- Restart turret rotating after firing is finished
	turret.angularVelocity = turretSpeed
end
	
local function drawBeam( startX, startY, endX, endY )

	-- Draw a series of overlapping lines to represent the beam
	local beam1 = display.newLine( beamGroup, startX, startY, endX, endY )
	beam1.strokeWidth = 2 ; beam1:setStrokeColor( 1, 0.312, 0.157, 1 ) ; beam1.blendMode = "add" ; beam1:toBack()
	local beam2 = display.newLine( beamGroup, startX, startY, endX, endY )
	beam2.strokeWidth = 4 ; beam2:setStrokeColor( 1, 0.312, 0.157, 0.706 ) ; beam2.blendMode = "add" ; beam2:toBack()
	local beam3 = display.newLine( beamGroup, startX, startY, endX, endY )
	beam3.strokeWidth = 6 ; beam3:setStrokeColor( 1, 0.196, 0.157, 0.392 ) ; beam3.blendMode = "add" ; beam3:toBack()
end

	
local function castRay( startX, startY, endX, endY )

	-- Perform ray cast
	local hits = physics.rayCast( startX, startY, endX, endY, "closest" )

	-- There is a hit; calculate the entire ray sequence (initial ray and reflections)
	if ( hits and beamGroup.numChildren <= maxBeams ) then

		-- Store first hit to variable (just the "closest" hit was requested, so use 'hits[1]')
		local hitFirst = hits[1]

		-- Store the hit X and Y position to local variables
		local hitX, hitY = hitFirst.position.x, hitFirst.position.y
	
		-- Draw the next beam
		drawBeam( startX, startY, hitX, hitY )

		-- Check for and calculate the reflected ray
		local reflectX, reflectY = physics.reflectRay( startX, startY, hitFirst )
		
		
		 for i = 1,#hits do
			if(object == hero) then
				for i = 1,#Path do
					Path[i] = {x = hero.x}
				end
			end
			timer.performWithDelay( 40, function() castRay( hitX, hitY, reflectEndX, reflectEndY ); end )
		end
		
		
	-- Else, ray casting sequence is complete
	else

		-- Draw the final beam
		drawBeam( startX, startY, endX, endY )

		-- Fade out entire beam group after a short delay
		transition.to( beamGroup, { time=800, delay=400, alpha=0, onComplete=resetBeams } )
	end
end
	
local function fireOnTimer( event )

	-- Ensure that all previous beams/bursts are cleared/complete before firing
	if ( beamGroup.numChildren == 0 ) then

		-- Calculate ending x/y of beam
		local xDest = turret.x - (math.cos(math.rad(turret.rotation+90)) * 1600 )
		local yDest = turret.y - (math.sin(math.rad(turret.rotation+90)) * 1600 )

		-- Cast the initial ray
		castRay( turret.x, turret.y, xDest, yDest )
	end
end	

function scene:create( event )

	camera = display.newGroup()
	
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	physics.start()
	physics.pause()


	-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.
	local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0 
	background.anchorY = 0
	background:setFillColor( 1 )
		
	-- make a hero (off-screen), position it, and rotate slightly
	hero = display.newImageRect( "stealth_run_character.png", 20, 60 )
	hero.x, hero.y = 30, 207
	
	-- add physics to the hero
	physics.addBody( hero, { density=1.0, wfriction=0.3, bounce=0.0 } )
	hero.isFixedRotation = true
	
	
	
	enemy = display.newImageRect( "Enemy.png", 40, 50 )
	enemy.x, enemy.y = 450, 212.5
	enemy.xScale = -1
	physics.addBody( enemy, { density=1.0, friction=0.3, bounce=0.3 } )
	enemy.isFixedRotation = true
	
	
			setPath( enemy, Path, { tag=tag, time=2000, x=Path[1].x, y=Path[1].y, delay=200 } )

	
	
	----------------------------------------adding enemy move loop here
	local hello = true	
	----------------------------------------
	
	painting = display.newImageRect( "Perhaps Modern Art.png", 80, 80 )
	painting.x, painting.y = 30, -90
	
		
	local counter = 0
	
	local HUD = display.newText("Score:" .. "    " .. "Time:", 20, 40, native.systemFont, 12 )
	HUD:setFillColor ( 0, 1, 0)
	
	local HUDtime = display.newText("Time: " .. counter, 20, 60, native.systemFont, 12 )
	HUDtime:setFillColor ( 0, 1, 0)
 
    	local function updateTimer(event)
            counter = counter + 1
            HUDtime.text = "Time: " .. counter .. " secs"
    	end
	
	timer.performWithDelay(1000, updateTimer, 6000)
	
	local controls = display.newText("Use WASD or the arrow keys to move around!", display.contentCenterX - 120, display.contentCenterY - 60, native.systemFont, 12 )
	controls:setFillColor ( 0, 0, 0)
	
	local enemyWarning = display.newText("But be careful not to be spotted by enemies", display.contentCenterX + 20, display.contentCenterY, native.systemFont, 12 )
	enemyWarning:setFillColor ( 0, 0, 0)
	
	finishPoint = display.newRect(5, 224, 30, 30)
	finishPoint:setFillColor ( 0, 1, 0 )
	
	local wallLeft	= display.newImageRect( "BorderWall.png", 20, 480 )
	wallLeft.x, wallLeft.y = -50, 238
	wallLeft.anchorX = 0
	wallLeft.anchorY = 1
	
	physics.addBody( wallLeft, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	wallLeft.isFixedRotation = true
	
	
	local wallRight = display.newImageRect( "BorderWall.png", 20, 150 )
	wallRight.x, wallRight.y = 510, 150
	wallRight.anchorX = 0
	wallRight.anchorY = 1
	
	
	physics.addBody( wallRight, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	wallRight.isFixedRotation = true
	
	local wallRight1 = display.newImageRect( "BorderWall.png", 20, 475 )
	wallRight1.x, wallRight1.y = 1020, 238
	wallRight1.anchorX = 0
	wallRight1.anchorY = 1
	
	
	physics.addBody( wallRight1, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	wallRight1.isFixedRotation = true

	local wallRight2 = display.newImageRect( "BorderWall.png", 20, 165 )
	wallRight2.x, wallRight2.y = 510, -90
	wallRight2.anchorX = 0
	wallRight2.anchorY = 1
	
	
	physics.addBody( wallRight2, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	wallRight2.isFixedRotation = true
	
	local roof = display.newImageRect( "BorderWall.png", 975, 20 )
	roof.x, roof.y = -50, 20
	roof.anchorX = 0
	roof.anchorY = 1
	
	
	physics.addBody( roof, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	roof.isFixedRotation = true
	
	local roof1 = display.newImageRect( "BorderWall.png", 1090, 20 )
	roof1.x, roof1.y = -50, -237
	roof1.anchorX = 0
	roof1.anchorY = 1
	
	
	physics.addBody( roof1, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	roof1.isFixedRotation = true
	
	local step1 = display.newImageRect( "Step.png", 30, 30 )
	step1.x, step1.y = 200, 238
	step1.anchorX = 0
	step1.anchorY = 1
	
	physics.addBody( step1, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	step1.isFixedRotation = true
	
	local step2 = display.newImageRect( "Step.png", 30, 50 )
	step2.x, step2.y = 230, 238
	step2.anchorX = 0
	step2.anchorY = 1
	
	physics.addBody( step2, "static", { density=5.0, friction=0.3, bounce=0.0 } )
	step2.isFixedRotation = true
	
	ladder = display.newImageRect( "ladder.png", 50, 250 )
	ladder.x, ladder.y = 970, 238
	ladder.anchorX = 0
	ladder.anchorY = 1
	
	-- create a ground object and add physics (with custom shape)
	local ground = display.newImageRect( "floor.png", 3000, 82 )
	ground.anchorX = 0
	ground.anchorY = 1
	--  draw the ground at the very bottom of the screen
	ground.x, ground.y = display.screenOriginX, display.actualContentHeight + display.screenOriginY
	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	local groundShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	physics.addBody( ground, "static", { friction=0.3, shape=grassShape } )
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	camera:insert( controls )
	camera:insert( enemyWarning )
	camera:insert( roof )
	camera:insert( roof1 )
	camera:insert( ladder )
	camera:insert( ground)
	camera:insert( painting )
	camera:insert( finishPoint )
	camera:insert( hero )
	camera:insert( wallLeft )
	camera:insert( wallRight )
	camera:insert( wallRight1 )
	camera:insert( wallRight2 )
	camera:insert( step1 )
	camera:insert( step2 )
	camera:insert( enemy )
	sceneGroup:insert( HUD )
	sceneGroup:insert( HUDtime )
	

end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	Runtime:addEventListener("enterFrame", moveCamera)
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
Runtime:addEventListener( "key", onKeyEvent )
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-----------------------------------------------------------------------------------------

return scene



