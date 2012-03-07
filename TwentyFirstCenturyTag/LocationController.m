//
//  LocationController.m
//
//  Created by Jinru on 12/19/09.
//  Copyright 2009 Arizona State University. All rights reserved.
//

#import "LocationController.h"
#import "TwentyFirstCenturyTagAppDelegate.h"

static LocationController* sharedCLDelegate = nil;

@implementation LocationController
@synthesize locationManager, location, delegate;

- (id)init
{
 	self = [super init];
	if (self != nil) {
		self.locationManager = [[CLLocationManager alloc] init];
		self.locationManager.delegate = self;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
	}
	return self;
}

/*- (void)dealloc
{
}*/

#pragma mark -
#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager*)manager
	didUpdateToLocation:(CLLocation*)newLocation
		   fromLocation:(CLLocation*)oldLocation
{
	if([self.delegate conformsToProtocol:@protocol(LocationControllerDelegate)]) {
		[self.delegate locationUpdate:newLocation];
	}
    

    [(TwentyFirstCenturyTagAppDelegate*)[UIApplication sharedApplication].delegate didUpdateToLocation:location];
}

- (void)locationManager:(CLLocationManager*)manager
	   didFailWithError:(NSError*)error
{
	if([self.delegate conformsToProtocol:@protocol(LocationControllerDelegate)]) {
		[self.delegate locationError:error];
	}    
}

#pragma mark -
#pragma mark Singleton Object Methods

+ (LocationController*)sharedInstance {
    @synchronized(self) {
        if (sharedCLDelegate == nil) {
            sharedCLDelegate = [[self alloc] init];
        }
    }
    return sharedCLDelegate;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedCLDelegate == nil) {
            sharedCLDelegate = [super allocWithZone:zone];
            return sharedCLDelegate;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


@end
