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
hero.speed = 70

end

local function setHeroVelocity ()
local heroHorizontalVelocity, heroVerticalVelocity = hero:getLinearVelocity()
	hero:setLinearVelocity ( hero.velocity, heroVerticalVelocity)
end

local function doControlsTouch (event)

	local buttonPressed = event.target
	
	if event.phase=="began" then
		if buttonPressed.id == "Jump" then
			print ("button Jump is down")
			
			hero:applyLinearImpulse (0,-40, hero.x, hero.y)
		else 
			Runtime:addEventListener ("enterFrame", setHeroVelocity)
			print ("button pad is down")
			
			local touchX = event.x
			
			if touchX < 50 then
				-- move left 
				hero.velocity = -hero.speed
	
			else 
			
				-- move right
				hero.velocity = hero.speed
				
			end
		end 
	elseif event.phase=="ended" then 
		if buttonPressed.id == "Jump" then
			print ("button Jump is up")
			

			Runtime:removeEventListener ("enterFrame", setHeroVelocity)
			
		else 
			print ("button pad is up")
			hero.velocity = 0
		end 
		
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
	background:setFillColor( .5 )
	
	-- create the hero 
	hero = display.newImageRect("hero.png", 160 ,60,64, 90 )
	hero.x, hero.y = 160, 60
	
	-- create controls 
	local controls = display.newRect(50, 290, 96, 32)
	controls.id = "LeftRight"
	controls:addEventListener("touch", doControlsTouch)
	
	local btnJump = display.newCircle (475,290,16)
	btnJump.id = "Jump"
	btnJump:addEventListener("touch", doControlsTouch)
	
	-- add physics to the hero
	physics.addBody( hero, { density=1.0, friction=0.3, bounce=0 } )
	setHeroProperties()
	
	
	-- create a grass object and add physics (with custom shape)
	local grass = display.newImageRect( "grass.png", screenW, 82 )
	grass.anchorX = 0
	grass.anchorY = 1
	--  draw the grass at the very bottom of the screen
	grass.x, grass.y = display.screenOriginX, display.actualContentHeight + display.screenOriginY
	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	local grassShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	physics.addBody( grass, "static", { friction=0.3, shape=grassShape } )
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( grass)
	sceneGroup:insert( hero )
	sceneGroup:insert( controls )
	sceneGroup:insert( btnJump )
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
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene