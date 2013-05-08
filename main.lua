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
		local circlesize=_H/15

--背景の設定
		local back_ground_sky = display.newImageRect( "counter_table.jpg", display.contentWidth, display.contentHeight )
		back_ground_sky:setReferencePoint( display.TopLeftReferencePoint )
		back_ground_sky.x, back_ground_sky.y = 0, 0
	
	soundID = audio.loadSound( "beep_mp3.mp3" )
	
	

	--物理演算等
		physics = require("physics")
		physics.start()
		physics.setGravity(0,0)
	--	physics.setGravity( 0, 9.8 )

	-- Load some external Lua libraries (from project directory)
local movieclip = require( "movieclip" )
	
local ballInPlay = false

dish_num=0

-- Create master display group (for global "camera" scrolling effect)
local game = display.newGroup();
game.x = 0
----------------------------------------------------------------------------
local dish_Body = { density=1.0, friction=0, bounce=0.5, radius=circlesize }



		--------------rane------------------------------------------------------------------------------------
local rane= display.newImageRect("rane2.png",_W*3,_H/5)
  rane.y=_H/5
  
  --幅 _W    高さ_H/5    x=0    y=_H/5
  

		local kanjou = display.newImageRect( "kanjou.png", circlesize*2,circlesize*2)
	kanjou.x=_W-(circlesize/3)*4
     kanjou.y=_H-(circlesize/3)*4
  

     

         			local option_img = display.newImageRect( "option.png", circlesize*2,circlesize*3)
	option_img.x=_W-(circlesize/3)*4
     option_img.y=_H-circlesize*4
     
     physics.addBody ( kanjou,"static")
      

       physics.addBody ( option_img,"static")
	
	--グループの作成
	group = display.newGroup()
	

	
	--醤油皿
	circle_center=display.newImageRect ( "mini_dish.png" ,circlesize*3,circlesize*3 )
	circle_center.x=circlesize*3;
	circle_center.y=_H-circlesize*3
	
	physics.addBody(circle_center, "static",dish_Body)
	physics.addBody(circle_center,{isSensor = true,"static",density=9.0,radius=circlesize})
	


---------------------------	fly object
	local  army_fly=display.newImageRect ( "fly.png",circlesize*2, circlesize*2)
	army_fly.x,army_fly.y=20,20
	army_fly.rotation=100
	physics.addBody (army_fly,dish_Body)	
	
	group:insert(army_fly)
	
	army_fly.x=100
	army_fly.y=200


---------------------------------------------

	
	--壁の定義
	
	rect2 = display.newRect(0, (_H/12)*5, 5, _H)
	rect3 = display.newRect(_W-5, (_H/12)*5, 5, _H)
	rect4 = display.newRect(0, _H-5, _W, 5)
	
	physics.addBody(rect2, "static")--左
	physics.addBody(rect3, "static")--右
	physics.addBody(rect4, "static")--手前　下
	
	local playBeep = function()
		--print("beep")
		--randomFly()
		audio.play( soundID )
	end

	
	-------------------------------------醤油皿の設定
	
	circle_center:addEventListener("collision", 
		function(event) 
			playBeep()

			end)

	-------------------------------------tapによる爆発
	
	function buttonFunc(event)
		--print("tap")
		playBeep()
		event.target:applyLinearImpulse(math.random(1000), math.random(1000), event.x, event.y)

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

   -- print( "Slider at " .. value .. "%" )
    move_test=(value-50)/10
    end
local mySlider1 = widget.newSlider{
        width=_W/3*2,
        
        top = _H-circlesize/2,
       left = _W/6,

        listener =sliderListener
}

------------------------------------------------------


push=1;

	--------------皿自動生成
local random_dish = function()
random_dish = display.newImageRect ( "test("..math.random(6)..").png",circlesize*2, circlesize*2)
	--random_dish.x = 10 + math.random( 60 ); random_dish.y = -20
	random_dish.on_rale=true
	

	--random_dish.x=math.random ( _W)
	--random_dish.y=math.random ( _H )
	random_dish.x= _W+circlesize*1
