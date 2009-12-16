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

@interface MoonWeasel (Private)
- (void)handleRequest:(const struct mg_request_info *)info connection:(struct mg_connection *)conn;
@end


void MoonWeaselHandler(struct mg_connection *conn,
                       const struct mg_request_info *info, void *user_data)
{
    NSLog(@"handler function called");
    MoonWeasel *me = (MoonWeasel *)user_data;
    [me handleRequest:info connection:conn];
}

@implementation MoonWeasel

@synthesize port;

- (id)init {
    if ((self = [super init])) {
        L = lua_open();
        luaL_openlibs(L);
        NSString *path = [[NSBundle mainBundle] pathForResource:@"main.lua" ofType:nil];
        NSLog(@"path is %@", path);
        luaL_dofile(L, [path UTF8String]);
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
        NSLog(@"Started server");
    }
}


- (void)stop {
    if (mg) {
        mg_stop(mg);
        mg = NULL;
    }
}


- (void)pushObject:(id)obj {
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Dict");
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
    NSLog(@"pushing object");
    [self pushObject:value];
    NSLog(@"setting global");
    lua_setglobal(L, [name UTF8String]);
}


- (void)handleRequest:(const struct mg_request_info *)info connection:(struct mg_connection *)conn {
    NSLog(@"Handler method");

    lua_getglobal(L, "get");
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
}


@end
