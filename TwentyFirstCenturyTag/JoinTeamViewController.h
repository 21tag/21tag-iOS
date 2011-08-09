//
//  JoinTeamViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/21/11.
//  Copyright 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface JoinTeamViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate> {
    NSArray *contentList;
    UITableView *navigationTableView;
    UIImageView *statusImageView;
    
    MBProgressHUD *HUD;
}
@property (nonatomic, retain) IBOutlet UIImageView *statusImageView;

@property (nonatomic, retain)     NSArray *contentList;
@property (nonatomic, retain) IBOutlet UITableView *navigationTableView;

- (void)cancelPressed;
- (void)searchFriendsList;

@end
