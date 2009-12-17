//
//  MoonWeaselAppAppDelegate.m
//  MoonWeaselApp
//
//  Created by john on 12/16/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "MoonWeaselAppAppDelegate.h"

#import "MoonWeasel.h"

@implementation MoonWeaselAppAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    MoonWeasel *server = [[MoonWeasel alloc] init];
    server.delegate = self;
    server.port = 8080;
    [server start];

    // push some objects
    [server setGlobal:@"greeting" value:@"Howdy "];
    [server setGlobal:@"stuff" value:[NSDictionary dictionaryWithObjectsAndKeys:
                                      @"zort", @"foo",
                                      [NSNumber numberWithFloat:0.42], @"bar",
                                      nil]];

    // run a little code
    NSArray *results = [server doString:@"return dostuff()"];
    NSLog(@"result #1 is %@", [results objectAtIndex:0]);

    [window makeKeyAndVisible];
}


- (id)pathForScript:(NSString *)name {
    return [[NSBundle mainBundle] pathForResource:name ofType:@"lua"];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
