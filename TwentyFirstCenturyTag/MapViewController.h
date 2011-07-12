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
#import "VenuesResp.h"
#import "User.h"
#import "DashboardViewController.h"

@interface MapViewController : UIViewController <LocationControllerDelegate> {
    
    MKMapView *currentMapView;
    LocationController *locationController;
    
    BOOL retreivedVenues;
    CLLocation *currentLocation;
    
    //NSMutableArray *mapAnnotations;
    VenuesResp *venuesResponse;
    User *user;
    
    DashboardViewController *dashboardController;
}
- (IBAction)locationButtonPressed:(id)sender;
@property (nonatomic, retain) IBOutlet MKMapView *currentMapView;
@property (nonatomic, retain)
LocationController *locationController;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) DashboardViewController *dashboardController;
@property (nonatomic, retain) CLLocation *currentLocation;

-(void)dashPressed;
- (IBAction)allPlacesPressed:(id)sender;
- (IBAction) annotationViewClick:(id) sender;

-(void)getVenues;

-(void)centerMapOnLocation:(CLLocation*)location;
-(void)addAnnotations;
-(void)refreshAnnotations;

@end
