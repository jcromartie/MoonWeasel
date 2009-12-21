/*
 *  MoonWeasel.h
 *  MoonWeaselApp
 *
 *  Created by john on 12/20/09.
 *  Copyright 2009 John Cromartie. All rights reserved.
 *
 */


/*
 * READ ME FIRST!
 *
 * Just a few details about the VM class: Firstly, all delegate methods
 * are performed on the main thread, so they are safe to do any UIKit stuff
 * that you might want to do from Lua. All VM methods should be called
 * on the main thread as well, as the Lua VM itself is not thread-safe.
 *
 */


#import "MWLuaVM.h"
#import "MWServer.h"
#import "MWLuaFunction.h"
#import "MWLuaVMDelegate.h"