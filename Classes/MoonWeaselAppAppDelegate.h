//
//  MoonWeaselAppAppDelegate.h
//  MoonWeaselApp
//
//  Created by john on 12/16/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoonWeaselAppAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UILabel *label;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

