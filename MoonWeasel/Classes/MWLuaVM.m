//
//  MWLuaVM.m
//  MoonWeaselApp
//
//  Created by john on 12/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MWLuaVM.h"

#import "lapi.h"
#import "lualib.h"
#import "lauxlib.h"

#define MW_SERVER_KEY "MoonWeasel_server"


@interface MWLuaVM (Private)
- (id)toObject:(int)idx;
- (id)performSelectorOnDelegate:(SEL)selector withObject:(id)obj;
- (void)pushObject:(id)obj;
@end


int mw_delegate(lua_State *L) {
    lua_getfield(L, LUA_REGISTRYINDEX, MW_SERVER_KEY);
    MWLuaVM *me = lua_touserdata(L, -1);
    
    if (me.delegate == nil) {
        return 0;
    }
    
    NSString *selName = [me toObject:1];
    id obj = [me toObject:2];
    if (selName) {
        SEL selector = NSSelectorFromString(selName);
        id result = [me performSelectorOnDelegate:selector withObject:obj];
        [me pushObject:result];
        return 1;
    }
    
    return 0;
}


luaL_Reg mw_lib[2] = {
    {"delegate", mw_delegate},
    {NULL, NULL}
};


@implementation MWLuaVM

@synthesize delegate;

- (id)init {
    if ((self = [super init])) {
        L = lua_open();
        luaL_openlibs(L);
        lua_pushlightuserdata(L, self);
        lua_setfield(L, LUA_REGISTRYINDEX, MW_SERVER_KEY);
        luaL_register(L, "moonweasel", mw_lib);
        [self doFileNamed:@"main"];
        lua_settop(L, 0);
    }
    return self;
}


- (void)dealloc {
    lua_close(L);
    [super dealloc];
}


- (void)doFile:(NSString *)path {
    luaL_dofile(L, [path UTF8String]);
}


- (void)doFileNamed:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"lua"];
    [self doFile:path];
}


- (id)callResultOfCode:(NSString *)code withObject:(id)obj {
    luaL_dostring(L, [code UTF8String]);
    // there should now be a function on top of the stack
    int type = lua_type(L, -1);
    id result = nil;
    if (type == LUA_TFUNCTION) {
        [self pushObject:obj];
        lua_pcall(L, 1, 1, 0);
        result = [self toObject:-1];
    } else {
        NSLog(@"Hey! The result of your code was not a function.");
    }
    
    lua_settop(L, 0);
    return result;
}


- (id)toObject:(int)idx {
    int stackIdx = idx < 0 ? (lua_gettop(L) + 1 + idx) : idx;
    switch (lua_type(L, stackIdx)) {
        case LUA_TNUMBER:
            return [NSNumber numberWithDouble:lua_tonumber(L, stackIdx)];
        case LUA_TSTRING:
            return [NSString stringWithUTF8String:lua_tostring(L, stackIdx)];
        case LUA_TTABLE: {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            lua_pushnil(L);
            while (lua_next(L, stackIdx)) {
                id obj = [self toObject:-1];
                id key = [self toObject:-2];
                if (obj && key) {
                    [dict setObject:obj forKey:key];
                }
                lua_pop(L, 1);
            }
            return dict;
        }
        default:
            return nil;
    }
}


- (NSArray *)doString:(NSString *)code {
    luaL_dostring(L, [code UTF8String]);
    NSMutableArray *results = [NSMutableArray array];
    int top = lua_gettop(L);
    for (int ii = 1; ii <= top; ii++) {
        id obj = [self toObject:ii];
        if (obj) {
            [results addObject:obj];
        }
    }
    lua_settop(L, 0);
    return [NSArray arrayWithArray:results];
}


- (void)pushObject:(id)obj {
    if ([obj isKindOfClass:[NSDictionary class]]) {
        // push a Lua table
        lua_newtable(L);
        for (id key in [obj allKeys]) {
            [self pushObject:key];
            [self pushObject:[obj objectForKey:key]];
            lua_settable(L, -3);
        }
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        lua_pushnumber(L, [obj floatValue]);
    } else if ([obj isKindOfClass:[NSString class]]) {
        lua_pushstring(L, [obj UTF8String]);
    } else {
        lua_pushnil(L);
    }
}


- (void)setGlobal:(NSString *)name value:(id)value {
    [self pushObject:value];
    lua_setglobal(L, [name UTF8String]);
    lua_settop(L, 0);
}


- (id)performSelectorOnDelegate:(SEL)selector withObject:(id)obj {
    return [delegate performSelector:selector withObject:obj];
}


@end
