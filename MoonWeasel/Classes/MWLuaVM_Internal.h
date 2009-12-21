/*
 *  MWLuaVM_Internal.h
 *  MoonWeaselApp
 *
 *  Created by john on 12/20/09.
 *  Copyright 2009 John Cromartie. All rights reserved.
 *
 */

@class MWLuaFunction;

@interface MWLuaVM ()

- (void)setGlobal:(NSString *)name value:(id)value;
- (id)callFunction:(MWLuaFunction *)fn withObject:(id)obj;
- (void)unregister:(MWLuaFunction *)fn;

@end
