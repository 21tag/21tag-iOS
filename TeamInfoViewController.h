//
//  TeamInfoViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/22/11.
//  Copyright 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardViewController.h"
#import "TeamsResp.h"
#import "MBProgressHUD.h"

@interface TeamInfoViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, MBProgressHUDDelegate>  {
    
    UIImageView *teamImage;
    UILabel *teamNameLabel;
    UILabel *teamSloganLabel;
    UIButton *teamMembersButton;
    UIButton *locationsOwnedButton;
    UIButton *teamPointsButton;
    UILabel *tableHeaderLabel;
    UILabel *teamMembersLabel;
    UILabel *locationsOwnedLabel;
    UILabel *teamPointsLabel;
    
    NSArray *contentList;
    UITableView *mainTableView;
    NSString *teamName;
    
    TeamsResp *teamsResponse;
    
    NSArray *usersList;
    NSArray *locationsList;
    NSArray *rankingsList;
    
    BOOL teamMembersHighlighted;
    BOOL locationsOwnedHighlighted;
    BOOL teamPointsHighlighted;
    
    DashboardViewController *dashboardController;
    
    MBProgressHUD *HUD;
}
@property (nonatomic, retain) IBOutlet UIImageView *teamImage;
@property (nonatomic, retain) IBOutlet UILabel *teamNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *teamSloganLabel;
@property (nonatomic, retain) IBOutlet UIButton *teamMembersButton;
@property (nonatomic, retain) IBOutlet UIButton *locationsOwnedButton;
@property (nonatomic, retain) IBOutlet UIButton *teamPointsButton;
@property (nonatomic, retain) IBOutlet UILabel *tableHeaderLabel;
@property (nonatomic, retain) IBOutlet UILabel *teamMembersLabel;
@property (nonatomic, retain) IBOutlet UILabel *locationsOwnedLabel;
@property (nonatomic, retain) IBOutlet UILabel *teamPointsLabel;

@property (nonatomic, retain) NSArray *contentList;
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain)     DashboardViewController *dashboardController;



@property BOOL isJoiningTeam;

- (IBAction)teamMembersPressed:(id)sender;
- (IBAction)locationsOwnedPressed:(id)sender;
- (IBAction)teamPointsPressed:(id)sender;

- (void)backPressed;
- (void)joinPressed;
- (void)leavePressed;

@end
