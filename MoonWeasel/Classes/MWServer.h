//
//  MoonWeasel.h
//  MoonWeaselApp
//
//  Created by john on 12/16/09.
//  Copyright 2009 John Cromartie. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "mongoose.h"

@class MWLuaVM;

@interface MWServer : NSObject {
    struct mg_context *mg;
    NSUInteger port;
    MWLuaVM *luaVM;
}

// you can set the port at any point in the server's lifecyle
@property (nonatomic, assign) NSUInteger port;
@property (nonatomic, readonly) MWLuaVM *luaVM;

// starts and stops the web server
- (void)start;
- (void)stop;

@end
