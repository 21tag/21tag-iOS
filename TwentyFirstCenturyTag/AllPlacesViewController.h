//
//  AllPlacesViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/23/11.
//  Copyright 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "MultiPOIDetailResp.h"

@interface AllPlacesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *placesTableView;
    NSMutableArray *contentList;
    NSMutableArray *nearbyPlaces;
    
    //VenuesResp *venuesResponse;
    MultiPOIDetailResp *multiPOIresponse;
    DashboardViewController *dashboardController;
    CLLocation *currentLocation;
}
@property (nonatomic, retain) IBOutlet UITableView *placesTableView;
@property (nonatomic, retain) MultiPOIDetailResp *multiPOIresponse;
@property (nonatomic, retain) DashboardViewController *dashboardController;
@property (nonatomic, retain) CLLocation *currentLocation;


-(void)backPressed;
-(void)setupButtons;

-(void)searchPressed;

@end
