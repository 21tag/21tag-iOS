//
//  ProfileViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/23/11.
//  Copyright 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardViewController.h"
#import "User.h"
#import "TeamsResp.h"

@interface ProfileViewController : UIViewController <UITableViewDataSource, UIActionSheetDelegate, UITableViewDelegate> {
    
    UIImageView *profileImageView;
    UILabel *nameLabel;
    UITableView *profileTableView;
    
    NSArray *contentList;
    TeamsResp *teamsResponse;
    
    BOOL isYourProfile;
}
@property (nonatomic, retain) IBOutlet UIImageView *profileImageView;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UITableView *profileTableView;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) DashboardViewController *dashboardController;
@property BOOL isYourProfile;


-(void)backPressed;
-(void)setupButtons;
-(void)accountPressed;

@end
