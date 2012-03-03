//
//  MapViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/22/11.
//  Copyright 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationController.h"
#import <MapKit/MapKit.h>
//#import "VenuesResp.h"
#import "MultiPOIDetailResp.h"
#import "User.h"
#import "DashboardViewController.h"
#import "MBProgressHUD.h"

@interface MapViewController : UIViewController <LocationControllerDelegate, MBProgressHUDDelegate> {
    
    MKMapView *currentMapView;
    LocationController *locationController;
    
    BOOL retreivedVenues;
    //CLLocation *currentLocation;
    
    //NSArray *mapAnnotations;
    //VenuesResp *venuesResponse;
    MultiPOIDetailResp *multiPOIResponse;
    
    //User *user;
    
    DashboardViewController *dashboardController;
    NSMutableArray *annotations;
    MBProgressHUD *HUD;
}
- (IBAction)locationButtonPressed:(id)sender;
@property (nonatomic, strong) IBOutlet MKMapView *currentMapView;
@property (nonatomic, strong)
LocationController *locationController;
//@property (nonatomic, retain) User *user;
@property (nonatomic, strong) DashboardViewController *dashboardController;
//@property (nonatomic, retain) CLLocation *currentLocation;

-(void)dashPressed;
- (IBAction)allPlacesPressed:(id)sender;
- (IBAction) annotationViewClick:(id) sender;

-(void)getVenues;

-(void)centerMapOnLocation:(CLLocation*)location;
-(void)addAnnotations;
-(void)refreshAnnotations;

@end
