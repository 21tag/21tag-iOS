//
//  DashboardViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/20/11.
//  Copyright 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
#import "User.h"
#import "LocationController.h"
#import "MBProgressHUD.h"

@interface DashboardViewController : UIViewController <FBRequestDelegate, UITableViewDelegate, UITableViewDataSource, LocationControllerDelegate, MBProgressHUDDelegate> {
    
    NSMutableArray *contentList;
    UILabel *nameLabel;
    Facebook *facebook;
    BOOL isCheckedIn;
    UITableView *navigationTableView;
    UIImage *avatarImage;
    
    NSDictionary *facebookRequestResults;
    BOOL isRequestingFriendsList;
    
    User *user;
    Venue *currentVenue;
    
    NSTimer *checkinTimer;
    LocationController *locationController;
    CLLocation *currentLocation;
    int fiveMinuteCounter;
    NSDate *checkinTime;
    NSTimer *dashboardTimer;
    
    MBProgressHUD *HUD;
    
    BOOL profileFinishedLoading;
    BOOL locationFinishedLoading;
}
@property (nonatomic, retain) IBOutlet UITableView *navigationTableView;
@property (nonatomic, retain) NSMutableArray *contentList;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) Venue *currentVenue;
@property (nonatomic, retain) NSTimer *checkinTimer;
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) NSDate *checkinTime;


- (void)checkinPressed;
- (void) checkinUpdate:(NSTimer *) timer;
- (void) updateDashboard:(NSTimer *) timer;


@end
