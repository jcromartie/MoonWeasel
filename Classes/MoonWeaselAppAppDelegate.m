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
    server.port = 8080;
    [server start];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
