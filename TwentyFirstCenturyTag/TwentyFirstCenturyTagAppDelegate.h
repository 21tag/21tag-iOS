//
//  TwentyFirstCenturyTagAppDelegate.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/19/11.
//  Copyright 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
#import <CoreLocation/CoreLocation.h>
#import "DashboardViewController.h"

@class TwentyFirstCenturyTagViewController;

@interface TwentyFirstCenturyTagAppDelegate : NSObject <UIApplicationDelegate, FBSessionDelegate> {

    Facebook *facebook;
    DashboardViewController *dashboardController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet TwentyFirstCenturyTagViewController *viewController;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) DashboardViewController *dashboardController;

-(void)didUpdateToLocation:(CLLocation*)location;

@end
