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

@interface MapViewController : UIViewController <LocationControllerDelegate> {
    
    MKMapView *currentMapView;
    LocationController *locationController;
    
    BOOL retreivedVenues;
    CLLocation *currentLocation;
    
    //NSMutableArray *mapAnnotations;
    VenuesResp *venuesResponse;
}
- (IBAction)locationButtonPressed:(id)sender;
@property (nonatomic, retain) IBOutlet MKMapView *currentMapView;
@property (nonatomic, retain)
LocationController *locationController;

-(void)dashPressed;
- (IBAction)allPlacesPressed:(id)sender;
- (IBAction) annotationViewClick:(id) sender;

-(void)getVenues;

@end
