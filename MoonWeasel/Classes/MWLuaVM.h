//
//  MWLuaVM.h
//  MoonWeaselApp
//
//  Created by john on 12/19/09.
//  Copyright 2009 John Cromartie. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "MWLuaVMDelegate.h"
#import "lua.h"

@class MWLuaFunction;

@interface MWLuaVM : NSObject {
    lua_State *L;
    id <MWLuaVMDelegate> delegate;
}

@property (nonatomic, assign) id <MWLuaVMDelegate> delegate;

// evaluates the file at the given path
- (void)doFile:(NSString *)path;

// evaluates a ".lua" file in the main bundle
// NOTE: omit ".lua" from the name
- (void)doFileNamed:(NSString *)name;

// evaluates the Lua code string returning an array of results (since Lua allows multiple return values)
- (NSArray *)doString:(NSString *)code;

@end
