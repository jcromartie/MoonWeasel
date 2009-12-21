//
//  MWLuaFunction.m
//  MoonWeaselApp
//
//  Created by john on 12/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MWLuaFunction.h"
#import "MWLuaFunction_Internal.h"

#import "MWLuaVM.h"
#import "MWLuaVM_Internal.h"

@implementation MWLuaFunction

- (id)initWithRef:(int)ref inVM:(MWLuaVM *)vm {
    if ((self = [super init])) {
        _luaVM = [vm retain];
        _ref = ref;
    }
    return self;
}


- (void)dealloc {
    [_luaVM unregister:self];
    [_luaVM release];
    [super dealloc];
}


- (int)ref {
    return _ref;
}


- (id)call {
    return [_luaVM callFunction:self withObject:nil];
}


- (id)callWithObject:(id)obj {
    return [_luaVM callFunction:self withObject:obj];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<Lua Function %i>", _ref];
}

@end
