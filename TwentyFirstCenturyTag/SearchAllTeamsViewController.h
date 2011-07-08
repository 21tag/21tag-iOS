//
//  SearchAllTeamsViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchAllTeamsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate> {
    UITableView *mainTableView;
	
    NSMutableArray *contentsList;
    NSMutableArray *searchResults;
    NSString *savedSearchTerm;
}

@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) NSMutableArray *contentsList;
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, copy) NSString *savedSearchTerm;

- (void)handleSearchForTerm:(NSString *)searchTerm;

-(void)backPressed;

@end
