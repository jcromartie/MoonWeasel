//
//  MoonWeasel.h
//  MoonWeaselApp
//
//  Created by john on 12/16/09.
//  Copyright 2009 John Cromartie. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "lua.h"
#import "mongoose.h"

@interface MoonWeasel : NSObject {
    lua_State *L;
    struct mg_context *mg;
    NSUInteger port;
    id delegate;
}

// you can set the port at any point in the server's lifecyle
@property (nonatomic, assign) NSUInteger port;
@property (nonatomic, assign) id delegate;

// starts and stops the web server
- (void)start;
- (void)stop;

- (void)doFile:(NSString *)path;

// evaluates a file by looking up a .lua file in the bundle
- (void)doFileNamed:(NSString *)name;

// evaluates the Lua code string returning an array of results (since Lua allows multiple return values)
- (NSArray *)doString:(NSString *)code;

- (void)setGlobal:(NSString *)name value:(id)value;

@end
