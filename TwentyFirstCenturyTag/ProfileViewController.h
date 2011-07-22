//
//  ProfileViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/23/11.
//  Copyright 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "TeamsResp.h"

@interface ProfileViewController : UIViewController <UITableViewDataSource> {
    
    UIImageView *profileImageView;
    UILabel *nameLabel;
    UITableView *profileTableView;
    
    NSArray *contentList;
    User *user;
    UIActivityIndicatorView *activityIndicator;
    UILabel *teamNameLabel;
    UILabel *teamInfoLabel;
    TeamsResp *teamsResponse;
}
@property (nonatomic, retain) IBOutlet UIImageView *profileImageView;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UITableView *profileTableView;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UILabel *teamNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *teamInfoLabel;

-(void)dashPressed;
@end
