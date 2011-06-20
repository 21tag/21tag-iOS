//
//  TwentyFirstCenturyTagAppDelegate.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"

@class TwentyFirstCenturyTagViewController;

@interface TwentyFirstCenturyTagAppDelegate : NSObject <UIApplicationDelegate> {

    Facebook *facebook;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet TwentyFirstCenturyTagViewController *viewController;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) Facebook *facebook;

@end
