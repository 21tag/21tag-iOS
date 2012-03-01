//
//  SearchAllTeamsViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/29/11.
//  Copyright 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamsResp.h"
#import "MBProgressHUD.h"

@interface SearchAllTeamsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, MBProgressHUDDelegate> {
    BOOL isLoadingTeams;
    TeamsResp *teamsResponse;
    
    BOOL isSearching;
    
    MBProgressHUD *HUD;
}

@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) NSMutableArray *contentsList;
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, copy) NSString *savedSearchTerm;

- (void)handleSearchForTerm:(NSString *)searchTerm;

-(void)backPressed;

@end
