local Library = require "CoronaLibrary"

local lib = Library:new{ name='plugin.att', publisherId='com.solar2d' }

-- Default implementations

lib.request = function(listener)
	print( "WARNING: The '" .. lib.name .. "' library is not available on this platform." )
	if type(listener) == "table" and type(listener.att) == "function" then
		listener = listener.att
	end
	if type(listener) == "function" then
		listener({name="att", status="unavailable"})
	end
end
lib.status = "unavailable"

-- Return an instance
return lib
