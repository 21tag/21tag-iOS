//
//  PlaceAnnotation.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceAnnotation.h"


@implementation PlaceAnnotation

@synthesize latitude;
@synthesize longitude;
- (id) initWithLatitude:(CLLocationDegrees) lat longitude:(CLLocationDegrees) lng {
	latitude = lat;
	longitude = lng;
	return self;
}
- (CLLocationCoordinate2D) coordinate {
	CLLocationCoordinate2D coord = {self.latitude, self.longitude};
	return coord;
}
- (NSString *) title {
    return @"Club Passim";
}
- (NSString *) subtitle {
    return @"Check-in Here";
}
@end
