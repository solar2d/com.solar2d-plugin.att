local att = require "plugin.att"
local json = require "json"

local statusText = display.newText( att.status, display.contentCenterX, display.contentCenterY*0.5, nil, 14 )
timer.performWithDelay( 500, function(  )
	statusText.text = att.status
end, 0 )

local eventText = display.newText( "tap to request", display.contentCenterX, display.contentCenterY*1.5, display.contentWidth*0.5, display.contentHeight*0.25, nil, 14 )

Runtime:addEventListener( "tap", function( )
	att.request(function( e )
		eventText.text = json.prettify( e )
	end)
end )
