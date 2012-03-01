//
//  NetworkRankingsViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/23/11.
//  Copyright 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StandingsResp.h"
#import "TeamsResp.h"
#import "MBProgressHUD.h"
#import "DashboardViewController.h"

@interface NetworkRankingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>
{
    TeamsResp *teamsResponse;
    StandingsResp *standingsResponse;
    MBProgressHUD *HUD;
    NSArray *standingsArray;
}
@property (retain, nonatomic) IBOutlet UITableView *standingsTableView;
@property (nonatomic, retain) DashboardViewController *dashboardController;

-(void)backButtonPressed;
@end
