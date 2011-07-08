//
//  PlaceAnnotation.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/18/11.
//  Copyright 2011 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Venue.h"

@interface PlaceAnnotation : NSObject <MKAnnotation>
{
    Venue *venue;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property CLLocationDegrees latitude;
@property CLLocationDegrees longitude;

- (NSString *) title;
- (NSString *) subtitle;

- (id) initWithVenue:(Venue*) newVenue;


@end
