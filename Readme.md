MoonWeasel lets you use Lua to write request handlers for an embedded web server hosted in your iPhone app.

Using MoonWeasel is as easy as this:

    - (void)applicationDidFinishLaunching:(UIApplication *)application {    
        MoonWeasel *server = [[MoonWeasel alloc] init];
        server.port = 8080;
        [server start];
        [window makeKeyAndVisible];
    }

You can pass data to the server's Lua VM like this:

    [server setGlobal:@"greeting" value:@"Howdy "];
    [server setGlobal:@"stuff" value:[NSDictionary dictionaryWithObjectsAndKeys:
                                      @"zort", @"foo",
                                      [NSNumber numberWithFloat:0.42], @"bar",
                                      nil]];

You should note that it's only this easy because that's all it does. New features should be coming soon.

Check out MoonWeasel/scripts/main.lua for an example of how to handle requests.
