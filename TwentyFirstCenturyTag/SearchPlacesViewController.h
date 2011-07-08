//
//  SearchPlacesViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/29/11.
//  Copyright 2011 . All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchPlacesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate> {
    UITableView *mainTableView;
	
    NSMutableArray *contentsList;
    NSMutableArray *searchResults;
    NSString *savedSearchTerm;
    UINavigationBar *navBar;
    UINavigationItem *navItem;
}

@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) NSMutableArray *contentsList;
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, copy) NSString *savedSearchTerm;

- (void)handleSearchForTerm:(NSString *)searchTerm;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) IBOutlet UINavigationItem *navItem;

-(void)cancelPressed;

@end
