//
//  MoonWeasel.m
//  MoonWeaselApp
//
//  Created by john on 12/16/09.
//  Copyright 2009 John Cromartie. All rights reserved.
//

#import "MWServer.h"

#import "MWLuaVM.h"

@interface MWServer (Private)
- (void)handleRequest:(const struct mg_request_info *)info connection:(struct mg_connection *)conn;
@end


void MoonWeaselHandler(struct mg_connection *conn,
                       const struct mg_request_info *info, void *user_data)
{
    MWServer *me = (MWServer *)user_data;
    [me handleRequest:info connection:conn];
}

@implementation MWServer

@synthesize port;
@synthesize luaVM;

- (id)init {
    if ((self = [super init])) {
        luaVM = [[MWLuaVM alloc] init];
    }
    return self;
}


- (void)dealloc {
    [self stop];
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


- (void)handleRequest:(const struct mg_request_info *)info connection:(struct mg_connection *)conn {
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
    if (info->uri) {
        [infoDict setObject:[NSString stringWithUTF8String:info->uri] forKey:@"uri"];
    }
    if (info->query_string) {
        [infoDict setObject:[NSString stringWithUTF8String:info->query_string] forKey:@"querystring"];
    }
    if (0 < info->num_headers) {
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithCapacity:info->num_headers];
        for (int ii = 0; ii < info->num_headers; ii++) {
            char *name = info->http_headers[ii].name;
            char *value = info->http_headers[ii].value;
            if (name && value) {
                [headers setObject:[NSString stringWithUTF8String:value]
                            forKey:[NSString stringWithUTF8String:name]];
            }
        }
        [infoDict setObject:headers forKey:@"headers"];
    }
    id result = [luaVM callResultOfCode:@"return moonweasel.handle" withObject:infoDict];
    if (result) {
        mg_printf(conn, "HTTP/1.1 200 OK\r\n"
                  "content-Type: text/html\r\n\r\n"
                  "%s", [[result description] UTF8String]);
    } else {
        //        const char *err = lua_tostring(L, -1);
        mg_printf(conn, "HTTP/1.1 500 Internal Server Error\r\n"
                  "content-Type: text/html\r\n\r\n"
                  "There was an error processing your request.");
    }
    [pool drain];
}


@end
