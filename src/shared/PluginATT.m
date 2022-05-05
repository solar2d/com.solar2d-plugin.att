//
//  PluginATT.m
//
//
//  MIT License, (c) 2020 Solar2D, Vlad Shcherban
//

#include <CoronaLua.h>
#include <CoronaMacros.h>
#include <CoronaLibrary.h>
#include <string.h>
#include <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/ASIdentifierManager.h>
CORONA_EXPORT int luaopen_plugin_att( lua_State *L );

static void pushStatus(lua_State *L, NSUInteger status)
{
	if (@available(iOS 14, tvOS 14, macOS 11, *)) {
		switch ((ATTrackingManagerAuthorizationStatus)status) {
			case ATTrackingManagerAuthorizationStatusAuthorized:
				lua_pushliteral(L, "authorized");
				return;
			case ATTrackingManagerAuthorizationStatusDenied:
				lua_pushliteral(L, "denied");
				return;
			case ATTrackingManagerAuthorizationStatusRestricted:
				lua_pushliteral(L, "restricted");
				return;
			case ATTrackingManagerAuthorizationStatusNotDetermined:
				lua_pushliteral(L, "notDetermined");
				return;
		}
	}
	lua_pushliteral(L, "unavailable");
}

static int att_kv( lua_State *L )
{
	const char *key = lua_tostring( L, 2 );
	if ( key && 0 == strcmp( "status", key ) )
	{
		NSUInteger status = -1;
		if (@available(iOS 14, tvOS 14, *)) {
			status = [ATTrackingManager trackingAuthorizationStatus];
		}
		pushStatus(L, status);
		return 1;
	}
	
	return 0;
}

static int att_request( lua_State *L )
{
	static const char *const eventName = "att";
	CoronaLuaRef listener = NULL;
	if(CoronaLuaIsListener(L, 1, eventName)) {
		listener = CoronaLuaNewRef(L, 1);
	}
	
	if (@available(iOS 14, tvOS 14, *)) {
		[ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
			if(listener) {
				[[NSOperationQueue mainQueue] addOperationWithBlock:^{
					CoronaLuaNewEvent(L, eventName);
					pushStatus(L, status);
					lua_setfield(L, -2, "status");
					CoronaLuaDispatchEvent(L, listener, 0);
					CoronaLuaDeleteRef(L, listener);
				}];
			}
		}];
	} else {
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			CoronaLuaNewEvent(L, eventName);
			pushStatus(L, -1);
			lua_setfield(L, -2, "status");
			CoronaLuaDispatchEvent(L, listener, 0);
			CoronaLuaDeleteRef(L, listener);
		}];

	}
	return 0;
}

static int att_getAdId( lua_State *L )
{
    NSUUID *adId = [[ASIdentifierManager sharedManager] advertisingIdentifier];
    lua_pushstring(L, [[adId UUIDString] UTF8String]);
    return 1;
}


// ----------------------------------------------------------------------------
CORONA_EXPORT int luaopen_plugin_att( lua_State *L )
{
	const luaL_Reg kVTable[] =
	{
		{ "request", att_request },
        { "getAdId", att_getAdId },
		{ NULL, NULL }
	};
	
	CoronaLibraryNew( L, "plugin.att", "com.solar2d", 1, 1, kVTable, NULL );
	lua_pushcfunction(L, att_kv);
	CoronaLibrarySetExtension( L, -2 );
	return 1;
}
