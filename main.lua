-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
	local ass = display.newImageRect( "ass.png", 100, 100)
	
	
	local Path = {}
	Path[1] = { x=205, y=100 }
	Path[2] = { x=300, y=100 }
	Path[3] = { x=10, y=100 }
	Path[4] = { x=205, y=100 }
	
	local function distBetween( x1, y1, x2, y2 )
		local xFactor = x2 - x1
		local yFactor = y2 - y1
		local dist = math.sqrt( (xFactor*xFactor) + (yFactor*yFactor) )
		return dist
	end

	local function setPath( ass, Path, params )
		
		local delta = params.useDelta or nil
		local deltaX = 0
		local deltaY = 0
		local constant = params.constantTime or nil
		local tag = params.tag or nil
		local delay = params.delay or 0
        local speedFactor = 1
		
		if ( delta ) then
			deltaX = ass.x
			deltaY = ass.y
		end	
		
		if ( constant ) then
			local dist = distBetween( ass.x, ass.y, deltaX+Path[1].x, deltaY+Path[1].y)
			speedFactor = constant/dist
		end	
		
		for i = 1,#Path do
		
			local segmentTime = 18000
			
			if ( constant ) then
				local dist
				if( i==1 ) then
					dist = distBetween(  ass.x, ass.y, deltaX+Path[i].x, deltaY+Path[i].y )
			else
				dist = distBetween( Path[i-1].x, Path[i-1].y, Path[i].x, Path[i].y )
			end
			segmentTime = dist*speedFactor
			else
				if ( path[i].time ) then segmentTime = path[i].time end
		end
		
		 if ( Path[i].easingMethod ) then ease = Path[i].easingMethod end
		 
		transition.to( ass, { tag=tag, time=segmentTime, x=deltaX+Path[i].x, y=deltaY+Path[i].y, delay=delay, transition=ease } )
      delay = delay + segmentTime
   end
end
		
		setPath( ass, Path, { useDelta=true, constantTime=1800, easingMethod=easing.inOutQuad, delay=200, tag="moveObject" } )
