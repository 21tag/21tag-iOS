//
//  TeamInfoViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/22/11.
//  Copyright 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamsResp.h"

@interface TeamInfoViewController : UIViewController {
    
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
    UIActivityIndicatorView *activityIndicator;
    
    NSMutableArray *contentList;
    UITableView *mainTableView;
    NSString *teamName;
    
    TeamsResp *teamsResponse;
}
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
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

@property (nonatomic, retain) NSMutableArray *contentList;
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) NSString *teamName;


@property BOOL isJoiningTeam;

- (IBAction)teamMembersPressed:(id)sender;
- (IBAction)locationsOwnedPressed:(id)sender;
- (IBAction)teamPointsPressed:(id)sender;

- (void)backPressed;
- (void)joinPressed;
- (void)leavePressed;

@end