random_dish.y=_H /5+math.random ( _H/20 )
	
		--random_dish.rotation=math.random(math.danrom(360))
	random_dish:setFillColor (math.random(30)+200,255,  255 )
	physics.addBody( random_dish ,dish_Body)
	--random_dish:addEventListener("tap", buttonFunc)
	random_dish:addEventListener( "touch", startDrag )
	
	function rane_on_dish(event)
		if(random_dish.x<-circlesize)then
			push=1
			--random_dish:removeSelf()
			
		end
		
		if(random_dish.y<0-circlesize)then
			push=1
			--random_dish:removeSelf()
			return
		end
		
		if(random_dish.y<(_H/5))then
				--out or rane
			--dish_num=dish_num-1
			push=1
			else
				if(random_dish.y<(_H/5)*1.5) then
				 	 random_dish.x=  random_dish.x+move_test;
				else
					--dish_num=dish_num-1
					push=1
				end

		end
	end
	

	
	timer.performWithDelay(10, rane_on_dish, 0 )
	
end


--random_dish()
--お試しの皿

	--グループの各円を塗りつぶす
	for i=1, group.numChildren do 
		group[i]:setFillColor(math.random(255), math.random(255), math.random(255))
		physics.addBody ( group[i],dish_Body)

		group[i]:addEventListener("tap", buttonFunc)
		group[i]:addEventListener( "touch", startDrag )
	end
	
	---timer
--local myImage = display.newImageRect("myImage.png",20,20);
	local function onTimeEvent( event )
		
	for i=1, group.numChildren do 
	    group[i].x = group[i].x+move_test;
	  end
	  
	    rane.x=  rane.x+move_test*3;
	    if(move_test<0)then
	    if(rane.x<-_W/2)then
	    	rane.x=0;
	    	--timer.performWithDelay( 300*(-move_test), random_dish, 1)
	    end
	    
	    else
	     if(rane.x>_W+_W/2)then
	    	rane.x=0;
	    	--timer.performWithDelay( 300*(move_test), random_dish, move_test)

	    end
	    end

		
	end
	 
	timer.performWithDelay(10, onTimeEvent, 0 )
	
	-- Call the above function 12 times
--timer.performWithDelay( 1000, random_dish, 3)

function set_next_dish(event)
--if(dish_num<5)then
		random_dish()
	
	--dish_num=dish_num+1
--end
	print("dish_num= "..dish_num)
end



function check_rane(event)
	if(push>0)then
	local i=11+move_test
	timer.performWithDelay( 100, set_next_dish, 1)
	push=0;
	end
end


function startGame(event)
	if(move_test==0)then
	move_test=-1
	start_game=2
	timer.performWithDelay( 1000, check_rane, 0)
	end
end

		local hashi = display.newImageRect( "hashi.png", circlesize*10,circlesize/2)
		hashi.x=_W/2
     	hashi.y=_H-circlesize
     	physics.addBody ( hashi,"static")
     
		local time_img = display.newImageRect( "time.png",circlesize*9,circlesize)
		time_img.x=_W/2-circlesize
    	 time_img.y=_H-circlesize
            physics.addBody ( time_img,"static")
     
	hashi:addEventListener( "touch", startDrag )
	hashi:addEventListener ( "touch", startGame )
	------------------------------------------------------------------------------------		local function on_rane( event )
			local on_t = event.target			if(on_t.y<(_H/5))then
			else
				if(on_t.y<(_H/5)*1.5) then
				 	 on_t.x=  on_t.x+move_test;
				end
			end		end		function  on_rane_move(event)		timer.performWithDelay( 1000, on_rane(event), 0)	end	
			hashi:addEventListener( "touch", on_rane_move )






	
	