--
-- Project: TestGame
-- Description: 
--
-- Version: 1.0
-- Managed with http://CoronaProjectManager.com
--
-- Copyright 2013 . All Rights Reserved.
--
 
 
 --画面の規定
display.setStatusBar(display.HiddenStatusBar)
_W = display.contentWidth
_H = display.contentHeight



physics = require("physics")
physics.start()
physics.setGravity(0,0)

--グループの作成
group = display.newGroup()

local circlesize=30

--真ん中に円
circle_center = display.newCircle(_W/2, _H/2 , circlesize)

circle_center:setStrokeColor(math.random(255), math.random(255), math.random(255))
circle_center:setFillColor(math.random(255), math.random(255), math.random(255))
circle_center.strokeWidth = circlesize/4
circle_center:setFillColor(0, 0, 0, 0)

physics.addBody(circle_center, "static")
physics.addBody(circle_center,{isSensor = true})
group:insert(display.newCircle(_W/2, 50, circlesize))
group:insert(display.newCircle(_W/2, _H-50, circlesize))
group:insert(display.newCircle(50, _H/2, circlesize))
group:insert(display.newCircle(_W-50, _H/2, circlesize))


--物理演算等
soundID = audio.loadSound( "beep_mp3.mp3" )

--壁の定義
rect1 = display.newRect(0, 0, _W, 5)
rect2 = display.newRect(0, 0, 5, _H)
rect3 = display.newRect(_W-5, 0, 5, _H)
rect4 = display.newRect(0, _H-5, _W, 5)

physics.addBody(rect1, "static")
physics.addBody(rect2, "static")
physics.addBody(rect3, "static")
physics.addBody(rect4, "static")

local playBeep = function()
	print("beep")
	audio.play( soundID )
end

circle_center:addEventListener("collision", 
	function(event) 
		circle_center:setFillColor(math.random(255), math.random(255), math.random(255))
		playBeep()				Set_new_circle()
		end)

function Set_new_circle()	--if not circle2 then		circle2=display.newCircle( math.random(_W), math.random(_H), circlesize)	--else		--circle2=display.remove( circle2 )	--endend

function buttonFunc(event)
	--print("tap")
	playBeep()
	event.target:applyLinearImpulse(10, 10, event.x, event.y)
	return
end

--グループの各円を塗りつぶす
for i=1, group.numChildren do 
	group[i]:setFillColor(math.random(255), math.random(255), math.random(255))
	physics.addBody ( group[i], {friction=10.0})
	
	group[i]:addEventListener("tap", buttonFunc)
end
--startDrag CoronaWikiを参考にlocal function startDrag( event )
	local t = event.target

	local phase = event.phase
	if "began" == phase then
		display.getCurrentStage():setFocus( t )
		t.isFocus = true

		-- Store initial position
		t.x0 = event.x - t.x
		t.y0 = event.y - t.y
		
		-- Make body type temporarily "kinematic" (to avoid gravitional forces)
		event.target.bodyType = "kinematic"
		
		-- Stop current motion, if any
		event.target:setLinearVelocity( 0, 0 )
		event.target.angularVelocity = 0
	elseif t.isFocus then
		if "moved" == phase then
			t.x = event.x - t.x0
			t.y = event.y - t.y0

		elseif "ended" == phase or "cancelled" == phase then
			display.getCurrentStage():setFocus( nil )
			t.isFocus = false
			
			-- Switch body type back to "dynamic", unless we've marked this sprite as a platform
			if ( not event.target.isPlatform ) then
				event.target.bodyType = "dynamic"
			end

		end
	end
	-- Stop further propagation of touch event!
	return true
end

circle_center:addEventListener( "touch", startDrag )


