//
//  MoonWeaselAppAppDelegate.h
//  MoonWeaselApp
//
//  Created by john on 12/16/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MWLuaVMDelegate.h"

@interface MoonWeaselAppAppDelegate : NSObject <UIApplicationDelegate, MWLuaVMDelegate> {
    UIWindow *window;
    UITextView *textView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

