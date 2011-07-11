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

@interface DashboardViewController : UIViewController <FBRequestDelegate, UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray *contentList;
    UILabel *nameLabel;
    Facebook *facebook;
    BOOL isCheckedIn;
    UITableView *navigationTableView;
    UIImage *avatarImage;
    
    NSDictionary *facebookRequestResults;
    BOOL isRequestingFriendsList;
}
@property (nonatomic, retain) IBOutlet UITableView *navigationTableView;
@property (nonatomic, retain) NSMutableArray *contentList;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) Facebook *facebook;

- (void)checkinPressed;

@end
