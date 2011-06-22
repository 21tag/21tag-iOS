//
//  JoinTeamViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JoinTeamViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *contentList;
    UITableView *navigationTableView;
}

@property (nonatomic, retain)     NSMutableArray *contentList;
@property (nonatomic, retain) IBOutlet UITableView *navigationTableView;

- (void)cancelPressed;

@end
