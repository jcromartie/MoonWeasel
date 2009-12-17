//
//  MoonWeasel.m
//  MoonWeaselApp
//
//  Created by john on 12/16/09.
//  Copyright 2009 John Cromartie. All rights reserved.
//

#import "MoonWeasel.h"

#import "lapi.h"
#import "lualib.h"
#import "lauxlib.h"

#define MW_SERVER_KEY "MoonWeasel_server"


@interface MoonWeasel (Private)
- (void)handleRequest:(const struct mg_request_info *)info connection:(struct mg_connection *)conn;
- (id)toObject:(int)idx;
- (id)performSelectorOnDelegate:(SEL)selector withObject:(id)obj;
- (void)pushObject:(id)obj;
@end


int mw_delegate(lua_State *L) {
    lua_getfield(L, LUA_REGISTRYINDEX, MW_SERVER_KEY);
    MoonWeasel *me = lua_touserdata(L, -1);

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


void MoonWeaselHandler(struct mg_connection *conn,
                       const struct mg_request_info *info, void *user_data)
{
    MoonWeasel *me = (MoonWeasel *)user_data;
    [me handleRequest:info connection:conn];
}

@implementation MoonWeasel

@synthesize port;
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
    [self stop];
    mg = NULL;
    lua_close(L);
    L = NULL;
    [super dealloc];
}


- (void)configurePort {
    if (mg) {
        mg_set_option(mg, "ports", [[NSString stringWithFormat:@"%i", self.port] UTF8String]);
    }
}


- (void)setPort:(NSUInteger)p {
    port = p;
    [self configurePort];
}


- (void)start {
    if (!mg) {
        mg = mg_start();
        [self configurePort];
        mg_set_uri_callback(mg, "/*", MoonWeaselHandler, self);
    }
}


- (void)stop {
    if (mg) {
        mg_stop(mg);
        mg = NULL;
    }
}


- (void)doFile:(NSString *)path {
    luaL_dofile(L, [path UTF8String]);
}


- (void)doFileNamed:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"lua"];
    [self doFile:path];
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
}


- (void)handleRequest:(const struct mg_request_info *)info connection:(struct mg_connection *)conn {
    lua_getglobal(L, "moonweasel");
    lua_getfield(L, -1, "handle");
    lua_newtable(L);
    lua_pushstring(L, info->uri);
    lua_setfield(L, -2, "uri");
    lua_pushstring(L, info->query_string);
    lua_setfield(L, -2, "querystring");
    if (lua_pcall(L, 1, 1, 0)) {
        const char *err = lua_tostring(L, -1);
        mg_printf(conn, "HTTP/1.1 500 Internal Server Error\r\n"
                  "content-Type: text/html\r\n\r\n"
                  "There was an error processing your request: %s", err);
    } else {
        const char *result = lua_tostring(L, -1);
        mg_printf(conn, "HTTP/1.1 200 OK\r\n"
                  "content-Type: text/html\r\n\r\n"
                  "%s", result);
    }
    lua_settop(L, 0);
}


- (id)performSelectorOnDelegate:(SEL)selector withObject:(id)obj {
    return [delegate performSelector:selector withObject:obj];
}


@end
