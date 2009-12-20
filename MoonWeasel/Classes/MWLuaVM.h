//
//  MWLuaVM.h
//  MoonWeaselApp
//
//  Created by john on 12/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "lua.h"

@interface MWLuaVM : NSObject {
    lua_State *L;
    id delegate;
}

@property (nonatomic, assign) id delegate;

- (void)doFile:(NSString *)path;

// evaluates a file by looking up a .lua file in the bundle
- (void)doFileNamed:(NSString *)name;

// evaluates the Lua code string returning an array of results (since Lua allows multiple return values)
- (NSArray *)doString:(NSString *)code;

// evaluates the Lua code and then calls it withe the single object argument
- (id)callResultOfCode:(NSString *)code withObject:(id)obj;

- (void)setGlobal:(NSString *)name value:(id)value;

@end
