/*
 *  MWLuaVMDelegate.h
 *  MoonWeaselApp
 *
 *  Created by john on 12/20/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

@class MWLuaVM;

@protocol MWLuaVMDelegate <NSObject>
- (void)luaVM:(MWLuaVM *)vm didError:(NSString *)error;
@end
