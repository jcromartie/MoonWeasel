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
    MWServer *server = [[MWServer alloc] init];
    server.luaVM.delegate = self;
    server.port = 8080;
    [server start];

    // run a little code
    NSArray *results = [server.luaVM doString:@"return dostuff()"];
    NSDictionary *table = [results objectAtIndex:0];
    NSLog(@"result #1 is %@", table);
    NSLog(@"calling fn yields: %@", [[table objectForKey:@"fn"] callWithObject:@"Hello!"]);

    [server.luaVM doString:@"greeting = \"Hello, \""];

    [window makeKeyAndVisible];
    textView = [[UITextView alloc] initWithFrame:window.bounds];
    textView.text = @"waiting...";
    [window addSubview:textView];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


#pragma mark MoonWeasel delegate methods


- (id)pathForScript:(NSString *)name {
    return [[NSBundle mainBundle] pathForResource:name ofType:@"lua"];
}


- (id)setText:(NSString *)text {
    textView.text = text;
    return nil;
}


- (id)contentsOfFileNamed:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
}


#pragma mark Lua error methods


- (void)luaVM:(MWLuaVM *)vm didError:(NSString *)error {
    NSLog(@"Oops! there was an error in Lua: %@", error);
}


@end
