# att.getAdId()

> --------------------- ------------------------------------------------------------------------------------------
> __Type__				[Function][api.type.Function]
> __Revision__			[REVISION_LABEL](REVISION_URL)
> __Keywords__			Ads, Monetization, Apple, App Tracking Transparency
> __Platforms__			iOS, tvOS
> --------------------- ------------------------------------------------------------------------------------------


Function, will return Advertise Id for device as a [String][api.type.String] (Note: if Ad Id is `00000000-0000-0000-0000-000000000000` means that you don't have permission to track).


## Example

``````lua
local att = require( "plugin.att" )
print("Device Ad Id:"..att.getAdId())
``````
