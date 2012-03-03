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
@property (nonatomic, strong) IBOutlet UITableView *placesTableView;
@property (nonatomic, strong) MultiPOIDetailResp *multiPOIresponse;
@property (nonatomic, strong) DashboardViewController *dashboardController;
@property (nonatomic, strong) CLLocation *currentLocation;


-(void)backPressed;
-(void)setupButtons;

-(void)searchPressed;

@end
