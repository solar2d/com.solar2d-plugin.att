local Library = require "CoronaLibrary"

local lib = Library:new{ name='plugin.att', publisherId='com.solar2d' }

-- Default implementations
local function defaultFunction()
	print( "WARNING: The '" .. lib.name .. "' library is not available on this platform." )
end

lib.request = defaultFunction
lib.status = "unavailable"

-- Return an instance
return lib
