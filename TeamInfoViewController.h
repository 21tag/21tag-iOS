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

@interface TeamInfoViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, MBProgressHUDDelegate, UIAlertViewDelegate>  {
    
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
    NSString *teamId;
    
    TeamsResp *teamsResponse;
    Team * team;
    
    NSArray *usersList;
    NSArray *locationsList;
    NSArray *rankingsList;
    
    BOOL teamMembersHighlighted;
    BOOL locationsOwnedHighlighted;
    BOOL teamPointsHighlighted;
    
    DashboardViewController *dashboardController;
    
    MBProgressHUD *HUD;
    
    BOOL isYourTeam;
}
@property (nonatomic, strong) IBOutlet UIImageView *teamImage;
@property (nonatomic, strong) IBOutlet UILabel *teamNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *teamSloganLabel;
@property (nonatomic, strong) IBOutlet UIButton *teamMembersButton;
@property (nonatomic, strong) IBOutlet UIButton *locationsOwnedButton;
@property (nonatomic, strong) IBOutlet UIButton *teamPointsButton;
@property (nonatomic, strong) IBOutlet UILabel *tableHeaderLabel;
@property (nonatomic, strong) IBOutlet UILabel *teamMembersLabel;
@property (nonatomic, strong) IBOutlet UILabel *locationsOwnedLabel;
@property (nonatomic, strong) IBOutlet UILabel *teamPointsLabel;

@property (nonatomic, strong) NSArray *contentList;
@property (nonatomic, strong) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong)     DashboardViewController *dashboardController;
@property (nonatomic, strong) Team * team;



@property BOOL isJoiningTeam;

- (IBAction)teamMembersPressed:(id)sender;
- (IBAction)locationsOwnedPressed:(id)sender;
- (IBAction)teamPointsPressed:(id)sender;

- (void)backPressed;
- (void)joinPressed;
- (void)leavePressed;
- (void)deleteFromTeam:(BOOL)switchingTeam;
- (void)joinTeam;
- (void)refreshData;

-(void)leaveTeamPostprocessing;

-(void)switchTeams;

@end
