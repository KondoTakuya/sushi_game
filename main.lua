--
-- Project: ShushiGame
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

system.activate( "multitouch" )

--背景の設定
local counter_table = display.newImageRect( "counter_table.jpg", _W, _H)
counter_table:setReferencePoint( display.TopLeftReferencePoint )
counter_table.x, counter_table.y = 0, 0

----------------------------------------------------------------------------
--物理演算等
physics = require("physics")
physics.start()
physics.setGravity(0,0)
----------------------------------------------------------------------------
local dish_Body = { density=1.0, friction=0, bounce=0.5, radius=circlesize }

--------------rane-----------------------------------------------------------
local rane= display.newImageRect("rane2.png",_W*3,_H/5)
rane.y=_H/5
rane.under=_W*3
rane.hight=_H/5
rane.over=rane.under+rane.hight
-------------------------------------------------------------------------------
local kanjou = display.newImageRect( "kanjou.png", circlesize*2,circlesize*2)
kanjou.x=_W-(circlesize/3)*4
kanjou.y=_H-(circlesize/3)*4

local option_img = display.newImageRect( "option.png", circlesize*2,circlesize*3)
option_img.x=_W-(circlesize/3)*4
option_img.y=_H-circlesize*4

physics.addBody ( kanjou,"static")
physics.addBody ( option_img,"static")

-------------------------------------------------------------------------------
group = display.newGroup()
move_test=0;
dish_num=0
---------------------------	fly object
local  army_fly=display.newImageRect ( "fly.png",circlesize*2, circlesize*2)
army_fly.x,army_fly.y=100,200

army_fly.rotation=100
physics.addBody (army_fly,dish_Body)	

group:insert(army_fly)


--------------------------------------------------------

--醤油皿
circle_center=display.newImageRect ( "mini_dish.png" ,circlesize*3,circlesize*3 )
circle_center.x=circlesize*3;
circle_center.y=_H-circlesize*3

physics.addBody(circle_center, "static",dish_Body)
physics.addBody(circle_center,{isSensor = true,"static",density=9.0,radius=circlesize})

--------------------------------------------

--壁の定義
rect1 = display.newRect(0, _H-5, _W, 5)
rect2 = display.newRect(0, (_H/12)*5, 5, _H)
rect3 = display.newRect(_W-5, (_H/12)*5, 5, _H)

physics.addBody(rect1, "static")--手前　下
physics.addBody(rect2, "static")--左
physics.addBody(rect3, "static")--右


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
else if t.isFocus then
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
end
circle_center:addEventListener( "touch", startDrag )
------------------------------------------------------
---gameフラグ
push=nill;
hashi=nill;
var=nill;
move_test=0;

----生成を止める
function stop_dish(event)
	hashi=stop
end
-------------------------------slider
local widget = require "widget"
local sliderListener = function( event )
	local slider = event.target
	local value = event.value

	print( "Slider at " .. value .. "%" )
	move_test=(value-50)/10
	if(var==nill)then
		var=true;
	end
end
local mySlider1 = widget.newSlider{
width=_W/3*2,
top = _H-circlesize,
left = _W/6,
listener =sliderListener}

--------------皿自動生成
local random_dish = function()

	new_dish = display.newImageRect ( "test("..math.random(6)..").png",circlesize*2, circlesize*2)

	new_dish.on_rale=true
	new_dish.x= _W+circlesize*2
	new_dish.y=_H /5-(circlesize/2)+math.random ( _H/20 )

	new_dish:setFillColor (math.random(30)+200,255,  255 )

	new_dish:addEventListener( "touch", startDrag )
	physics.addBody( new_dish ,dish_Body)
	group:insert(new_dish)
end

--グループの各円を塗りつぶす
for i=1, group.numChildren do 
	group[i]:setFillColor(math.random(255), math.random(255), math.random(255))
	physics.addBody ( group[i],dish_Body)

	group[i]:addEventListener( "touch", startDrag )
end

------------------------------------------------------------------------
----groupに追加することで，rane上に置くと流れるようになる
group.move=function ()
for i=1, group.numChildren do 

	if(group[i].y<(_H/5)*1.5) then
		if(group[i].y>(_H/5)*0.5)then
			group[i].x=  group[i].x+move_test;
		end
	else
		push=true
	end
end
end

local function onTimeEvent( event )
-----rane速度の調節

group.move()

rane.x=  rane.x+move_test;
if(move_test<0)then
	if(rane.x<-_W/2)then
		rane.x=0;
	end
	else if(rane.x>_W+_W/2)then
		rane.x=0;
	end
end
end


timer.performWithDelay(10, onTimeEvent, 0 )



function set_next_dish(event)

	--一定の感覚というルールも作れるかも
	random_dish()
	print("dish_num= "..dish_num)
end
push=true
function check_rane(event)
	if(push==true)then
		push=false
		timer.performWithDelay( 100, set_next_dish, 1)
	end
end

function set_var(event)
	if(hashi==true)then
		push=true;
		hashi=false;
	end
	if(var==true)then
		push=true;
		var=false
		hashi=true
	end
	if(hashi==stop)then
		push=false;
		var=false;
	end

	check_rane()
end

timer.performWithDelay( 1000, set_var, 0)

function startGame(event)
	if(move_test==0)then
		move_test=-0.1
		push=true
	end
	if(hashi==nill)then
	var=true
	end
	hashi=true;
	
end

--箸
local hashi = display.newImageRect( "hashi.png", circlesize*10,circlesize/2)
hashi.x=_W/2
hashi.y=_H-circlesize
physics.addBody ( hashi,"static")
group:insert(hashi)

---箸カバー
local time_img = display.newImageRect( "time.png",circlesize*9,circlesize)
time_img.x=_W/2-circlesize
time_img.y=_H-circlesize
physics.addBody ( time_img,"static")

hashi:addEventListener( "touch", startDrag )
hashi:addEventListener ( "touch", startGame )
------------------------------------------------------------------------------------