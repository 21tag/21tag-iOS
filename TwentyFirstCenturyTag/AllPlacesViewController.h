//
//  AllPlacesViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/23/11.
//  Copyright 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VenuesResp.h"
#import "MapViewController.h"

@interface AllPlacesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *placesTableView;
    NSMutableArray *contentList;
    
    VenuesResp *venuesResponse;
    MapViewController *mapViewController;
    CLLocation *currentLocation;
}
@property (nonatomic, retain) IBOutlet UITableView *placesTableView;
@property (nonatomic, retain)     VenuesResp *venuesResponse;
@property (nonatomic, retain) MapViewController *mapViewController;
@property (nonatomic, retain) CLLocation *currentLocation;


-(void)backPressed;
-(void)setupButtons;

-(void)searchPressed;

@end
