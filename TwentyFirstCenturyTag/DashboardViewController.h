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
#import "Team.h"
#import "LocationController.h"
#import "MBProgressHUD.h"

@interface DashboardViewController : UIViewController <FBRequestDelegate, UITableViewDelegate, UITableViewDataSource, LocationControllerDelegate, MBProgressHUDDelegate, UIAlertViewDelegate, UIActionSheetDelegate> {
    
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
    Team *team;
    
    NSTimer *checkinTimer;
    LocationController *locationController;
    CLLocation *currentLocation;
    int fiveMinuteCounter;
    NSDate *checkinTime;
    NSTimer *dashboardTimer;
    NSDate *lastCheckinTime;
    int localPoints;
    
    MBProgressHUD *HUD;
    
    BOOL profileFinishedLoading;
    BOOL locationFinishedLoading;
}
@property (nonatomic, strong) IBOutlet UITableView *navigationTableView;
@property (nonatomic, strong) NSMutableArray *contentList;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Venue *currentVenue;
@property (nonatomic, strong) NSTimer *checkinTimer;
@property (nonatomic, strong) NSDate *lastCheckinTime;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) NSDate *checkinTime;
@property (nonatomic, strong) LocationController *locationController;
@property (nonatomic, strong) Team *team;
@property (nonatomic)         int localPoints;

@property (nonatomic, strong) UIBarButtonItem *checkinButton;
@property (nonatomic, strong) UIBarButtonItem *checkoutButton;



- (void)setupButtons;
- (void)checkinPressed;
- (void)settingsPressed;
- (void) checkinUpdate:(NSTimer *) timer;
- (void) updateDashboard:(NSTimer *) timer;
- (void) viewCurrentVenue;
- (void)checkout;
- (void)checkoutButtonPressed;


@end
