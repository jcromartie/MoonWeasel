//
//  MoonWeasel.h
//  MoonWeaselApp
//
//  Created by john on 12/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "lua.h"
#import "mongoose.h"

@interface MoonWeasel : NSObject {
    lua_State *L;
    struct mg_context *mg;
    NSUInteger port;
}

- (void)start;
- (void)stop;

@property (nonatomic, assign) NSUInteger port;

@end
