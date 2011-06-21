//
//  LocationController.h
//
//  Created by Jinru on 12/19/09.
//  Copyright 2009 Arizona State University. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

// protocol for sending location updates to another view controller
@protocol LocationControllerDelegate <NSObject>
@required
- (void)locationUpdate:(CLLocation*)location;
- (void)locationError:(NSError *)error;
@end

@interface LocationController : NSObject <CLLocationManagerDelegate> {
    
	CLLocationManager* locationManager;
	CLLocation* location;
	id delegate;
}

@property (nonatomic, retain) CLLocationManager* locationManager;
@property (nonatomic, retain) CLLocation* location;
@property (nonatomic, assign) id <LocationControllerDelegate> delegate;

+ (LocationController*)sharedInstance; // Singleton method

@end
