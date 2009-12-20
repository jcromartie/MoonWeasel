//
//  MoonWeaselAppAppDelegate.m
//  MoonWeaselApp
//
//  Created by john on 12/16/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "MoonWeaselAppAppDelegate.h"

#import "MWServer.h"
#import "MWLuaVM.h"

@implementation MoonWeaselAppAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    MWServer *server = [[MWServer alloc] init];
    server.luaVM.delegate = self;
    server.port = 8080;
    [server start];

    // push some objects
    [server.luaVM setGlobal:@"greeting" value:@"Howdy "];
    [server.luaVM setGlobal:@"stuff" value:[NSDictionary dictionaryWithObjectsAndKeys:
                                      @"zort", @"foo",
                                      [NSNumber numberWithFloat:0.42], @"bar",
                                      nil]];

    // run a little code
    NSArray *results = [server.luaVM doString:@"return dostuff()"];
    NSLog(@"result #1 is %@", [results objectAtIndex:0]);

    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    label.text = @"hi";
    [window addSubview:label];
    [window makeKeyAndVisible];
}


- (id)pathForScript:(NSString *)name {
    return [[NSBundle mainBundle] pathForResource:name ofType:@"lua"];
}


- (id)setText:(NSString *)text {
    label.text = text;
    return nil;
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
