/*
 *  MWLuaFunction_Internal.h
 *  MoonWeaselApp
 *
 *  Created by john on 12/20/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

@interface MWLuaFunction ()
- (id)initWithRef:(int)ref inVM:(MWLuaVM *)vm;
- (int)ref;
@end