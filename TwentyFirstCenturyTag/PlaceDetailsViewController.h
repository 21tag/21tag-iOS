//
//  PlaceDetailsViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/29/11.
//  Copyright 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venue.h"
#import "MapViewController.h"
#import "POIDetailResp.h"
#import "Events.h"
#import "MBProgressHUD.h"
#import "TeamsResp.h"

@interface PlaceDetailsViewController : UIViewController <UITableViewDataSource, MBProgressHUDDelegate, UIActionSheetDelegate> {
    
    UIScrollView *detailsScrollView;
    UIImageView *detailsImageView;
    UILabel *placeNameLabel;
    UILabel *yourPointsLabel;
    UILabel *yourCheckinsLabel;
    UILabel *yourTeamPointsLabel;
    UILabel *yourTeamNameLabel;
    UILabel *owningTeamNameLabel;
    UILabel *owningTeamPointsLabel;
    UITableView *detailsTableView;
    UIButton *largeCheckinButton;
    NSMutableArray *contentList;
    User * user;
    
    Venue *venue;
    POIDetailResp *poiResponse;
    MapViewController *mapViewController;
    DashboardViewController *dashboardController;
    
    Events *eventsResponse;
    
    MBProgressHUD *HUD;
}
@property (nonatomic, strong) IBOutlet UIScrollView *detailsScrollView;
@property (nonatomic, strong) IBOutlet UIImageView *detailsImageView;
@property (nonatomic, strong) IBOutlet UILabel *placeNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *yourPointsLabel;
@property (nonatomic, strong) IBOutlet UILabel *yourCheckinsLabel;
@property (nonatomic, strong) IBOutlet UILabel *yourTeamPointsLabel;
@property (nonatomic, strong) IBOutlet UILabel *yourTeamNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *owningTeamNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *owningTeamPointsLabel;
@property (nonatomic, strong) IBOutlet UIButton *largeCheckinButton;
@property (nonatomic, strong) IBOutlet UITableView *detailsTableView;

@property (nonatomic, strong)     NSMutableArray *contentList;
@property (nonatomic, strong) Venue *venue;
@property (nonatomic, strong) NSString *venueId;
@property (nonatomic, strong) DashboardViewController *dashboardController;
@property (nonatomic, strong) MapViewController *mapViewController;
@property (nonatomic, strong) POIDetailResp *poiResponse;

@property (nonatomic, strong) UIBarButtonItem *checkoutButton;
@property (nonatomic, strong) UIBarButtonItem *checkinButton;


- (void) setupButtons;
- (void) backPressed;
- (IBAction)checkinButtonPressed:(id)sender;
- (void)checkoutButtonPressed;
- (void)updateData;
- (NSString *) modifyMessage:(NSString *)message;

@end
