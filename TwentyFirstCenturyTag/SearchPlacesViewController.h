//
//  SearchPlacesViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/29/11.
//  Copyright 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "MultiPOIDetailResp.h"

@interface SearchPlacesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate> {
    UITableView *mainTableView;
	
    NSMutableArray *contentsList;
    NSMutableArray *searchResults;
    NSString *savedSearchTerm;

    //VenuesResp *venuesResponse;
    MultiPOIDetailResp *multiPOIresponse;
    
    BOOL isSearching;
    
    //MapViewController *mapViewController;
    DashboardViewController *dashController;

    NSMutableArray *venuesSearchResults;
}

@property (nonatomic, strong) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *contentsList;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, copy) NSString *savedSearchTerm;

- (void)handleSearchForTerm:(NSString *)searchTerm;

@property (nonatomic, strong)     MultiPOIDetailResp *multiPOIresponse;
@property (nonatomic, strong)     DashboardViewController *dashController;


-(void)backPressed;

@end
