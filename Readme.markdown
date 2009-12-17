# What?

MoonWeasel lets you use Lua to serve HTTP from your iPhone app.

Using MoonWeasel is as easy as:

    MoonWeasel *server = [[MoonWeasel alloc] init];
    server.port = 8080;
    server.delegate = self;
    [server start];

From Lua you can perform arbitrary selectors (optionally with one argument) on the server's delegate.

    print("My delegate is " .. moonweasel.delegate("description"))

For each request `moonweasel.handle` takes a table of HTTP request information, and the string returned
is written to the HTTP response. Custom headers are coming soon. You should be able to write binary
data to the response, like images, etc.

Check out [main.lua](http://github.com/jcromartie/MoonWeasel/blob/master/MoonWeasel/scripts/main.lua) for
some examples of how to handle requests. A more refined approach may be demonstrated later.

# Features

1. Add a web server to your iPhone app.
2. Use Lua to write simple, fast, flexible HTTP request handlers.
3. Work with Objective-C by calling delegate methods from Lua.

# Un-features

MoonWeasel doesn't seek to do any templating or web app architecture. It only seeks to let you handle
HTTP requests in a simple, fast and flexible way. MoonWeasel will never try to incorporate an Objective-C/Lua
bridge. Check out [wax](http://github.com/probablycorey/wax) for that.

# FAQ

1. **What can I send to Lua? What do I get back from Lua?**
   
   You can send over NSDictionary, NSArray, NSNumber and NSString objects, in any combination
   allowed by those Foundation classes. They will be translated into Lua tables and values
   in an unsurprising way. Lua tables are translated to NSDictionary objects. Lua strings and
   numbers are translated to NSString and NSNumber objects. NSData is possible in the future,
   but only one-way (as a Lua string to be written to the HTTP response).

2. **You know that a mongoose isn't a kind of weasel, right?**
   
   Yeah, right! Next you're going to try to tell me that bears aren't a kind of dog.
