	--
	-- Project: TestGame
	-- Description: 
	--
	-- Version: 1.0
	-- Managed with http://CoronaProjectManager.com
	--
	-- Copyright 2013 . All Rights Reserved.
	--
	 
	 --回転寿司に変更
	 
	 --画面の規定
	display.setStatusBar(display.HiddenStatusBar)
	_W = display.contentWidth
	_H = display.contentHeight
	

--背景の設定
		local back_ground_sky = display.newImageRect( "counter_table.jpg", display.contentWidth, display.contentHeight )
		back_ground_sky:setReferencePoint( display.TopLeftReferencePoint )
		back_ground_sky.x, back_ground_sky.y = 0, 0
	
	soundID = audio.loadSound( "beep_mp3.mp3" )

	--物理演算等
		physics = require("physics")
		physics.start()
		physics.setGravity(0,0)
	--	physics.setGravity( 0, 9.8 )		-- Load some external Lua libraries (from project directory)
local movieclip = require( "movieclip" )	local ballInPlay = false

-- Create master display group (for global "camera" scrolling effect)
local game = display.newGroup();
game.x = 0----------------------------------------------------------------------------local dish_Body = { density=1.0, friction=0.1, bounce=0.5, radius=circlesize }

-- Uses "movieclip" library for simple 2-frame animation; could also use sprite sheets for more complex animations
--dish1 = movieclip.newAnim{"test(1).png","test(2).png", }
--game:insert( dish1 ); --dish1.id = "dish1";--dish1.x = 400; dish1.y = 400;--dish1.Width=100;dish1.Height=100;
--physics.addBody( dish1, dish_Body )
		--------------rane------------------------------------------------------------------------------------
local rane= display.newImageRect("rane.png",_W*2,_H/5)
  rane.y=_H/5
	
	--グループの作成
	group = display.newGroup()
	
	local circlesize=_H/15
	
	--真ん中に円
	circle_center = display.newCircle(_W/2, _H/2 , circlesize)
	
	circle_center:setStrokeColor(math.random(255), math.random(255), math.random(255))
	circle_center:setFillColor(math.random(255), math.random(255), math.random(255))
	circle_center.strokeWidth = circlesize/4
	circle_center:setFillColor(0, 0, 0, 0)
	
	physics.addBody(circle_center, "static",dish_Body)
	physics.addBody(circle_center,{isSensor = true,radius=circlesize})
	

	--------------------4方の円
--	group:insert(display.newCircle(_W/2, 50, circlesize))
--	group:insert(display.newCircle(_W/2, _H-50, circlesize))
--	group:insert(display.newCircle(50, _H/2, circlesize))
--	group:insert(display.newCircle(_W-50, _H/2, circlesize))


---------------------------	fly object
	local  army_fly=display.newImageRect ( "fly.png",circlesize*2, circlesize*2)
	army_fly.x,army_fly.y=20,20
	army_fly.rotation=100
	physics.addBody (army_fly,dish_Body)	
	
	group:insert(army_fly)
	
	army_fly.x=100
	army_fly.y=200
	
	----------------------------------
	--local  army_fly=display.newImageRect ( "fly.png",circlesize*2, circlesize*2)

---------------------------------------------

	
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
		--randomFly()
		audio.play( soundID )
	end
	----------------------------------物体の設定(null))
		
--		army=display.newGroup ( )
--		for i=1,100 do
--			fuel_army=display.newCircle( math.random(_W-circlesize), math.random(_H-circlesize), circlesize/10)
--			fuel_army:setFillColor  ( 200, 100, 50 )
--			army:insert(fuel_army)
--		end
	
	-------------------------------------中央のBallの設定
	
	circle_center:addEventListener("collision", 
		function(event) 
			circle_center:setFillColor(math.random(255), math.random(255), math.random(255))
			playBeep()
			end)

	

	

	-------------------------------------tapによる爆発
	
	function buttonFunc(event)
		--print("tap")
		playBeep()
		event.target:applyLinearImpulse(math.random(10), math.random(10), event.x, event.y)
		
	--	local  sushi=display.newImageRect ( "test(1).png",circlesize*2, circlesize*2)
	--	sushi.x=event.x
		--sushi.y=event.y
		
		return
	end
	

-------------------------------------------------------------------------------------------------------------------

	--startDrag CoronaWikiを参考に
	local function startDrag( event )
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
-------------------------------------------------------------------------------------------------------------------

local move_test = 0;

-------------------------------slider
local widget = require "widget"
local sliderListener = function( event )
        local slider = event.target
 	   local value = event.value

    print( "Slider at " .. value .. "%" )
    move_test=(value-50)/10
    end
local mySlider1 = widget.newSlider{
        width=_W/3*2,
        
        top = _H-40,
       left = _W/6,

        listener =sliderListener
}


------------------------------------------------------

----------------------------------------------------------

	
	--------------卵自動生成
local random_dish = function()
	random_dish = display.newImageRect ( "test(4).png",circlesize*2, circlesize*2)
	--random_dish.x = 10 + math.random( 60 ); random_dish.y = -20
	random_dish.on_rale=true		if(random_dish_rale) then		printf("true")	end	
	random_dish.x=math.random ( _W )
	random_dish.y=math.random ( _H )	
	random_dish.rotation=math.random(359)
	random_dish:setFillColor (math.random(30)+200,255,  255 )
	physics.addBody( random_dish ,dish_Body)
	random_dish:addEventListener("tap", buttonFunc)
	random_dish:addEventListener( "touch", startDrag )
			local function onTimeEvent2( event )		
	    random_dish.x = random_dish.x+move_test;
	    
		local target=math.random ( 10 )
	end
	 
	timer.performWithDelay(10, onTimeEvent2, 0 )		
end

-- Call the above function 12 times
timer.performWithDelay( 1000, random_dish, 10)

	--グループの各円を塗りつぶす
	for i=1, group.numChildren do 
		group[i]:setFillColor(math.random(255), math.random(255), math.random(255))
		physics.addBody ( group[i],dish_Body)
		
		group[i]:addEventListener("tap", buttonFunc)
		group[i]:addEventListener( "touch", startDrag )
	end		---timer
--local myImage = display.newImageRect("myImage.png",20,20);
	local function onTimeEvent( event )		
	for i=1, group.numChildren do 
	    group[i].x = group[i].x+move_test;
	  end
	    
		local target=math.random ( 10 )
	end
	 
	timer.performWithDelay(10, onTimeEvent, 0 )	
	



	
	