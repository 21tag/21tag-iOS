//
//  MapViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationController.h"
#import <MapKit/MapKit.h>


@interface MapViewController : UIViewController <LocationControllerDelegate> {
    
    MKMapView *currentMapView;
    LocationController *locationController;
}
- (IBAction)locationButtonPressed:(id)sender;
@property (nonatomic, retain) IBOutlet MKMapView *currentMapView;
@property (nonatomic, retain)
LocationController *locationController;

-(void)dashPressed;
- (IBAction)allPlacesPressed:(id)sender;
- (IBAction) annotationViewClick:(id) sender;

@end
