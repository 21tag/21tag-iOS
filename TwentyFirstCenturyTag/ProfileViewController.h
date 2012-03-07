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
#import "JoinTeamViewController.h"

@interface ProfileViewController : UIViewController <UITableViewDataSource, UIActionSheetDelegate, UITableViewDelegate> {
    
    UIImageView *profileImageView;
    UILabel *nameLabel;
    UITableView *profileTableView;
    
    NSArray *contentList;
    Team *team;
    
    BOOL isYourProfile;
}
@property (nonatomic, strong) IBOutlet UIImageView *profileImageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UITableView *profileTableView;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) DashboardViewController *dashboardController;
@property (nonatomic, strong) NSString * numberMembers;
@property BOOL isYourProfile;


-(void)backPressed;
-(void)setupButtons;
-(void)accountPressed;

@end
