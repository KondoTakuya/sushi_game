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
circle = display.newCircle(_W/2, _H/2 , circlesize)

circle:setStrokeColor(math.random(255), math.random(255), math.random(255))
circle:setFillColor(math.random(255), math.random(255), math.random(255))
circle.strokeWidth = circlesize/4
circle:setFillColor(0, 0, 0, 0)

physics.addBody(circle, "static")

group:insert(display.newCircle(_W/2, 50, circlesize))
group:insert(display.newCircle(_W/2, _H-50, circlesize))
group:insert(display.newCircle(50, _H/2, circlesize))
group:insert(display.newCircle(_W-50, _H/2, circlesize))
physics.addBody(circle,{isSensor = true})

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

circle:addEventListener("collision", 
	function(event) 
		circle:setFillColor(math.random(255), math.random(255), math.random(255))
		playBeep()
		end)



function buttonFunc(event)
	--print("tap")
	playBeep()
	event.target:applyLinearImpulse(10, 10, event.x, event.y)
	return
end

--グループの各円を塗りつぶす
for i=1, group.numChildren do 
	group[i]:setFillColor(math.random(255), math.random(255), math.random(255))
	physics.addBody(group[i])
	
	group[i]:addEventListener("tap", buttonFunc)
end



