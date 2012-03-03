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

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet TwentyFirstCenturyTagViewController *viewController;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic, strong) DashboardViewController *dashboardController;

-(void)didUpdateToLocation:(CLLocation*)location;

-(void)setIfUsingBackgroundLocation;

@end
