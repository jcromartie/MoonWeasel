//
//  MWLuaFunction.h
//  MoonWeaselApp
//
//  Created by john on 12/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MWLuaVM;

@interface MWLuaFunction : NSObject {
    int _ref;
    MWLuaVM *_luaVM;
}

// pass nil for no-argument functions
- (id)callWithObject:(id)obj;

@end
